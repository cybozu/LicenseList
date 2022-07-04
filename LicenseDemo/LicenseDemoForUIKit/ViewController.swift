//
//  ViewController.swift
//  LicenseDemoForUIKit
//
//  Created by ky0me22 on 2022/07/04.
//

import UIKit
import LicenseList

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pushLicense(_ sender: Any) {
        if let fileURL = Bundle.main.url(forResource: "license-list", withExtension: "plist") {
            let vc = LicenseListViewController(fileURL: fileURL)
            vc.title = "LICENSE"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
