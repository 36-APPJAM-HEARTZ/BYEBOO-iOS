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
            fatalError("identifier에 알맞은 셀을 찾을 수 없음: \(T.identifier)")
        }
        
        return cell
    }
}
