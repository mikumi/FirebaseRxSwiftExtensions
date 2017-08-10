//
//  ObservableExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension ObservableType where E : DataSnapshot {
    func rx_filterWhenExists() -> Observable<E> {
        return self.filter { (snapshot) -> Bool in
            return snapshot.exists()
        }
    }

    func rx_filterWhenNotExists() -> Observable<E> {
        return self.filter { (snapshot) -> Bool in
            return !snapshot.exists()
        }
    }
}