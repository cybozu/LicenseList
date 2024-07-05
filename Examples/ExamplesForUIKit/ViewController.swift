//
//  ViewController.swift
//  ExamplesForUIKit
//
//  Created by ky0me22 on 2024/07/05.
//

import UIKit
import LicenseList

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pushLicense(_ sender: Any) {
        let vc = LicenseListViewController()
        vc.title = "LICENSE"
        navigationController?.pushViewController(vc, animated: true)
    }
}
