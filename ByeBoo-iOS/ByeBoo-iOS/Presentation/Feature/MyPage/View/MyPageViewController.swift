//
//  MyPageViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class MyPageViewController: BaseViewController {
    
    private let rootView = MyPageView(nickName: "하츠핑")
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ByeBooNavigationBar.makeNavigationBar(
                navigationItem: self.navigationItem,
                navigationController: self.navigationController,
                type: .title("마이페이지")
            )
    }

}
