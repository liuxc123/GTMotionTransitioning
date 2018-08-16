//
//  GTMViewControllerTransitionController.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMViewControllerTransitionController.h"

#import "GTMTransition.h"
#import "GTMViewControllerTransitionCoordinator.h"

@interface GTMViewControllerTransitionController () <UIViewControllerTransitioningDelegate, GTMViewControllerTransitionCoordinatorDelegate>
@end

@implementation GTMViewControllerTransitionController {
    // We expect the view controller to hold a strong reference to its transition controller, so keep
    // a weak reference to the view controller here.
    __weak UIViewController *_associatedViewController;

    __weak UIPresentationController *_presentationController;

    GTMViewControllerTransitionCoordinator *_coordinator;
    __weak UIViewController *_source;
}

@synthesize transition = _transition;

- (nonnull instancetype)initWithViewController:(nonnull UIViewController *)viewController {
    self = [super init];
    if (self) {
        _associatedViewController = viewController;
    }
    return self;
}

#pragma mark - Public

- (void)setTransition:(id<GTMTransition>)transition {
    _transition = transition;

    // Set the default modal presentation style.
    id<GTMTransitionWithPresentation> withPresentation = [self presentationTransition];
    if (withPresentation != nil) {
        UIModalPresentationStyle style = [withPresentation defaultModalPresentationStyle];
        _associatedViewController.modalPresentationStyle = style;
    }
}

- (id<GTMTransition>)activeTransition {
    return [self.activeTransitions firstObject];
}

- (NSArray<id<GTMTransition>> *)activeTransitions {
    return [_coordinator activeTransitions];
}

- (id<GTMTransitionWithPresentation>)presentationTransition {
    if ([self.transition respondsToSelector:@selector(defaultModalPresentationStyle)]) {
        return (id<GTMTransitionWithPresentation>)self.transition;
    }
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

// Animated transitions

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    _source = source;

    [self prepareForTransitionWithSourceViewController:source
                                    backViewController:presenting
                                    foreViewController:presented
                                             direction:GTMTransitionDirectionForward];
    return _coordinator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self prepareForTransitionWithSourceViewController:_source
                                    backViewController:dismissed.presentingViewController
                                    foreViewController:dismissed
                                             direction:GTMTransitionDirectionBackward];
    return _coordinator;
}

// Presentation

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    id<GTMTransitionWithPresentation> withPresentation = [self presentationTransition];
    if (withPresentation == nil) {
        return nil;
    }
    UIPresentationController *presentationController =
    [withPresentation presentationControllerForPresentedViewController:presented
                                              presentingViewController:presenting
                                                  sourceViewController:source];
    // _presentationController is weakly-held, so we have to do this local var dance to keep it
    // from being nil'd on assignment.
    _presentationController = presentationController;
    return presentationController;
}

#pragma mark - GTMViewControllerTransitionCoordinatorDelegate

- (void)transitionDidCompleteWithCoordinator:(GTMViewControllerTransitionCoordinator *)coordinator {
    if (_coordinator == coordinator) {
        _coordinator = nil;
    }
}

#pragma mark - Private

- (void)prepareForTransitionWithSourceViewController:(nullable UIViewController *)source
                                  backViewController:(nonnull UIViewController *)back
                                  foreViewController:(nonnull UIViewController *)fore
                                           direction:(GTMTransitionDirection)direction {
    if (direction == GTMTransitionDirectionBackward) {
        _coordinator = nil;
    }
    NSAssert(!_coordinator, @"A transition is already active.");

    _coordinator = [[GTMViewControllerTransitionCoordinator alloc] initWithTransition:self.transition
                                                                            direction:direction
                                                                 sourceViewController:source
                                                                   backViewController:back
                                                                   foreViewController:fore
                                                               presentationController:_presentationController];
    _coordinator.delegate = self;
}

@end

