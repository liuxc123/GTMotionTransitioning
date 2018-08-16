//
//  GTMTransitionNavigationControllerDelegate.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <UIKit/UIKit.h>

/**
 This class provides a singleton implementation of UINavigationControllerDelegate that makes it
 possible to configure view controller transitions using each view controller's transition
 controller.

 This class is not meant to be instantiated directly.

 The +delegate should be assigned as the delegate for any UINavigationController instance that
 wishes to configure transitions using the gtm_transitionController (transitionController in Swift)
 property on a view controller.

 If a navigation controller already has its own delegate, then that delegate can simply forward
 the two necessary methods to the +sharedInstance of this class.
 */
NS_SWIFT_NAME(TransitionNavigationControllerDelegate)
@interface GTMTransitionNavigationControllerDelegate : NSObject


/**
 Use when directly invoking methods.

 Only supported methods are exposed.
 */
+ (nonnull instancetype)sharedInstance;

/**
 Can be set as a navigation controller's delegate.
 */
+ (nonnull id<UINavigationControllerDelegate>)sharedDelegate;

#pragma mark <UINavigationControllerDelegate> Support

- (nullable id<UIViewControllerAnimatedTransitioning>)navigationController:(nonnull UINavigationController *)navigationController
                                           animationControllerForOperation:(UINavigationControllerOperation)operation
                                                        fromViewController:(nonnull UIViewController *)fromVC
                                                          toViewController:(nonnull UIViewController *)toVC;
- (nullable id<UIViewControllerInteractiveTransitioning>)navigationController:(nonnull UINavigationController *)navigationController
                                  interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController;

@end
