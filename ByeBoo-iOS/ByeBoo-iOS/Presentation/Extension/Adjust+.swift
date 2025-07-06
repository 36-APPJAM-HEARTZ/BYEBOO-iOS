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

extension CGFloat {
    var adjustedW: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}

extension Double {
    var adjustedW: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 812)
        return self * ratio
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
