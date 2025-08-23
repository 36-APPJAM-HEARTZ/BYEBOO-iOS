//
//  ExternalLink.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/19/25.
//

import SafariServices
import UIKit

enum ExternalLink: String {
    
    case inquire = "https://forms.gle/AhqzzkHKWYAgo4m96"
    case makeService = "https://forms.gle/BA77gAgZ1NCatart5"
    case serviceTerm = "https://lively-mars-3b7.notion.site/24cab823e68d801aac95ec5d0389d192"
    case privacyPolicy = "https://lively-mars-3b7.notion.site/24cab823e68d80a19ab1fbf87d6cfbc3"
    
    func openURL(for rootViewController: UIViewController) {
        guard let url = URL(string: self.rawValue) else {
            ByeBooLogger.error(ByeBooError.URLError)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        rootViewController.present(safariVC, animated: true)
    }
}
