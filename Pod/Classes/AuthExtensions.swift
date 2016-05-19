//
//  AuthExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseAuth
import RxSwift

public extension FIRAuth {
    // MARK: - Observable authentication state
    var rx_authState: Observable<FIRUser?> {
        get {
            return Observable.create { (observer: AnyObserver<FIRUser?>) -> Disposable in
                let handle = self.addAuthStateDidChangeListener({ (_, user) in
                    observer.onNext(user)
                })

                return AnonymousDisposable { [weak self] in
                    self?.removeAuthStateDidChangeListener(handle)
                }
            }
        }
    }

    // MARK: - Signing in
    func rx_signInWithEmail(email: String, password: String) -> Observable<FIRUser?> {
        return Observable.create { (observer: AnyObserver<FIRUser?>) -> Disposable in
            self.signInWithEmail(email, password: password, completion: FIRAuth.rx_authCallback(observer))
            return NopDisposable.instance
        }
    }

    func rx_signInAnonymously() -> Observable<FIRUser?> {
        return Observable.create { (observer: AnyObserver<FIRUser?>) -> Disposable in
            self.signInAnonymouslyWithCompletion(FIRAuth.rx_authCallback(observer))
            return NopDisposable.instance
        }
    }

    func rx_signInWithCredential(credential: FIRAuthCredential) -> Observable<FIRUser?> {
        return Observable.create { (observer: AnyObserver<FIRUser?>) -> Disposable in
            self.signInWithCredential(credential, completion: FIRAuth.rx_authCallback(observer))
            return NopDisposable.instance
        }
    }

    func rx_signInWithCustomToken(customToken: String) -> Observable<FIRUser?> {
        return Observable.create { (observer: AnyObserver<FIRUser?>) -> Disposable in
            self.signInWithCustomToken(customToken, completion: FIRAuth.rx_authCallback(observer))
            return NopDisposable.instance
        }
    }

    // MARK: - Registering and resetting password
    func rx_createUserWithEmail(email: String, password: String) -> Observable<FIRUser?> {
        return Observable.create { (observer : AnyObserver<FIRUser?>) -> Disposable in
            self.createUserWithEmail(email, password: password, completion: FIRAuth.rx_authCallback(observer))
            return NopDisposable.instance
        }
    }

    func rx_sendPasswordResetWithEmail(email: String) -> Observable<Void> {
        return Observable.create { (observer: AnyObserver<Void>) -> Disposable in
            self.sendPasswordResetWithEmail(email) { (error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }

            return NopDisposable.instance
        }
    }

    // MARK: - Signing out
    func rx_signOut() -> Observable<Void> {
        return Observable.create { (observer: AnyObserver<Void>) -> Disposable in
            do {
                try self.signOut()
                observer.onNext(())
                observer.onCompleted()
            } catch (let error) {
                observer.onError(error)
            }

            return NopDisposable.instance
        }
    }

    // MARK: - Multi-provider support
    func rx_providersForEmail(email: String) -> Observable<[String]?> {
        return Observable.create { (observer: AnyObserver<[String]?>) -> Disposable in
            self.fetchProvidersForEmail(email) { (providers, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(providers)
                    observer.onCompleted()
                }
            }

            return NopDisposable.instance
        }
    }

    // MARK: - Helper methods
    private static func rx_authCallback(observer: AnyObserver<FIRUser?>) -> FIRAuthResultCallback {
        return { (user: FIRUser?, error: NSError?) in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(user)
                observer.onCompleted()
            }
        }
    }
}