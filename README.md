# FirebaseRxSwiftExtensions

[![CI Status](http://img.shields.io/travis/Maximilian Alexander/FirebaseRxSwiftExtensions.svg?style=flat)](https://travis-ci.org/Maximilian Alexander/FirebaseRxSwiftExtensions)
[![Version](https://img.shields.io/cocoapods/v/FirebaseRxSwiftExtensions.svg?style=flat)](http://cocoapods.org/pods/FirebaseRxSwiftExtensions)
[![License](https://img.shields.io/cocoapods/l/FirebaseRxSwiftExtensions.svg?style=flat)](http://cocoapods.org/pods/FirebaseRxSwiftExtensions)
[![Platform](https://img.shields.io/cocoapods/p/FirebaseRxSwiftExtensions.svg?style=flat)](http://cocoapods.org/pods/FirebaseRxSwiftExtensions)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This library is built on Swift 2.2 and needs Xcode 7 or higher to work.
This library is build for RxSwift 2.5 or higher. Please take note of the syntax changes when migrating from an
older version of Swift to Swift 2 or higher.

## Installation

FirebaseRxSwiftExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FirebaseRxSwiftExtensions"
```

## Modules Needed

```swift
import Firebase
import RxSwift
import FirebaseRxSwiftExtensions
```

### Highly Recommended

## Use DisposeBags
I highly recommend always having a `disposeBag` available in every controller.
It's very important to dispose the subscription or else Firebase may never stop listening when ViewControllers are deallocated

If you are referencing a the view controller in your `subscribe` or `subscribeNext` blocks, please make sure to use `[weak self]` or `[unowned self]` to prevent
a retain cycle.

For example:

```swift
    var disposeBag = DisposeBag()
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad(animated: bool)
        // .. stuff

        query.rx_observeEventType(.ChildAdded)
            .subscribeNext { [weak self] snapshot in
                self?.nameLabel.text = snapshot.value["name"] as? String
            }
            .addDisposableTo(disposeBag)
    }
```

### Observe a Snapshot

The `rx_observeEventType(eventType: FIRDataEventType)` method observes a Firebase reference or a query for its snapshot.

```swift
    let query = FIRDatabase.database().reference(...).queryOrderedByChild("height")
    query.rx_observeEventType(.ChildAdded)
        .subscribeNext { (snapshot: FIRDataSnapshot) in
            //do something with your snapshot
        }
```

To listen for a snapshot and it's siblingKey. This is useful events like `.ChildMoved` and `.ChildChanged`:

```swift
    let query = FIRDatabase.database().reference(...).queryOrderedByChild("height")

    query.rx_observeEventType(.ChildRemoved)
        .subscribeNext{ (tuple: (FIRDataSnapshot, String?) in
            // The tuple contains the snapshot and the optional sibling key
        }
```

Cool hint: You can name parts of your tuple to make things easier

```swift
    let query = FIRDatabase.database().reference(...).queryOrderedByChild("height")

    query.rx_observeEventType(.ChildRemoved)
        .subscribeNext{ (tuple: (snapshot: FIRDataSnapshot, siblingKey: String?) in
            // The tuple contains the snapshot and the sibling key
            print(tuple.snapshot)
            print(tuple.siblingKey)
        }
```


### Observe a Snapshot Once

I didn't create an observeSingleEvent rx method. Simply just do a `take(1)` on an FIRDatabaseQuery or FIRDatabaseReference.

```swift
    queryOrRef.rx_observeEventType(.ChildAdded).take(1)
        .subscribeNext{ (snapshot: FIRDataSnapshot) in
            //this snapshot is fired once and the listener is disposed of as soon as it fires just once.
        }
```

### Set and Update values

These are relatively straight forward. The operate exactly like their native Firebase equivalents:

- `rx_setValues`
- `rx_updateChildValues`

## Authentication

You can easily observe your authentication state:

```swift
    let auth = FIRAuth.auth()?.rx_authState()
        .subscribeNext{ user in
            if let user == user {
                print("You're logged in, user is not nil")
            }else{
                print("You are NOT logged in")
            }
        }
```

You can authenticate and manage the user with respective methods of FIRAuth:

```swift
    rx_signInWithEmail(email: String, password: String) -> Observable<FIRUser?>

    rx_signInAnonymously() -> Observable<FIRUser?>

    rx_signInWithCredential(credential: FIRAuthCredential) -> Observable<FIRUser?>

    rx_signInWithCustomToken(customToken: String) -> Observable<FIRUser?>

    rx_createUserWithEmail(email: String, password: String) -> Observable<FIRUser?>

    rx_sendPasswordResetWithEmail(email: String) -> Observable<Void>

    rx_signOut() -> Observable<Void>

    rx_providersForEmail(email: String) -> RxSwift.Observable<[String]?>
```

More authentication methods (account linking, etc.) to come!

## Convenience methods

You can check if a snapshot has a value or not by these two extension methods. They operate on `Observable<FIRDataSnapshot>`

- `rx_filterWhenExists()`
- `rx_filterWhenNotExists()`

## Author

Maximilian Alexander, mbalex99@gmail.com
Rewritten for Firebase SDK 3.2.0 by Zsolt Váradi, zsolt.varadi@outlook.com

## License

FirebaseRxSwiftExtensions is available under the MIT license. See the LICENSE file for more info.
