//
//  UITableView+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

final class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        register(
            cell,
            forCellReuseIdentifier: T.identifier
        )
    }
}
