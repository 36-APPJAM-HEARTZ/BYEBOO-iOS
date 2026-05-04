//
//  NoticeDisplayable.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

protocol NoticeDisplayable {
    var isRead: Bool { get set }
    var backgroundColor: UIColor { get }
    var iconImage: UIImage { get }
    var title: String { get }
    var subtitle: String { get }
}

extension NoticeDisplayable {
    var backgroundColor: UIColor {
        isRead ? .white5 : .primary30020
    }
}
