# IRFNavigationKit

[![Version](http://cocoapod-badges.herokuapp.com/v/IRFNavigationKit/badge.png)](http://cocoadocs.org/docsets/IRFNavigationKit)
[![Platform](http://cocoapod-badges.herokuapp.com/p/IRFNavigationKit/badge.png)](http://cocoadocs.org/docsets/IRFNavigationKit)

The mothership is of the opinion that UI navigation controllers are not useful 
on OS X because they where made to transition between multiple table views.

I beg to disagree. And I have some evidence in favor of my point:

- Many chat applications on OS X navigate from a view to another in the same window.
- Safari gestures look very similar iterative transitions.
- Xcode itself implements this pattern (see text editor navigations and interface builder warnings).

I don't think that cargoculting the iOS concepts in OS X makes sense however,
toying around with it, I often miss the niceties of the iOS world.

## Description

This library is an adaptation of the view controller patters found in iOS for OS X.

It includes the following features:

- Familiar API from iOS.
- Animated transitioning support, in all its glory and flexibility.
- Navigation controller.
- Support for a navigation bars.

## Author

Fabio Pelosin, fabiopelosin@gmail.com

## TODO

- Watch WWDC Custom Transitions using View Controllers.
- Inspect wether the Navigation Controller is the transitionning context on iOS.
- Is it necessary to set the animation duration in the animator.
- Implement interative transitioning.
- Move navigation bar to a protocol.
- Implement TabBarController.
- explore viewWillAppearInception
- Tests.

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Requirements

## Installation

IRFNavigationKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "IRFNavigationKit"


## References

[UIViewControllerContextTransitioning](https://developer.apple.com/library/ios/DOCUMENTATION/UIKit/Reference/UIViewControllerContextTransitioning_protocol/Reference/Reference.html)
[UIViewControllerAnimatedTransitioning](https://developer.apple.com/library/ios/DOCUMENTATION/UIKit/Reference/UIViewControllerAnimatedTransitioning_Protocol/Reference/Reference.html)
[objc.io#5 - View Controller Transitions](http://www.objc.io/issue-5/view-controller-transitions.html)

## License

IRFNavigationKit is available under the MIT license. See the LICENSE file for more info.
