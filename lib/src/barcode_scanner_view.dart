import 'package:camera/camera.dart';
import 'package:flexible_barcode_scanner/flexible_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({
    super.key,
    this.lineColor,
    this.strokeColor,
    this.backButtonIconColor,
    this.flashButtonIconColor,
    this.switchCameraButtonIconColor,
    this.backButtonBackgroundColor,
    this.flashBackgroundColor,
    this.switchCameraBackgroundColor,
    this.customOverlay,
    this.loadingWidget,
    this.backButtonIcon,
    this.flashButtonIcon,
    this.openedFlashIcon,
    this.switchCameraButtonIcon,
    this.initialCameraDirection = CameraDirection.back,
  });

  /// The color of the scanning line animation.
  final Color? lineColor;

  /// The color of the border stroke for the scanning area.
  final Color? strokeColor;

  /// The color of the back button icon.
  final Color? backButtonIconColor;

  /// The color of the flashlight button icon.
  final Color? flashButtonIconColor;

  /// The color of the switch camera button icon.
  final Color? switchCameraButtonIconColor;

  /// The background color of the back button.
  final Color? backButtonBackgroundColor;

  /// The background color of the flashlight button.
  final Color? flashBackgroundColor;

  /// The background color of the switch camera button.
  final Color? switchCameraBackgroundColor;

  /// A custom widget for the overlay that appears over the camera view.
  final Widget? customOverlay;

  /// A custom widget to display when the scanner is loading.
  final Widget? loadingWidget;

  /// A custom icon for the back button.
  final Widget? backButtonIcon;

  /// A custom icon for the flashlight button.
  final Widget? flashButtonIcon;

  /// A custom icon for the flashlight when it is turned on.
  final Widget? openedFlashIcon;

  /// A custom icon for the switch camera button.
  final Widget? switchCameraButtonIcon;

  /// The initial camera direction (front or back).
  final CameraDirection initialCameraDirection;

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

enum CameraDirection { back, front }

Future<String> scanBarcode(
  BuildContext context, {
  Color? lineColor,
  Color? strokeColor,
  Color? backButtonIconColor,
  Color? flashButtonIconColor,
  Color? switchCameraButtonIconColor,
  Color? backButtonBackgroundColor,
  Color? flashBackgroundColor,
  Color? switchCameraBackgroundColor,
  Widget? customOverlay,
  Widget? loadingWidget,
  Widget? backButtonIcon,
  Widget? flashButtonIcon,
  Widget? openedFlashIcon,
  Widget? switchCameraButtonIcon,
  CameraDirection initialCameraDirection = CameraDirection.back,
}) async {
  return await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => BarcodeScannerView(
        lineColor: lineColor,
        strokeColor: strokeColor,
        backButtonIconColor: backButtonIconColor,
        flashButtonIconColor: flashButtonIconColor,
        switchCameraButtonIconColor: switchCameraButtonIconColor,
        backButtonBackgroundColor: backButtonBackgroundColor,
        flashBackgroundColor: flashBackgroundColor,
        switchCameraBackgroundColor: switchCameraBackgroundColor,
        customOverlay: customOverlay ??
            BarcodeScannerOverlay(
                lineColor: lineColor, strokeColor: strokeColor),
        loadingWidget: loadingWidget,
        backButtonIcon: backButtonIcon,
        flashButtonIcon: flashButtonIcon,
        openedFlashIcon: openedFlashIcon,
        switchCameraButtonIcon: switchCameraButtonIcon,
        initialCameraDirection: initialCameraDirection,
      ),
    ),
  );
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isProcessing = false;
  bool _hasReturnedValue = false;

  late CameraLensDirection cameraLensDirection =
      widget.initialCameraDirection == CameraDirection.back
          ? CameraLensDirection.back
          : CameraLensDirection.front;

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraView(
          customOverlay: widget.customOverlay,
          onImage: _processImage,
          initialCameraLensDirection: cameraLensDirection,
          backButtonIcon: widget.backButtonIcon,
          flashButtonIcon: widget.flashButtonIcon,
          openedFlashIcon: widget.openedFlashIcon,
          backButtonBackgroundColor: widget.backButtonBackgroundColor,
          flashBackgroundColor: widget.flashBackgroundColor,
          switchCameraBackgroundColor: widget.switchCameraBackgroundColor,
          switchCameraButtonIcon: widget.switchCameraButtonIcon,
          loadingWidget: widget.loadingWidget,
          backButtonIconColor: widget.backButtonIconColor,
          flashButtonIconColor: widget.flashButtonIconColor,
          switchCameraButtonIconColor: widget.switchCameraButtonIconColor,
        ),
      ],
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isProcessing || _hasReturnedValue) return;

    _isProcessing = true;
    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && mounted) {
        _hasReturnedValue = true;
        Navigator.of(context).pop(barcodes.first.rawValue);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      if (mounted) {
        _isProcessing = false;
      }
    }
  }
}
