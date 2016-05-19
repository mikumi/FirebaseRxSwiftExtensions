//
//  ObservableExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension ObservableType where E : FIRDataSnapshot {
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