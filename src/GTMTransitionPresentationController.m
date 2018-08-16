//
//  GTMTransitionPresentationController.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMTransitionPresentationController.h"

#import "GTMTransition.h"
#import "GTMTransitionContext.h"
#import "GTMTransitionController.h"
#import "UIViewController+TransitionController.h"

@interface GTMTransitionPresentationController () <GTMTransition>
@end

@implementation GTMTransitionPresentationController {
    CGRect (^_calculateFrameOfPresentedView)(UIPresentationController *);
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                  calculateFrameOfPresentedView:(GTMTransitionFrameCalculation)calculateFrameOfPresentedView {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        _calculateFrameOfPresentedView = [calculateFrameOfPresentedView copy];
    }
    return self;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [self initWithPresentedViewController:presentedViewController
                        presentingViewController:presentingViewController
                   calculateFrameOfPresentedView:nil];
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (_calculateFrameOfPresentedView) {
        return _calculateFrameOfPresentedView(self);
    } else {
        return self.containerView.bounds;
    }
}

- (BOOL)shouldRemovePresentersView {
    // We don't have access to the container view when this method is called, so we can only guess as
    // to whether we'll be presenting full screen by checking for the presence of a frame calculation
    // block.
    BOOL definitelyFullscreen = _calculateFrameOfPresentedView == nil;

    // Returning true here will cause UIKit to invoke viewWillDisappear and viewDidDisappear on the
    // presenting view controller, and the presenting view controller's view will be removed on
    // completion of the transition.
    return definitelyFullscreen;
}

- (void)dismissalTransitionWillBegin {
    if (!self.presentedViewController.gtm_transitionController.activeTransition) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.scrimView.alpha = 0;
        } completion:nil];

        if ([self.animationController respondsToSelector:@selector(dismissalTransitionWillBeginWithPresentationController:)]) {
            [self.animationController dismissalTransitionWillBeginWithPresentationController:self];
        }
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.scrimView removeFromSuperview];
        _scrimView = nil;

    } else {
        self.scrimView.alpha = 1;
    }

    if ([self.animationController respondsToSelector:@selector(presentationController:dismissalTransitionDidEnd:)]) {
        [self.animationController presentationController:self dismissalTransitionDidEnd:completed];
    }

    if (completed) {
        // Break any potential memory cycles due to our strong ownership of the animation controller.
        self.animationController = nil;
    }
}

- (void)startWithContext:(NSObject<GTMTransitionContext> *)context {
    if (!self.scrimView) {
        _scrimView = [[UIView alloc] initWithFrame:context.containerView.bounds];
        self.scrimView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                           | UIViewAutoresizingFlexibleHeight);
        self.scrimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        [context.containerView insertSubview:self.scrimView
                                belowSubview:context.foreViewController.view];
    }

    if ([self.animationController respondsToSelector:@selector(presentationController:startWithContext:)]) {
        [self.animationController presentationController:self startWithContext:context];
    } else {
        self.scrimView.alpha = context.direction == GTMTransitionDirectionForward ? 0 : 1;

        [UIView animateWithDuration:context.duration animations:^{
            self.scrimView.alpha = context.direction == GTMTransitionDirectionForward ? 1 : 0;
        } completion:^(BOOL finished) {
            [context transitionDidEnd];
        }];
    }
}

@end

