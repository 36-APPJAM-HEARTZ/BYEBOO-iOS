//
//  DeepLinkDestination.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/17/26.
//

import UIKit

protocol DeepLinkDestination {
    func navigate(from window: UIWindow)
}
