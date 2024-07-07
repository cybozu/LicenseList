import UIKit
import SwiftUI

public class LicenseListViewController: UIViewController {
    public var licenseListViewStyle: LicenseListViewStyle = .plain

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let licenseListView = LicenseListView() { [weak self] library in
            self?.navigateTo(library: library)
        }
        let vc = UIHostingController(rootView: licenseListView)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func navigateTo(library: Library) {
        let hostingController = UIHostingController(
            rootView: LicenseView(library: library).licenseListViewStyle(licenseListViewStyle)
        )
        hostingController.title = library.name
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}
