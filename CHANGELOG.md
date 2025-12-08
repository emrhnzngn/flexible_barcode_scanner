# 0.0.13

## New Feature
- Added `barcodeFormats` parameter to `scanBarcode` function and `BarcodeScannerView` widget
- Introduced `FlexibleBarcodeFormat` enum - no need to import `google_mlkit_barcode_scanning` package
- Users can now specify which barcode formats to scan (e.g., only QR codes, only EAN-13, etc.)
- If `barcodeFormats` is not provided, all formats will be scanned (default behavior)

## Example Usage
```dart
import 'package:flexible_barcode_scanner/flexible_barcode_scanner.dart';

// Scan only QR codes
await scanBarcode(context, barcodeFormats: [FlexibleBarcodeFormat.qrCode]);

// Scan specific formats
await scanBarcode(context, barcodeFormats: [
  FlexibleBarcodeFormat.ean13, 
  FlexibleBarcodeFormat.code128
]);
```

# 0.0.12

## Pub Point
- Pub point fix

# 0.0.11

## Barcode Fix
- Bug Fixes.

# 0.0.10

## Barcode Fix
- Bug Fixes.

# 0.0.9

## Barcode Fix
- Bug Fixes.

# 0.0.8

## Barcode Fix
- Bug Fixes.

# 0.0.7

## Barcode Fix
- Bug Fixes.

# 0.0.6

## Barcode Fix
- Bug Fixes.

# 0.0.5

## Barcode Fix
- Bug Fixes.

# 0.0.4

## Barcode Fix
- Bug Fixes.

# 0.0.3

## Barcode Fix
- Bug Fixes.

# 0.0.2

## Basic Edit
- Editted basic files.

# 0.0.1

## Added
- Initial release of flexible_barcode_scanner.

- Real-time barcode scanning using Google ML Kit.

- Customizable scanning overlay with:
    - Scanning area frame.
    - Animated scanning line.

- Support for flashlight toggle.

- Camera switching between front and back cameras.

- Basic documentation and examples for easy integration.
