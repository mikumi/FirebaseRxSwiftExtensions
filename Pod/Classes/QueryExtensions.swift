//
//  QueryExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

extension FIRDatabaseQuery {
    func rx_observeEventType(eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { (observer : AnyObserver<FIRDataSnapshot>) -> Disposable in
            let handle = self.observeEventType(eventType,
                withBlock: { (snapshot) in
                    observer.onNext(snapshot)
                }, withCancelBlock: { (error) in
                    observer.onError(error)
                })

            return AnonymousDisposable { [weak self] in
                self?.removeObserverWithHandle(handle)
            }
        }
    }

    func rx_observeEventType(eventType: FIRDataEventType) -> Observable<(FIRDataSnapshot, String?)> {
        return Observable.create { (observer : AnyObserver<(FIRDataSnapshot, String?)>) -> Disposable in
            let handle = self.observeEventType(eventType,
                andPreviousSiblingKeyWithBlock: { (snapshot, key) in
                    observer.onNext((snapshot, key))
                }, withCancelBlock: { (error) in
                    observer.onError(error)
            })

            return AnonymousDisposable { [weak self] in
                self?.removeObserverWithHandle(handle)
            }
        }
    }
}