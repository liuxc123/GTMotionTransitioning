//
//  UIViewController+GTMTransitionController.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "UIViewController+TransitionController.h"

#import "private/GTMViewControllerTransitionController.h"

#import <objc/runtime.h>

@implementation UIViewController (TransitionController)

#pragma mark - Public

- (id<GTMTransitionController>)gtm_transitionController {
    const void *key = [self gtm_transitionControllerKey];

    GTMViewControllerTransitionController *controller = objc_getAssociatedObject(self, key);
    if (!controller) {
        controller = [[GTMViewControllerTransitionController alloc] initWithViewController:self];
        [self gtm_setTransitionController:controller];
    }
    return controller;
}

#pragma mark - Private

- (void)gtm_setTransitionController:(GTMViewControllerTransitionController *)controller {
    const void *key = [self gtm_transitionControllerKey];

    // Clear the previous delegate if we'd previously set one.
    GTMViewControllerTransitionController *existingController = objc_getAssociatedObject(self, key);
    id<UIViewControllerTransitioningDelegate> delegate = self.transitioningDelegate;
    if (existingController == delegate) {
        self.transitioningDelegate = nil;
    }

    objc_setAssociatedObject(self, key, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!delegate) {
        self.transitioningDelegate = controller;
    }
}

- (const void *)gtm_transitionControllerKey {
    return @selector(gtm_transitionController);
}

@end
