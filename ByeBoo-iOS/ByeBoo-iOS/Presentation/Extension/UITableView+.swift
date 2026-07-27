//
//  UITableView+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

// intrinsicContentSize가 없어 콘텐츠 크기만큼 스스로 커지지 못한다.
// isScrollEnabled = false로 쓰고 contentSize를 intrinsicContentSize로 노출시켜,
// 바깥 UIScrollView 안에 스크롤 없이 끼워넣어도 콘텐츠 높이에 맞게 자동으로 커지게 한다.
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
