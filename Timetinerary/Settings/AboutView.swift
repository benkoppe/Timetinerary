//
//  AboutView.swift
//  Timetinerary
//
//  Created by Ben K on 10/8/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Timetinerary \(Bundle.main.releaseVersionNumber ?? "VERSION NOT FOUND") (\(Bundle.main.buildVersionNumber ?? "BUILD NOT FOUND"))")
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
            
            Image("AppIconIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            
            Spacer()
            
            Text("By Ben Koppe")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
