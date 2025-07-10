//
//  BottomSheetProtocol.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

protocol BottomSheetProtocol: AnyObject {
    func presentNextViewController(from previousView: PreviousView)
}
