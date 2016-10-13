//
//  QueryExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension FIRDatabaseQuery {
    func rx_observeEventType(eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { (observer : AnyObserver<FIRDataSnapshot>) -> Disposable in
            let handle = self.observe(eventType,
                                      with: { (snapshot) in
                                        observer.onNext(snapshot)
                }, withCancel: { (error) in
                    observer.onError(error)
                })

            return AnonymousDisposable { [weak self] in
                self?.removeObserver(withHandle: handle)
            }
        }
    }

    func rx_observeEventTypeAndPreviousSibling(eventType: FIRDataEventType) -> Observable<(FIRDataSnapshot, String?)> {
        return Observable.create { (observer : AnyObserver<(FIRDataSnapshot, String?)>) -> Disposable in
            let handle = self.observe(eventType,
                                      andPreviousSiblingKeyWith: { (snapshot, key) in
                                        observer.onNext((snapshot, key))
                }, withCancel: { (error) in
                    observer.onError(error)
            })

            return AnonymousDisposable { [weak self] in
                self?.removeObserver(withHandle: handle)
            }
        }
    }
}
