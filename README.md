# UICandy 🍬

UICandy adds a little sugar to UIKit. Goals:

- **🍬 Thin abstraction on top of UIKit (i.e. syntactic sugar)**
  UICandy only depends on Foundation, UIKit and Combine. The expected behaviour of UIKit classes remains unchanged. This means that UICandy features can be adopted incrementally.
- **🚫 Banish storyboards and nibs**
  UICandy view and view controller subclasses must be defined entirely in code. By subclassing from UICandy's `View` and `ViewController` classes you'll be saved from dealing with `init(coder:)` and `init(nibName:bundle:)`.   
- **📐 Declarative style for view layout**
  Declarative style for view layout is easier to more concise than imperative style. A layout created using UICandy is a standard UIKit layout so it can be changed and updated using standard UIKit methods.
  UICandy provides views layout views (e.g. `HStack`) and modifiers that allow standard UIKit view layouts to be expressed declaratively. In most cases you'll never need to directly deal with `NSLayoutConstraint`s. 
- **🇺🇳 Integrates with Combine for state management**
  Combine enables UICandy to reduce the amount boilerplate code need to keep views up to date. UICandy also aims to handle storing `Cancellable`s reducing boiler plate code even further.
- **🎁 And more!**
  Other features include: 
    - Modal, sheet and popover presentation with `async`/`await`
    - Management of `UIViewController` properties (e.g. `title`, `toolbar`, `navigationItem`, `tabBarItem`) with Combine 
    - `FlowController` for managing a sequence of view controllers
    - Keyboard avoidance
    - Declarative interfaces for `UICollectionViewCompositionalLayout` and `UICollectionViewCompositionalLayout.list`
    - `LayoutView` for creating reusable layout templates
    - Retain cycle detection for easier debugging  


## Example

The follow code shows a simple `ViewController` subclass. Note:
- The single `init` (neither `init(nibName:bundle:)` or `init(coder:)` are required)
- The view is declared inline and in a declarative style. 

```
import UIKit
import UICandy


final class SimpleExampleViewController: ViewController {

    @Published var name: String

    lazy var rootView = ZStack(alignment: .center) {
        VStack(alignment: .center) {
            UILabel()
                .font(.largeTitle)
                .text("Hello \(name)!")
            UILabel()
                .font(.subheadline)
                .text("Welcome to UICandy")
        }
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
``` 

<img src="Images/example.jpg" width="356" height="772" alt="FormViewController screenshot">

The Demo app contains more examples of what's possible with UICandy.


# Miscellaneous Notes

## How to replace main.storyboard with code

1. Delete Main.Storyboard from the project
2. Navigate to Project settings -> The target for the app -> Build Settings
    - Remove the row 'UIKit Main Storyboard File Base Name'
3. In Info.plist navigate to 'Application Scene Manifest -> Scene Configuration -> Application Session Role -> Item 0' and delete the row 'Storyboard Name'
4. In SceneDelegate.swift, replace the implementation of `scene(_ scene:willConnectTo:options:)` with:
```
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            preconditionFailure("Unexpected scene type \(Self.self) can only connect to a UIWindowScene.")
        }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.windowScene = scene
        window.rootViewController = RootViewController() // where RootViewController is the app's initial viewController.
        window.makeKeyAndVisible()
    }
```     

## Adding `ViewBodyProvider` to an existing view

The reccommend way to use declarative view layout is to subclass one of the provided abstract classes: `View`, `Control`, `CollectionViewCell` and `CollectionReusableView`. 
If it is not possible to subclass from one of these classes then there are two alternatives approaches:
1. Use composition. E.G. create a new view subclass and add an instance as a subview to the existing view. 
2. Make the view conform to `ViewBodyProvider`. `ViewBodyProvider` requires the conforming class to be `final` and `initializeBody()` to be called at the end of the designated `init`, E.G.:
```
final class CustomControl: UIControl, ViewBodyProvider {

    let body = UILabel()
        .text("Hiya!")

    init() {
        super.init(frame: .zero)
        initializeBodyHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

## Fixes for `Circular reference` error

- Create a method on the root object
- Communicate the data via a Combine Publisher
