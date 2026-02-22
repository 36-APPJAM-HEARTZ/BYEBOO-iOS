//
//  UITableView+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

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
}
