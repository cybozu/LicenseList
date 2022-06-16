//
//  LicenseListView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LicenseListView: View {
    let libraries: [Library]
    let useUINavigationController: Bool

    public init(fileURL: URL, useUINavigationController: Bool = false) {
        self.useUINavigationController = useUINavigationController
        guard let data = try? Data(contentsOf: fileURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            libraries = []
            return
        }
        let _libraries = (dict["libraries"] as? [[String: Any]])?.compactMap({ info -> Library? in
            guard let name = info["name"] as? String,
                  let type = info["licenseType"] as? String,
                  let body = info["licenseBody"] as? String else {
                return nil
            }
            return Library(name: name,
                           licenseType: type,
                           licenseBody: body)
        })
        guard let libraries = _libraries else {
            libraries = []
            return
        }
        self.libraries = libraries
    }

    public var body: some View {
        List {
            ForEach(libraries, id: \.name) { library in
                if useUINavigationController {
                    libraryButton(library)
                } else {
                    libraryNavigationLink(library)
                }
            }
        }
        .listStyleInsetGroupedIfPossible()
    }

    var navigationController: UINavigationController? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene as? UIWindowScene,
              let rootVC = sceneDelegate.windows.first?.rootViewController,
              let navigationController = rootVC as? UINavigationController
        else { return nil }
        return navigationController
    }

    func libraryButton(_ library: Library) -> some View {
        return Button(library.name) {
            let view: AnyView
            if #available(iOS 15, *) {
                view = AnyView(LicenseView(library: library))
            } else {
                view = AnyView(LegacyLicenseView(library: library))
            }
            let hostingController = UIHostingController(rootView: view)
            hostingController.title = library.name
            navigationController?.pushViewController(hostingController, animated: true)
        }
        .foregroundColor(.primary)
    }

    func libraryNavigationLink(_ library: Library) -> some View {
        if #available(iOS 15, *) {
            return AnyView(NavigationLink(destination: LicenseView(library: library)) {
                Text(library.name)
            })
        } else {
            return AnyView(NavigationLink(destination: LegacyLicenseView(library: library)) {
                Text(library.name)
            })
        }
    }
}
