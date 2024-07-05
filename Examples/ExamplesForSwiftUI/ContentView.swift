//
//  ContentView.swift
//  ExamplesForSwiftUI
//
//  Created by ky0me22 on 2024/07/05.
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

#Preview {
    ContentView()
}
