//
//  GTMTransitionPresentationController.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GTMTransitionContext;
@protocol GTMTransitionPresentationAnimationControlling;

NS_SWIFT_NAME(TransitionFrameCalculation)
typedef CGRect (^GTMTransitionFrameCalculation)(UIPresentationController * _Nonnull);

/**
 A transition presentation controller implementation that supports animation delegation, a darkened
 overlay view, and custom presentation frames.

 The presentation controller will create and manage the lifecycle of the scrim view, ensuring that
 it is removed upon a completed dismissal of the presented view controller.
 */
NS_SWIFT_NAME(TransitionPresentationController)
@interface GTMTransitionPresentationController : UIPresentationController

/**
 Initializes a presentation controller with the standard values and a frame calculation block.

 The frame calculation block is expected to return the desired frame of the presented view
 controller.
 */
- (nonnull instancetype)initWithPresentedViewController:(nonnull UIViewController *)presentedViewController
                               presentingViewController:(nonnull UIViewController *)presentingViewController
                          calculateFrameOfPresentedView:(nullable GTMTransitionFrameCalculation)calculateFrameOfPresentedView
NS_DESIGNATED_INITIALIZER;

/**
 The presentation controller's scrim view.
 */
@property(nonatomic, strong, nullable, readonly) UIView * scrimView;

/**
 The animation controller is able to customize animations in reaction to view controller
 presentation and dismissal events.

 The animation controller is explicitly nil'd upon completion of the dismissal transition.
 */
@property(nonatomic, strong, nullable) id <GTMTransitionPresentationAnimationControlling> animationController;

@end

/**
 An animation controller receives additional presentation- and dismissal-related events during a
 view controller transition.
 */
NS_SWIFT_NAME(TransitionPresentationAnimationControlling)
@protocol GTMTransitionPresentationAnimationControlling <NSObject>
@optional

/**
 Allows the receiver to register animations for the given transition context.

 Invoked prior to the Transition instance's startWithContext.

 If not implemented, the scrim view will be faded in during presentation and out during dismissal.
 */
- (void)presentationController:(nonnull GTMTransitionPresentationController *)presentationController
              startWithContext:(nonnull NSObject<GTMTransitionContext> *)context;

/**
 Informs the receiver that the dismissal transition is about to begin.
 */
- (void)dismissalTransitionWillBeginWithPresentationController:(nonnull GTMTransitionPresentationController *)presentationController;

/**
 Informs the receiver that the dismissal transition has completed.
 */
- (void)presentationController:(nonnull GTMTransitionPresentationController *)presentationController
     dismissalTransitionDidEnd:(BOOL)completed;

@end

