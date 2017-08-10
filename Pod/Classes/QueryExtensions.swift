//
//  QueryExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension DatabaseQuery {
    func rx_observeEventType(eventType: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create { (observer : AnyObserver<DataSnapshot>) -> Disposable in
            let handle = self.observe(eventType,
                                      with: { (snapshot) in
                                        observer.onNext(snapshot)
                }, withCancel: { (error) in
                    observer.onError(error)
                })

            return Disposables.create { [weak self] in
                self?.removeObserver(withHandle: handle)
            }
        }
    }

    func rx_observeEventTypeAndPreviousSibling(eventType: DataEventType) -> Observable<(DataSnapshot, String?)> {
        return Observable.create { (observer : AnyObserver<(DataSnapshot, String?)>) -> Disposable in
            let handle = self.observe(eventType,
                                      andPreviousSiblingKeyWith: { (snapshot, key) in
                                        observer.onNext((snapshot, key))
                }, withCancel: { (error) in
                    observer.onError(error)
            })

            return Disposables.create { [weak self] in
                self?.removeObserver(withHandle: handle)
            }
        }
    }
}
