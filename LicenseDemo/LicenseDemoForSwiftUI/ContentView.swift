//
//  ContentView.swift
//  LicenseDemoForSwiftUI
//
//  Created by ky0me22 on 2022/07/04.
//

import SwiftUI
import LicenseList

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink("License") {
                LicenseListView()
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
