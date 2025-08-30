//
//  ErrorHandler.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/30/25.
//

protocol ErrorHandler: AnyObject {
    func handleError(_ error: ByeBooError)
}

extension ErrorHandler where Self: BaseViewController & ToastPresentable {
    
    func handleError(_ error: ByeBooError) {
        switch error {
        case .networkConnect:
            presentToastMessage(type: .connectServerError)
        default:
            ByeBooLogger.error(error)
        }
    }
}
