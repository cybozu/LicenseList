<picture>
  <source srcset="./Media/logo-dark.png" height="60" media="(prefers-color-scheme: dark)" alt="LicenseList by Cybozu">
  <img src="./Media/logo.png" height="60" alt="LicenseList by Cybozu">
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
    <td><img src="./Media/demo-top.png" /></td>
    <td><img src="./Media/demo-apache.png" /></td>
    <td><img src="./Media/demo-mit.png" /></td>
  </tr>
</table>

## Requirements

- Development with Xcode 16.2+
- Written in Swift 6.0
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
   <img src="./Media/add-package-dependencies.png" width="800px">
3. Add package and link `LicenseList` to your application target.  
   <img src="./Media/add-package.png" width="600px">

**CLI**

1. Create `Package.swift` that describes dependencies.

   ```swift
   // swift-tools-version: 6.0
   import PackageDescription

   let package = Package(
       name: "SomeProduct",
       products: [
           .library(name: "SomeProduct", targets: ["SomeProduct"])
       ],
       dependencies: [
           .package(url: "https://github.com/cybozu/LicenseList.git", exact: "2.0.0")
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

## Demo

This repository includes demonstration app for UIKit & SwiftUI.

Open [Examples/Examples.xcodeproj](/Examples/Examples.xcodeproj) and Run it.
