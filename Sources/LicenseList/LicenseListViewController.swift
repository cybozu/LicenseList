//
//  LicenseListViewController.swift
//  
//
//  Created by ky0me22 on 2022/06/06.
//

import UIKit
import SwiftUI

public class LicenseListViewController: UIViewController {
    let fileURL: URL
    let id: UUID

    public init(fileURL: URL) {
        self.fileURL = fileURL
        self.id = UUID()
        super.init(nibName: nil, bundle: nil)
    }

    public convenience init?(bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: "license-list", withExtension: "plist") else {
            return nil
        }
        self.init(fileURL: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let licenseListView = LicenseListView(fileURL: fileURL, useUINavigationController: true, id: id)
        let vc = UIHostingController(rootView: licenseListView)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
