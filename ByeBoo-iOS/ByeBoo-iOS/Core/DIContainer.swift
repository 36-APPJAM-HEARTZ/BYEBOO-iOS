//
//  DIContainer.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

final class DIContainer {
    static let shared = DIContainer()
    // container에 등록된 의존성 객체를 꺼내서 등록해야하니까 DIContainer를 필요로 함
    private var storage: [String: (DIContainer) -> Any] = [:]
    
    private init() { }
    
    /// 의존성을 클로저 형태로 딕셔너리에 저장
    /// type: 프로토콜의 타입
    /// clousure:  실제 의존성 객체 return
    func register<T>(type: T.Type, closure: @escaping (DIContainer) -> Any) {
        storage["\(type)"] = closure
    }
    
    /// 실제 사용할 때 클로저로 저장된 의존성을 객체화
    func resolve<T>(type: T.Type) -> T? {
        guard let dependency = storage["\(type)"]?(self) as? T else {
            return nil
        }
        
        return dependency
    }
}
