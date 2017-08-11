//
//  AuthExtensions.swift
//  FirebaseRxSwiftExtensions
//

import FirebaseAuth
import RxSwift

public let ErrorCodeUnknownError = 9000

public extension Auth {
    // MARK: - Observable authentication state
    var rx_authState: Observable<User?> {
        get {
            return Observable.create { (observer: AnyObserver<User?>) -> Disposable in
                let handle = self.addStateDidChangeListener({ (_, user) in
                    observer.onNext(user)
                })

                return Disposables.create { [weak self] in
                    self?.removeStateDidChangeListener(handle)
                }
            }
        }
    }

    // MARK: - Signing in
    func rx_signInWithEmail(email: String, password: String) -> Single<User> {
        return Single<User>.create { single in
            self.signIn(withEmail: email, password: password, completion: Auth.rx_authCallback(single: single))
            return Disposables.create()
        }
    }

    func rx_signInAnonymously() -> Single<User> {
        return Single<User>.create { single in
            self.signInAnonymously(completion: Auth.rx_authCallback(single: single))
            return Disposables.create()
        }
    }

    func rx_signInWithCredential(credential: AuthCredential) -> Single<User> {
        return Single<User>.create { single in
            self.signIn(with: credential, completion: Auth.rx_authCallback(single: single))
            return Disposables.create()
        }
    }

    func rx_signInWithCustomToken(customToken: String) -> Single<User> {
        return Single<User>.create { single in
            self.signIn(withCustomToken: customToken, completion: Auth.rx_authCallback(single: single))
            return Disposables.create()
        }
    }

    // MARK: - Registering and resetting password
    func rx_createUserWithEmail(email: String, password: String) -> Single<User> {
        return Single<User>.create { single in
            self.createUser(withEmail: email, password: password, completion: Auth.rx_authCallback(single: single))
            return Disposables.create()
        }
    }

    func rx_sendPasswordResetWithEmail(email: String) -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            self.sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        })
    }

    // MARK: - Signing out
    func rx_signOut() -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            do {
                try self.signOut()
                completable(.completed)
            } catch (let error) {
                completable(.error(error))
            }
            return Disposables.create()
        })
    }

    // MARK: - Multi-provider support
    func rx_providersForEmail(email: String) -> Single<[String]?> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.fetchProviders(forEmail: email) { (providers, error) in
                if let error = error {
                    single(.error(error))
                } else {
                    single(.success(providers))
                }
            }

            return Disposables.create()
        })
    }

    // MARK: - Helper methods
    private static func rx_authCallback(single: @escaping ((SingleEvent<User>) -> ())) -> AuthResultCallback {
        return { (user: User?, error: Error?) in
            guard let user = user else {
                single(.error(error ?? NSError(domain: "FirebaseRxSwiftExtensions", code: ErrorCodeUnknownError,
                                               userInfo: nil)))
                return;
            }
            single(.success(user))
        }
    }
}
