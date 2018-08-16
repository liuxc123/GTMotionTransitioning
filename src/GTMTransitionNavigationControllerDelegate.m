//
//  GTMTransitionNavigationControllerDelegate.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMTransitionNavigationControllerDelegate.h"

#import "GTMTransitionContext.h"
#import "private/GTMViewControllerTransitionController.h"

@interface GTMTransitionNavigationControllerDelegate () <UINavigationControllerDelegate>
@end

@implementation GTMTransitionNavigationControllerDelegate

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initInternally {
    return [super init];
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initInternally];
    });
    return sharedInstance;
}

+ (id<UINavigationControllerDelegate>)sharedDelegate {
    return [self sharedInstance];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    id<UIViewControllerAnimatedTransitioning> animator = nil;

    if (operation == UINavigationControllerOperationPush) {
        animator = [toVC.transitioningDelegate animationControllerForPresentedController:toVC
                                                                    presentingController:fromVC
                                                                        sourceController:navigationController];
    } else {
        animator = [fromVC.transitioningDelegate animationControllerForDismissedController:fromVC];
    }

    if (!animator) {
        // For some reason UIKit decides to stop responding to edge swipe dismiss gestures when we
        // customize the navigation controller delegate's animation methods. Clearing the delegate for
        // the interactive pop gesture recognizer re-enables this edge-swiping behavior.
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController conformsToProtocol:@protocol(UIViewControllerInteractiveTransitioning)]) {
        return (id<UIViewControllerInteractiveTransitioning>)animationController;
    }
    return nil;
}

@end

