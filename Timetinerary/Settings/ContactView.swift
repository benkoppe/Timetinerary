//
//  ContactView.swift
//  Timetinerary
//
//  Created by Ben K on 10/8/21.
//

import SwiftUI
import SwiftUIMailView

struct ContactView: View {
    @State private var mailData = ComposeMailData(subject: "[Timetinerary \(Bundle.main.releaseVersionNumber ?? "VERSION NOT FOUND") (\(Bundle.main.buildVersionNumber ?? "BUILD NOT FOUND"))]", recipients: ["Koppe.Development@gmail.com"], message: "", attachments: [])
    @State private var showMail = false
    
    var body: some View {
        HStack {
            Spacer()
            ContactItem(title: "Email", systemImage: "envelope.fill", color: .blue) {
                showMail = true
            }
            .sheet(isPresented: $showMail) { MailView(data: $mailData) { _ in } }
            Spacer()
            ContactItem(title: "Instagram", systemImage: "camera.fill", color: .red) {
                openInstagram()
            }
            Spacer()
        }
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func openInstagram() {
        let screenName =  "ben.koppe"
        
        let appURL = URL(string:  "instagram://user?username=\(screenName)")
        let webURL = URL(string:  "https://instagram.com/\(screenName)")
        
        if let appURL = appURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            if let webURL = webURL {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            } else {
                print("Could not open instagram.")
            }
        }
    }
    
    struct ContactItem: View {
        let title: String
        let systemImage: String
        let color: Color
        
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: systemImage)
                        .font(.system(size: 40))
                        .frame(width: 90, height: 90)
                        .foregroundColor(.white)
                        .background(color)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text(title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
        ContactView()
            .preferredColorScheme(.dark)
    }
}
