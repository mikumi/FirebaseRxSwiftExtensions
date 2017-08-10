//
//  ReferenceExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension DatabaseReference {
    // MARK: - Updating references
    func rx_updateChildValues(values: [NSObject: AnyObject]) -> Observable<DatabaseReference> {
        return Observable.create { (observer: AnyObserver<DatabaseReference>) in
            self.updateChildValues(values, withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    func rx_setValue(value: AnyObject?, priority: AnyObject? = nil) -> Observable<DatabaseReference> {
        return Observable.create { (observer: AnyObserver<DatabaseReference>) -> Disposable in
            if let priority = priority {
                self.setValue(value, andPriority: priority, withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))
            } else {
                self.setValue(value, withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))
            }

            return Disposables.create()
        }
    }

    func rx_setPriority(priority: AnyObject?) -> Observable<DatabaseReference> {
        return Observable.create { (observer: AnyObserver<DatabaseReference>) in
            self.setPriority(priority, withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    func rx_removeValue() -> Observable<DatabaseReference> {
        return Observable.create { (observer: AnyObserver<DatabaseReference>) in
            self.removeValue(completionBlock: DatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    // MARK: - Transactions
    func rx_runTransactionBlock(block: @escaping ((MutableData) -> TransactionResult), withLocalEvents localEvents: Bool = false) -> Observable<(Bool, DataSnapshot?)> {
        return Observable.create { (observer: AnyObserver<(Bool, DataSnapshot?)>) in
            self.runTransactionBlock(block, andCompletionBlock: { (error, isCommitted, snapshot) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext((isCommitted, snapshot))
                    observer.onCompleted()
                }
            }, withLocalEvents: localEvents)

            return Disposables.create()
        }
    }

    // MARK: - Disconnect handling
    func rx_onDisconnectSetValue(value: AnyObject?, priority: AnyObject? = nil) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            if let priority = priority {
                self.onDisconnectSetValue(value,
                    andPriority: priority,
                    withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))

                return Disposables.create()
            } else {
                self.onDisconnectSetValue(value,
                    withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))

                return Disposables.create()
            }
        }
    }

    func rx_onDisconnectUpdateValue(values: [NSObject: AnyObject]) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectUpdateChildValues(values,
                withCompletionBlock: DatabaseReference.rx_setCallback(observer: observer))

            return Disposables.create()
        }
    }

    func rx_onDisconnectRemoveValue() -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectRemoveValue(completionBlock: DatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    // MARK: - Helper methods
    private static func rx_setCallback(observer: AnyObserver<DatabaseReference>) -> ((Error?, DatabaseReference) -> Void) {
        return { (error: Error?, reference: DatabaseReference) in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(reference)
                observer.onCompleted()
            }
        }
    }
}