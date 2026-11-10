//
//  ByeBooNavigationController.swift
//  ByeBoo-iOS
//

import UIKit

/// 탭 안의 네비게이션 스택에서 사용
/// 시스템 탭 바에서 hidesBottomBarWhenPushed = true 화면을 animated: false로 push하면
/// 새 화면의 첫 배치가 애니메이션되어 왼쪽 위 0 크기에서 펼쳐짐 (iOS 27.0, 27.1 시뮬레이터에서 앱 코드 없이도 재현)
/// 애니메이션 없이 먼저 배치해서 방지
final class ByeBooNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !animated else {
            super.pushViewController(viewController, animated: true)
            return
        }
        UIView.performWithoutAnimation {
            super.pushViewController(viewController, animated: false)
            view.layoutIfNeeded()
        }
    }
}
