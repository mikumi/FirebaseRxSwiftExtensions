//
//  ReferenceExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension DatabaseReference {
    // MARK: - Updating references
    func rx_updateChildValues(values: [String: Any]) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.updateChildValues(values, withCompletionBlock: DatabaseReference.rx_setSingleCallback(single: single))
            return Disposables.create()
        })
    }

    func rx_setValue(value: AnyObject?, priority: AnyObject? = nil) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (single) -> Disposable in
            if let priority = priority {
                self.setValue(value, andPriority: priority, withCompletionBlock: DatabaseReference.rx_setSingleCallback(single: single))
            } else {
                self.setValue(value, withCompletionBlock: DatabaseReference.rx_setSingleCallback(single: single))
            }

            return Disposables.create()
        })
    }

    func rx_setPriority(priority: AnyObject?) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.setPriority(priority, withCompletionBlock: DatabaseReference.rx_setSingleCallback(single: single))
            return Disposables.create()
        })
    }

    func rx_removeValue() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.removeValue(completionBlock: DatabaseReference.rx_setSingleCallback(single: single))
            return Disposables.create()
        })
    }

    // MARK: - Transactions
    func rx_runTransactionBlock(block: @escaping ((MutableData) -> TransactionResult), withLocalEvents localEvents: Bool = false) -> Single<(Bool, DataSnapshot?)> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.runTransactionBlock(block, andCompletionBlock: { (error, isCommitted, snapshot) in
                if let error = error {
                    single(.error(error))
                } else {
                    single(.success(isCommitted, snapshot))
                }
            }, withLocalEvents: localEvents)

            return Disposables.create()
        })
    }

    // MARK: - Disconnect handling
    func rx_onDisconnectSetValue(value: AnyObject?, priority: AnyObject? = nil) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            if let priority = priority {
                self.onDisconnectSetValue(value,
                    andPriority: priority,
                    withCompletionBlock: DatabaseReference.rx_setObservableCallback(observer: observer))

                return Disposables.create()
            } else {
                self.onDisconnectSetValue(value,
                    withCompletionBlock: DatabaseReference.rx_setObservableCallback(observer: observer))

                return Disposables.create()
            }
        }
    }

    func rx_onDisconnectUpdateValue(values: [NSObject: AnyObject]) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectUpdateChildValues(values,
                withCompletionBlock: DatabaseReference.rx_setObservableCallback(observer: observer))

            return Disposables.create()
        }
    }

    func rx_onDisconnectRemoveValue() -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectRemoveValue(completionBlock: DatabaseReference.rx_setObservableCallback(observer: observer))
            return Disposables.create()
        }
    }

    // MARK: - Helper methods
    private static func rx_setObservableCallback(observer: AnyObserver<DatabaseReference>) -> ((Error?, DatabaseReference) -> Void) {
        return { (error: Error?, reference: DatabaseReference) in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(reference)
                observer.onCompleted()
            }
        }
    }

    private static func rx_setSingleCallback(single: @escaping ((SingleEvent<DatabaseReference>) -> ())) -> ((Error?, DatabaseReference) -> Void) {
        return { (error: Error?, reference: DatabaseReference) in
            if let error = error {
                single(.error(error))
            } else {
                single(.success(reference))
            }
        }
    }
}
