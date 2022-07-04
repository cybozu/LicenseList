//
//  ContentView.swift
//  LicenseDemoForSwiftUI
//
//  Created by ky0me22 on 2022/07/04.
//

import SwiftUI
import LicenseList

struct ContentView: View {
    let fileURL = Bundle.main.url(forResource: "license-list", withExtension: "plist")!

    var body: some View {
        NavigationView {
            NavigationLink("License") {
                LicenseListView(fileURL: fileURL)
                    .navigationTitle("LICENSE")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
