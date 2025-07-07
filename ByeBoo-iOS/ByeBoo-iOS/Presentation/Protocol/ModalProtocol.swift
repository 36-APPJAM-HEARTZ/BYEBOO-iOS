//
//  ModalProtocol.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/5/25.
//

import UIKit

protocol ModalProtocol {
    var actionButton: ByeBooButton { get }
    var dismissButton: ByeBooButton? { get }
}
