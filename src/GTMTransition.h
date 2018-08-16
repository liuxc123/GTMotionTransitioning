//
//  GTMTransition.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <UIKit/UIKit.h>

@protocol GTMTransitionContext;

/**
 A transition coordinates the animated presentation or dismissal of a view controller.

 By default a transition is only expected to implement startWithContext: and to eventually call the
 context's `transitionDidEnd` method once the transition completes.

 A transition can opt in to extra behavior by conforming to other TransitionWith* protocols.
 */
NS_SWIFT_NAME(Transition)
@protocol GTMTransition <NSObject>

/**
 Invoked on initiation of a view controller transition.
 */
- (void)startWithContext:(nonnull id<GTMTransitionContext>)context;

@end

/**
 A transition with custom duration is able to override the default transition duration.
 */
NS_SWIFT_NAME(TransitionWithCustomDuration)
@protocol GTMTransitionWithCustomDuration <GTMTransition>

/**
 The desired duration of this transition in seconds.
 */
- (NSTimeInterval)transitionDurationWithContext:(nonnull id<GTMTransitionContext>)context;

@end

/**
 A transition with a fallback can choose to return an alternative fallback transition instance.

 This is most often used in cases where a transition has certain preconditions that aren't met, such
 as requesting a context view where none is available.
 */
NS_SWIFT_NAME(TransitionWithFallback)
@protocol GTMTransitionWithFallback <GTMTransition>

/**
 Asks the receiver to return a transition instance that should be used to drive this transition.

 If self is returned, then the receiver will be used.

 If a new instance is returned and the returned instance also conforms to this protocol, the
 returned instance will be queried for a fallback, otherwise the returned instance will be used.
 */
- (nonnull id<GTMTransition>)fallbackTransitionWithContext:(nonnull id<GTMTransitionContext>)context;

@end

/**
 A transition with feasibility can indicate whether it's capable of handling a given context.
 */
NS_SWIFT_NAME(TransitionWithFeasibility)
@protocol GTMTransitionWithFeasibility <GTMTransition>

/**
 Asks the receiver whether it's capable of performing the transition with the given context.

 If NO is returned, the receiver's startWithContext: will not be invoked.
 If the transition is infeasible, then a default UIKit transition will be performed instead.

 If YES is returned, the receiver's startWithContext: will be invoked.

 The context's containerView will be nil during this call.

 If your transition composes to other transitions then it may wish to query those transitions for
 feasibility as well.
 */
- (BOOL)canPerformTransitionWithContext:(nonnull id<GTMTransitionContext>)context;

@end

/**
 A transition with presentation is able to customize the overall presentation of the transition,
 including adding temporary views and changing the destination frame of the presented view
 controller.
 */
NS_SWIFT_NAME(TransitionWithPresentation)
@protocol GTMTransitionWithPresentation <GTMTransition>

/**
 The modal presentation style this transition expects to use.

 This method is queried when the transition is assigned to a view controller's
 `transitionController` transition property. The result, if any, is assigned to the view
 controller's `modalPresentationStyle` property.

 Note: In order for a presentation controller to be used the view controller's
 `modalPresentationStyle` must be `.custom`.

 If you do not wish to use a presentation controller, return anything other than
 `UIModalPresentationStyleCustom`.
 */
- (UIModalPresentationStyle)defaultModalPresentationStyle;

/**
 Queried when the presented view controller is first presented.

 The returned object is cached for the lifetime of the presented view controller.

 If the returned object conforms to GTMTransition then its `startWithContext:` implementation will
 be invoked before the transition's `startWithContext:`.

 If nil is returned then no presentation controller will be used.
 */
// clang-format off
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(nonnull UIViewController *)presented
                                                               presentingViewController:(nonnull UIViewController *)presenting
                                                                   sourceViewController:(nullable UIViewController *)source
NS_SWIFT_NAME(presentationController(forPresented:presenting:source:));
// clang-format on

@end

