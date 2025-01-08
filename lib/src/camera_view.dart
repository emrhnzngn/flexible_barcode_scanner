import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.onImage,
    this.onCameraFeedReady,
    this.onCameraLensDirectionChanged,
    this.initialCameraLensDirection = CameraLensDirection.back,
    required this.customOverlay,
    this.backButtonIconColor,
    this.flashButtonIconColor,
    this.switchCameraButtonIconColor,
    this.backButtonBackgroundColor,
    this.flashBackgroundColor,
    this.switchCameraBackgroundColor,
    this.backButtonIcon,
    this.flashButtonIcon,
    this.openedFlashIcon,
    this.switchCameraButtonIcon,
    this.loadingWidget,
  });

  /// Callback for processing images from the camera.
  final Function(InputImage inputImage) onImage;

  /// Callback triggered when the camera feed is ready.
  final VoidCallback? onCameraFeedReady;

  /// Callback for when the camera lens direction changes.
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;

  /// Sets the initial camera direction (front or back).
  final CameraLensDirection initialCameraLensDirection;

  /// Widget to display over the camera preview.
  final Widget? customOverlay;

  /// Optional UI customizations for the back button.
  final Color? backButtonIconColor;
  final Color? backButtonBackgroundColor;
  final Widget? backButtonIcon;

  /// Optional UI customizations for the flashlight button.
  final Color? flashButtonIconColor;
  final Color? flashBackgroundColor;
  final Widget? flashButtonIcon;
  final Widget? openedFlashIcon;

  /// Optional UI customizations for the switch camera button.
  final Color? switchCameraButtonIconColor;
  final Color? switchCameraBackgroundColor;
  final Widget? switchCameraButtonIcon;

  /// Optional loading widget while initializing the camera.
  final Widget? loadingWidget;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  bool _isSwitchingCamera = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Initializes the camera and selects the appropriate camera lens.
  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    _cameraIndex = _cameras.indexWhere(
        (camera) => camera.lensDirection == widget.initialCameraLensDirection);
    if (_cameraIndex == -1) _cameraIndex = 0; // Default to the first camera
    await _startLiveFeed();
  }

  /// Starts the live camera feed and image stream.
  Future<void> _startLiveFeed() async {
    if (_cameraIndex == -1 || _cameras.isEmpty) return;

    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller?.initialize();
    if (!mounted) return;

    await _controller?.startImageStream(_processCameraImage);
    widget.onCameraFeedReady?.call();
    widget.onCameraLensDirectionChanged?.call(camera.lensDirection);

    _controller?.setFocusMode(FocusMode.auto);
    setState(() {});
  }

  /// Stops the live camera feed and cleans up resources.
  Future<void> _stopLiveFeed() async {
    if (_isSwitchingCamera) return;
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  /// Switches between available cameras.
  Future<void> _switchCamera() async {
    if (_isSwitchingCamera) return;

    setState(() => _isSwitchingCamera = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _isSwitchingCamera = false);
  }

  /// Toggles the flashlight mode.
  void _toggleFlash() async {
    _isFlashOn = !_isFlashOn;
    await _controller
        ?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  /// Processes each camera frame and converts it to an [InputImage].
  void _processCameraImage(CameraImage image) {
    final inputImage = _createInputImage(image);
    if (inputImage != null) widget.onImage(inputImage);
  }

  /// Converts a [CameraImage] into an [InputImage] format for ML processing.
  InputImage? _createInputImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final rotation = _getImageRotation(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || image.planes.isEmpty) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Determines the image rotation based on the device and camera orientation.
  InputImageRotation? _getImageRotation(int sensorOrientation) {
    final deviceOrientation = _controller?.value.deviceOrientation;
    if (deviceOrientation == null) return null;

    final rotation = Platform.isIOS
        ? sensorOrientation
        : (sensorOrientation - _orientations[deviceOrientation]! + 360) % 360;

    return InputImageRotationValue.fromRawValue(rotation);
  }

  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller?.value.isInitialized == true
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                if (widget.customOverlay != null) widget.customOverlay!,
                _buildBackButton(),
                _buildFlashToggle(),
                _buildCameraSwitch(),
              ],
            )
          : Center(
              child: widget.loadingWidget ?? const CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildBackButton() => Positioned(
        top: 40,
        left: 8,
        child: FloatingActionButton(
          heroTag: 'backButton',
          onPressed: () => Navigator.of(context).pop("-1"),
          backgroundColor: widget.backButtonBackgroundColor ?? Colors.black54,
          child: widget.backButtonIcon ??
              Icon(
                Icons.arrow_back_ios_outlined,
                color: widget.backButtonIconColor ?? Colors.white,
              ),
        ),
      );

  Widget _buildFlashToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: FloatingActionButton(
          heroTag: 'flashButton',
          onPressed: _toggleFlash,
          backgroundColor: widget.flashBackgroundColor ?? Colors.black54,
          child: (_isFlashOn
                  ? widget.openedFlashIcon
                  : widget.flashButtonIcon) ??
              Icon(
                _isFlashOn ? Icons.flash_on_outlined : Icons.flash_off_outlined,
                color: widget.flashButtonIconColor ?? Colors.white,
              ),
        ),
      );

  Widget _buildCameraSwitch() => Positioned(
        bottom: 8,
        right: 8,
        child: FloatingActionButton(
          heroTag: 'switchButton',
          onPressed: _switchCamera,
          backgroundColor: widget.switchCameraBackgroundColor ?? Colors.black54,
          child: widget.switchCameraButtonIcon ??
              Icon(
                Icons.flip_camera_ios_outlined,
                color: widget.switchCameraButtonIconColor ?? Colors.white,
              ),
        ),
      );
}
