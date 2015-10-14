# KGFloatingDrawer

KGFloatingDrawer is a reimplementation of
[JVillella/JVFloatingDrawer](https://github.com/JVillella/JVFloatingDrawer) in
Swift. A floating drawer style navigation. KGFloatingDrawer provides a unique
twist on the nav drawer pattern.

![](https://github.com/KyleGoddard/KGFloatingDrawer/blob/master/kgfloatingdrawer_github_preview.gif)

#Usage

```swift
func prepareDrawerViewController() -> KGDrawerViewController {
    let drawerViewController = KGDrawerViewController()

    drawerViewController.centerViewController = drawerSettingsViewController()
    drawerViewController.leftViewController = leftViewController()
    drawerViewController.rightViewController = rightViewController()
    drawerViewController.backgroundImage = UIImage(named: "sky3")

    _drawerViewController = drawerViewController

    return drawerViewController
}
```

#Installation

KGFloatingDrawer can be installed as a CocoaPod. To install it, simply add the following line to your Podfile:

```
pod 'KGFloatingDrawer', '~> 0.2.0'
```

###Important Note

KGFloatingDrawer requires `Swift 2.0`, `XCode 7.0` and `CocoaPods 0.36.0`


#How it Works

###KGDrawerViewController

The `KGDrawerViewController` maintains references to center, left and optionally
right view controllers. The `centerViewController`, `leftViewController` and
`rightViewController` properties can all be reassigned in order to replace them.

###Opening & Closing Drawers

`KGDrawerViewController` has three functions used to open and close the nav
drawer.

```swift
func openDrawer(side: KGDrawerSide, animated:Bool, complete: (finished: Bool) -> Void) {}

func closeDrawer(side: KGDrawerSide, animated: Bool, complete: (finished: Bool) -> Void) {}

func toggleDrawer(side: KGDrawerSide, animated: Bool, complete: (finished: Bool) -> Void) {}
```

###Drawer Width

The `leftDrawerWidth` and `rightDrawerWidth` are used to set the width of the
drawer once it has been opened. Note that this is not the edge size of the
`centerViewController`. The default value for this is `280` points.

###Background Image

The background image displayed when the drawer is open is set via the
`backgroundImage` property.

###Animator

`KGFloatingDrawer` comes with a spring animator with the configurable
properties: `animationDelay`, `animationDuration`, `initialSpringVelocity`, and
`springDamping`

But [JVillella/JVFloatingDrawer](https://github.com/JVillella/JVFloatingDrawer)
has custom animators!?

I know! The ability to set a custom animator is coming soon.

#Author

Kyle Goddard

[JVillella/JVFloatingDrawer](https://github.com/JVillella/JVFloatingDrawer) was
authored by Julian Villella

#License

KGFloatingDrawer is available under the MIT license. See the LICENSE file for
more info.
