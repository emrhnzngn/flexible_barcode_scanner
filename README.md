# Flexible Barcode Scanner
A highly customizable and efficient barcode scanner library built with Flutter. This package uses the `camera` package and `Google ML Kit Barcode Scanning` capabilities to provide real-time barcode scanning with additional features like overlay animation and custom configurations.
## Features

- **Customizable Camera View**: Modify the camera preview with custom overlays and actions.
- **Barcode Detection**: Supports various barcode formats using Google ML Kit.
- **Animated Overlay**: Includes a sleek animation for scanning feedback.
- **Camera Switch**: Easily switch between front and rear cameras.
- **Flashlight Toggle**: Enable or disable flashlight for better scanning in low light.
- **Platform Compatibility**: Fully supports both Android and iOS platforms.
- **Example ScreenShots**:

<div style="display: flex; justify-content: center; align-items: center; gap: 10px;">
  <img src="https://raw.githubusercontent.com/emrhnzngn/flexible_barcode_scanner/master/assets/IMG_0034.png" alt="Image 1" width="20%" />
  <img src="https://raw.githubusercontent.com/emrhnzngn/flexible_barcode_scanner/master/assets/IMG_0033.png" alt="Image 2" width="20%" />
  <img src="https://raw.githubusercontent.com/emrhnzngn/flexible_barcode_scanner/master/assets/IMG_0032.png" alt="Image 3" width="20%" />
</div>

## Installation
***pubspec.yaml***
```yaml
dependencies:
  flexible_barcode_scanner: ^0.0.4
```
## Setup

### Ios

***Podfile***

```perl
platform :ios, '15.5.0'  # or newer version
# add this line:
$iOSVersion = '15.5.0'  # or newer version

post_install do |installer|
    # add these lines:
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "armv7"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
  end
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # add these lines:
    target.build_configurations.each do |config|
    if Gem::Version.new($iOSVersion) > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
      end
    end
  end
end
```

***Info.plist***

```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission is required to scan barcodes</string>
```

### Android

***android/App/build.gradle***

```yaml
minSdkVersion: 21
targetSdkVersion: 33
compileSdkVersion: 34
```

***android/app/src/main/AndroidManifest.xml***

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.FLASHLIGHT" />
```

## Usage

```dart
import 'package:flexible_barcode_scanner/flexible_barcode_scanner.dart';

    String barcode = "";
    final resultbarcode = await scanBarcode(
      context,
      backButtonIcon: const Icon(
        Icons.arrow_back,
        color: Colors.blue,
      ),
      loadingWidget: CircularProgressIndicator(
        color: Colors.green,
      ),
      flashButtonIcon: const Icon(
        Icons.sunny,
        color: Colors.yellow,
      ),
      openedFlashIcon: const Icon(
        Icons.dark_mode,
        color: Colors.red,
      ),
      switchCameraButtonIcon: const Icon(
        Icons.camera_alt,
        color: Colors.orange,
      ),
      strokeColor: Colors.purple,
      lineColor: Colors.pink,
      backButtonBackgroundColor: Colors.cyanAccent,
      flashBackgroundColor: Colors.indigo,
      initialCameraDirection: CameraDirection.back,
      switchCameraBackgroundColor: Colors.amber,
    );
    setState(() {
      if (resultbarcode != "-1") {
        barcode = resultbarcode;
      }
    });
```

## Supported Platforms
- Android
- iOS

## Additional information

- [Google ML Kit Barcode Scanning](https://pub.dev/packages/google_mlkit_barcode_scanning)
- [Camera](https://pub.dev/packages/camera)
