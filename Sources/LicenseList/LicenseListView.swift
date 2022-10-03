//
//  LicenseListView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import UIKit
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
                    HStack {
                        libraryButton(library)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundColor(Color(.systemGray3))
                    }
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
              var controller = sceneDelegate.windows.first?.rootViewController
        else { return nil }
        while true {
            if let navigationController = controller as? UINavigationController,
               let visibleViewController = navigationController.visibleViewController {
                controller = visibleViewController
                continue
            }
            if let tabBarController = controller as? UITabBarController,
               let selectedViewController = tabBarController.selectedViewController {
                controller = selectedViewController
                continue
            }
            if let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
                continue
            }
            break
        }
        return controller.navigationController
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

public extension LicenseListView {
    init(bundle: Bundle = .main, useUINavigationController: Bool = false) {
        let url = bundle.url(forResource: "license-list", withExtension: "plist") ?? URL(fileURLWithPath: "/")
        self.init(fileURL: url, useUINavigationController: useUINavigationController)
    }
}
