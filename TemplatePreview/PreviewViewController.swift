//
//  PreviewViewController.swift
//  TemplatePreview
//
//  Created by Ben K on 10/19/21.
//

import UIKit
import QuickLook

class PreviewViewController: UIViewController, QLPreviewingController {
    
    var templates: [TableTemplate] = []
    @IBOutlet var mainText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
     * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
     *
    func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
    }
    */
    

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        
        // Add the supported content types to the QLSupportedContentTypes array in the Info.plist of the extension.
        
        // Perform any setup necessary in order to prepare the view.
        
        templates = (try? Template.importURL(from: url)) ?? []
        mainText.attributedText = NSAttributedString(string: "Contains \(templates.count) tables.\n\nPress the share button and select Timetinerary to import.")
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
    }

}
