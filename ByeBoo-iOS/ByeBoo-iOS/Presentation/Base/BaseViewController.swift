//
//  BaseViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/4/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooLogger.lifeCycle("viewDidLoad 호출")

        setView()
        setAddTarget()
        setDelegate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ByeBooLogger.lifeCycle("viewWillAppear 호출")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ByeBooLogger.lifeCycle("viewDidAppear 호출")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ByeBooLogger.lifeCycle("viewWillDisappear 호출")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ByeBooLogger.lifeCycle("viewDidDisappear 호출")
    }

    func setView() {}

    func setAddTarget() {}

    func setDelegate() {}
}
