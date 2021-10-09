//
//  LicensesView.swift
//  Timetinerary
//
//  Created by Ben K on 10/8/21.
//

import SwiftUI

struct License: Hashable {
    let name: String
    let url: URL
}

struct LicensesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let licenseGroups = [[License(name: "SwiftUIMailView", url: URL(string: "https://github.com/globulus/swiftui-mail-view/blob/main/LICENSE")!)]]
    
    var body: some View {
        List {
            ForEach(licenseGroups, id: \.self) { licenseArray in
                Section {
                    ForEach(licenseArray, id: \.self) { license in
                        LicenseView(license: license)
                    }
                }
            }
            .navigationTitle("Licenses")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationTitle("Licenses")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct LicenseView: View {
        let license: License
        
        var body: some View {
            Link(destination: license.url) {
                HStack {
                    Text(license.name)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("License")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        LicensesView()
    }
}
