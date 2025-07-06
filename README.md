<picture>
  <source srcset="https://github.com/user-attachments/assets/9cc7e7bf-37f3-4998-8a29-055a26185db9" height="70" media="(prefers-color-scheme: dark)" alt="LicenseList by Cybozu">
  <img src="https://github.com/user-attachments/assets/286e07fb-3101-4fa2-90ad-8bb892e40c9a" height="70" alt="LicenseList by Cybozu">
</picture>

Generate a list of licenses for the Swift Package libraries that your app depends on.

[![Github forks](https://img.shields.io/github/forks/cybozu/LicenseList)](https://github.com/cybozu/LicenseList/network/members)
[![Github stars](https://img.shields.io/github/stars/cybozu/LicenseList)](https://github.com/cybozu/LicenseList/stargazers)
[![Github issues](https://img.shields.io/github/issues/cybozu/LicenseList)](https://github.com/cybozu/LicenseList/issues)
[![Github release](https://img.shields.io/github/v/release/cybozu/LicenseList)](https://github.com/cybozu/LicenseList/releases)
[![Github license](https://img.shields.io/github/license/cybozu/LicenseList)](https://github.com/cybozu/LicenseList/blob/main/LICENSE)

**Example**

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/49c4e9ac-dc59-484b-b3d7-ef35302b913d" /></td>
    <td><img src="https://github.com/user-attachments/assets/db35eb0b-8def-437b-90ac-960025b702f4" /></td>
    <td><img src="https://github.com/user-attachments/assets/50f463d3-8d3a-449b-8205-089ae7e141a0" /></td>
  </tr>
</table>

## Requirements

- Development with Xcode 16.4+
- Written in Swift 6.1
- Compatible with iOS 16.0+, tvOS 17.0+

## Documentation

[Latest (Swift-DocC)](https://cybozu.github.io/LicenseList/documentation/licenselist/)

## Privacy Manifest

This library does not collect or track user information, so it does not include a PrivacyInfo.xcprivacy file.

## Installation

LicenseList is available through [Swift Package Manager](https://github.com/apple/swift-package-manager/).

**Xcode**

1. File > Add Package Dependencies…
2. Search `https://github.com/cybozu/LicenseList.git`.  
   <img src="https://github.com/user-attachments/assets/4b27f2a4-2193-41d3-ba27-8be8c4293983" width="800px">
3. Add package and link `LicenseList` to your application target.  
   <img src="https://github.com/user-attachments/assets/bcf23bcb-ece9-413b-8304-7d52148486ac" width="600px">

**CLI**

1. Create `Package.swift` that describes dependencies.

   ```swift
   // swift-tools-version: 6.1
   import PackageDescription

   let package = Package(
       name: "SomeProduct",
       products: [
           .library(name: "SomeProduct", targets: ["SomeProduct"])
       ],
       dependencies: [
           .package(url: "https://github.com/cybozu/LicenseList.git", exact: "2.1.0")
       ],
       targets: [
           .target(
               name: "SomeProduct",
               dependencies: [
                   .product(name: "LicenseList", package: "LicenseList")
               ]
           )
       ]
   )
   ```

2. Run the following command in Terminal.
   ```sh
   $ swift package resolve
   ```

## Usage

### Example for UIKit

```swift
import LicenseList

// in ViewController
let vc = LicenseListViewController()
vc.title = "LICENSE"

// If you want to anchor link of the repository
vc.licenseViewStyle = .withRepositoryAnchorLink

navigationController?.pushViewController(vc, animated: true)
```

### Example for SwiftUI

```swift
import LicenseList

struct ContentView: View {
    var body: some View {
        NavigationView {
            LicenseListView()
                // If you want to anchor link of the repository
                .licenseViewStyle(.withRepositoryAnchorLink)
                .navigationTitle("LICENSE")
        }
    }
}
```

## Contributing to LicenseList

Contributions to LicenseList are welcomed and encouraged! Please see the [Contributing Guide](/CONTRIBUTING.md).

## Demo

This repository includes demonstration app for UIKit & SwiftUI.

Open [Examples/Examples.xcodeproj](/Examples/Examples.xcodeproj) and Run it.
