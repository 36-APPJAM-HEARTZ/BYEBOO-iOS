//
//  CGFloat+.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/4/25.
//

import UIKit

/// iphone 13 mini 기준으로 디자인 됩니다. (375 * 812)
/// 스크린 너비 375 를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return
/// 스크린 높이 812 를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return
///
/// 기기별 대응에 사용
/// ex) (size: 20.adjustedW)
/// ex) (size: 60.adjustedH)

/// iPhone Duo 대응
/// - 스크린이 아닌 앱이 실제로 차지하는 scene 크기를 기준으로 함 (Duo 내부/외부 디스플레이, Split View)
/// - 펼친 Duo(951pt)처럼 넓은 화면에서 UI가 2배 이상 커지지 않도록 비율 상한을 둠
/// - 값은 제약을 만드는 시점에 고정되므로, 앱 사용 중 접고 펴는 변화에는 반응하지 않음
private enum ScreenSize {
    static let base = CGSize(width: 375, height: 812)
    /// 가장 큰 iPhone(Pro Max, 440 x 956) 기준. 기존 iPhone에서는 상한에 걸리지 않음
    static let maxRatio = CGSize(width: 440 / base.width, height: 956 / base.height)
    
    static var current: CGSize {
        let scenes = UIApplication.shared.connectedScenes
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        guard let windowScene = scene as? UIWindowScene else { return base }
        return windowScene.windows.first?.bounds.size ?? windowScene.screen.bounds.size
    }
    
    static var widthRatio: CGFloat {
        min(current.width / base.width, maxRatio.width)
    }
    
    static var heightRatio: CGFloat {
        min(current.height / base.height, maxRatio.height)
    }
}

extension CGFloat {
    var adjustedW: CGFloat {
        return self * ScreenSize.widthRatio
    }
    
    var adjustedH: CGFloat {
        return self * ScreenSize.heightRatio
    }
}

extension Double {
    var adjustedW: Double {
        return Double(CGFloat(self).adjustedW)
    }
    
    var adjustedH: Double {
        return Double(CGFloat(self).adjustedH)
    }
}

extension Int {
    var adjustedW: CGFloat {
        return CGFloat(self).adjustedW
    }
    
    var adjustedH: CGFloat {
        return CGFloat(self).adjustedH
    }
}
