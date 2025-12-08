import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;

/// Supported barcode formats for scanning.
///
/// This enum provides a clean interface without requiring users to import
/// the google_mlkit_barcode_scanning package directly.
enum FlexibleBarcodeFormat {
  /// Scan all supported barcode formats.
  all,

  /// Barcode format unknown to the current SDK.
  unknown,

  /// Barcode format constant for Code 128.
  code128,

  /// Barcode format constant for Code 39.
  code39,

  /// Barcode format constant for Code 93.
  code93,

  /// Barcode format constant for CodaBar.
  codabar,

  /// Barcode format constant for Data Matrix.
  dataMatrix,

  /// Barcode format constant for EAN-13.
  ean13,

  /// Barcode format constant for EAN-8.
  ean8,

  /// Barcode format constant for ITF (Interleaved Two-of-Five).
  itf,

  /// Barcode format constant for QR Code.
  qrCode,

  /// Barcode format constant for UPC-A.
  upca,

  /// Barcode format constant for UPC-E.
  upce,

  /// Barcode format constant for PDF-417.
  pdf417,

  /// Barcode format constant for AZTEC.
  aztec,
}

/// Extension to convert [FlexibleBarcodeFormat] to ML Kit's [BarcodeFormat].
extension FlexibleBarcodeFormatExtension on FlexibleBarcodeFormat {
  /// Converts this [FlexibleBarcodeFormat] to ML Kit's [BarcodeFormat].
  mlkit.BarcodeFormat toMlKitFormat() {
    switch (this) {
      case FlexibleBarcodeFormat.all:
        return mlkit.BarcodeFormat.all;
      case FlexibleBarcodeFormat.unknown:
        return mlkit.BarcodeFormat.unknown;
      case FlexibleBarcodeFormat.code128:
        return mlkit.BarcodeFormat.code128;
      case FlexibleBarcodeFormat.code39:
        return mlkit.BarcodeFormat.code39;
      case FlexibleBarcodeFormat.code93:
        return mlkit.BarcodeFormat.code93;
      case FlexibleBarcodeFormat.codabar:
        return mlkit.BarcodeFormat.codabar;
      case FlexibleBarcodeFormat.dataMatrix:
        return mlkit.BarcodeFormat.dataMatrix;
      case FlexibleBarcodeFormat.ean13:
        return mlkit.BarcodeFormat.ean13;
      case FlexibleBarcodeFormat.ean8:
        return mlkit.BarcodeFormat.ean8;
      case FlexibleBarcodeFormat.itf:
        return mlkit.BarcodeFormat.itf;
      case FlexibleBarcodeFormat.qrCode:
        return mlkit.BarcodeFormat.qrCode;
      case FlexibleBarcodeFormat.upca:
        return mlkit.BarcodeFormat.upca;
      case FlexibleBarcodeFormat.upce:
        return mlkit.BarcodeFormat.upce;
      case FlexibleBarcodeFormat.pdf417:
        return mlkit.BarcodeFormat.pdf417;
      case FlexibleBarcodeFormat.aztec:
        return mlkit.BarcodeFormat.aztec;
    }
  }
}

/// Helper function to convert a list of [FlexibleBarcodeFormat] to ML Kit formats.
List<mlkit.BarcodeFormat> toMlKitFormats(List<FlexibleBarcodeFormat>? formats) {
  if (formats == null) {
    return const [mlkit.BarcodeFormat.all];
  }
  return formats.map((format) => format.toMlKitFormat()).toList();
}
