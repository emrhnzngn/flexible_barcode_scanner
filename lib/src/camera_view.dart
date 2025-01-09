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
  // List of available camera descriptions.
  static List<CameraDescription> _cameras = [];

  // Camera controller to manage camera operations.
  CameraController? _controller;

  // Index to keep track of the current camera being used.
  int _cameraIndex = -1;

  // Boolean to track the flashlight state (on/off).
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initialize(); // Initialize the camera setup.
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the camera controller.
    super.dispose();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras(); // Fetch available cameras.
    }

    // Find the camera matching the initial lens direction.
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }

    if (_cameraIndex != -1) {
      _startLiveFeed(); // Start the camera feed if a suitable camera is found.
    }
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];

    _controller = CameraController(
      camera,
      // Use a high resolution preset, as the maximum preset may not work on some devices.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup
              .bgra8888, // Use different formats for Android and iOS.
    );

    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      // Start streaming images from the camera.
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });

      // Set the camera focus mode to auto.
      _controller?.setFocusMode(FocusMode.auto);

      setState(() {}); // Update the UI after initialization.
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream(); // Stop the image stream.
    await _controller?.dispose(); // Dispose of the camera controller.
    _controller = null;
  }

  Future _switchLiveCamera() async {
    _cameraIndex = (_cameraIndex + 1) %
        _cameras.length; // Cycle through available cameras.
    await _stopLiveFeed();
    await _startLiveFeed();
  }

  Future<void> _toggleFlash() async {
    _isFlashOn = !_isFlashOn; // Toggle flashlight state.
    _controller?.setFlashMode(_isFlashOn
        ? FlashMode.torch
        : FlashMode.off); // Update flashlight mode.
    setState(() {}); // Update the UI.
  }

  void _processCameraImage(CameraImage image) {
    final inputImage =
        _inputImageFromCameraImage(image); // Convert the image to InputImage.
    if (inputImage == null) return;
    widget.onImage(inputImage); // Pass the processed image to the callback.
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) {
        return null;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) {
      return null;
    }

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // Used only in Android.
        format: format, // Used only in iOS.
        bytesPerRow: plane.bytesPerRow, // Used only in iOS.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller?.value.isInitialized == true
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                      child: CameraPreview(
                          _controller!)), // Display the camera preview.
                  if (widget.customOverlay != null) widget.customOverlay!,
                  _buildBackButton(),
                  _buildFlashToggle(),
                  _buildCameraSwitch(),
                ],
              )
            : Center(
                child: widget.loadingWidget ??
                    const CircularProgressIndicator(), // Display loading widget if the camera is not ready.
              ),
      ),
    );
  }

  Widget _buildBackButton() => Positioned(
        top: 40,
        left: 8,
        child: FloatingActionButton(
          heroTag: 'backButton',
          onPressed: () => Navigator.of(context).pop("-1"), // Navigate back.
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
          onPressed: _toggleFlash, // Toggle the flashlight.
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
          onPressed:
              _switchLiveCamera, // Switch between front and back cameras.
          backgroundColor: widget.switchCameraBackgroundColor ?? Colors.black54,
          child: widget.switchCameraButtonIcon ??
              Icon(
                Icons.flip_camera_ios_outlined,
                color: widget.switchCameraButtonIconColor ?? Colors.white,
              ),
        ),
      );
}
