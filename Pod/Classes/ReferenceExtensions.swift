//
//  ReferenceExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseDatabase
import RxSwift

public extension FIRDatabaseReference {
    // MARK: - Updating references
    func rx_updateChildValues(values: [NSObject: AnyObject]) -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer: AnyObserver<FIRDatabaseReference>) in
            self.updateChildValues(values, withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    func rx_setValue(value: AnyObject?, priority: AnyObject? = nil) -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer: AnyObserver<FIRDatabaseReference>) -> Disposable in
            if let priority = priority {
                self.setValue(value, andPriority: priority, withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            } else {
                self.setValue(value, withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            }

            return Disposables.create()
        }
    }

    func rx_setPriority(priority: AnyObject?) -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer: AnyObserver<FIRDatabaseReference>) in
            self.setPriority(priority, withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    func rx_removeValue() -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer: AnyObserver<FIRDatabaseReference>) in
            self.removeValue(completionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    // MARK: - Transactions
    func rx_runTransactionBlock(block: @escaping ((FIRMutableData) -> FIRTransactionResult), withLocalEvents localEvents: Bool = false) -> Observable<(Bool, FIRDataSnapshot?)> {
        return Observable.create { (observer: AnyObserver<(Bool, FIRDataSnapshot?)>) in
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
    func rx_onDisconnectSetValue(value: AnyObject?, priority: AnyObject? = nil) -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            if let priority = priority {
                self.onDisconnectSetValue(value,
                    andPriority: priority,
                    withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))

                return Disposables.create()
            } else {
                self.onDisconnectSetValue(value,
                    withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))

                return Disposables.create()
            }
        }
    }

    func rx_onDisconnectUpdateValue(values: [NSObject: AnyObject]) -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectUpdateChildValues(values,
                withCompletionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))

            return Disposables.create()
        }
    }

    func rx_onDisconnectRemoveValue() -> Observable<FIRDatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            self.onDisconnectRemoveValue(completionBlock: FIRDatabaseReference.rx_setCallback(observer: observer))
            return Disposables.create()
        }
    }

    // MARK: - Helper methods
    private static func rx_setCallback(observer: AnyObserver<FIRDatabaseReference>) -> ((Error?, FIRDatabaseReference) -> Void) {
        return { (error: Error?, reference: FIRDatabaseReference) in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(reference)
                observer.onCompleted()
            }
        }
    }
}