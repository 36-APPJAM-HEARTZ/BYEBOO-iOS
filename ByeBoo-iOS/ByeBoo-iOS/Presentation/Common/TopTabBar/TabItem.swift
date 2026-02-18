//
//  TabItem.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

protocol TabItem: CaseIterable {
    var title: String { get }
    var image: UIImage { get }
    var viewController: UIViewController { get }
}
