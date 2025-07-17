//
//  CustomLoadingView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/17/25.
//

import UIKit

import Lottie

final class CustomLoadingView: UIView {
    static let shared = CustomLoadingView()
    
    private let loading = LottieAnimationView(name: "Loading_byeboo")
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        isUserInteractionEnabled = true
        
        addSubview(loading)
        loading.do {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
            $0.transform = CGAffineTransform(scaleX: 2.3.adjustedW, y: 2.3.adjustedH)
        }
        loading.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(76.68.adjustedW)
            $0.height.equalTo(19.adjustedH)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        if self.superview != nil { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(self)
            self.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func hide() {
        self.removeFromSuperview()
    }
}
