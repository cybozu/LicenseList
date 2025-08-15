# How LicenseList Works

This explains the LicenseList mechanism and workarounds for its inherent limitations.

## Overview

First, Swift Package Manager fetches dependent libraries into a directory called `SourcePackages` (usually located inside the `DerivedData` directory) and references them.
Since the dependent libraries are complete clones of their GitHub repositories, a `LICENSE` file should exist within them if they are proper OSS libraries.
LicenseList extracts these `LICENSE` files in advance using a `BuildToolPlugin` to obtain the license information. It then uses this information to create the license list view.

## LicenseList Constraints and Workarounds

As mentioned above, LicenseList heavily relies on the `SourcePackages` directory.
Therefore, if the location of `SourcePackages` is changed using a build option like `-clonedSourcePackagesDirPath`, it will not function correctly.
However, when you want to cache libraries in a CI environment, you might want to change the location of `SourcePackages` to a custom path.
There are two ways to achieve this.

1. Set an absolute path to the `PLL_SOURCE_PACKAGES_PATH` environment variable before building.
   ```sh
   export PLL_SOURCE_PACKAGES_PATH="$PWD/SourcePackages"
   xcodebuild clean build \
     -project Examples/Examples.xcodeproj \
     -scheme ExamplesForSwiftUI \
     -destination "platform=iOS Simulator,name=iPhone 16,OS=18.5" \
     -clonedSourcePackagesDirPath $PLL_SOURCE_PACKAGES_PATH
   ```
2. Build using both the `-derivedDataPath` and `-clonedSourcePackagesDirPath` options.
   ```sh
   xcodebuild clean build \
     -project Examples/Examples.xcodeproj \
     -scheme ExamplesForSwiftUI \
     -destination "platform=iOS Simulator,name=iPhone 16,OS=18.5" \
     -derivedDataPath ./DerivedData \
     -clonedSourcePackagesDirPath ./DerivedData/SourcePackages
   ```

There is a caveat to Method 2. If the path for `DerivedData` and the path for `SourcePackages` are independent and separate, the LicenseList build will fail.
The reason is that LicenseList's `BuildToolPlugin` searches for `SourcePackages` within the `DerivedData` directory.
Therefore, you must specify a path where `SourcePackages` is located inside `DerivedData`.

Since Method 2 is prone to human error, we recommend Method 1 unless you have a strong reason to do otherwise.
