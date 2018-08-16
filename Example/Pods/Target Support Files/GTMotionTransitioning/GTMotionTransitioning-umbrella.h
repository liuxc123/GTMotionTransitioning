#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GTMotionTransitioning.h"
#import "GTMTransition.h"
#import "GTMTransitionContext.h"
#import "GTMTransitionController.h"
#import "GTMTransitionNavigationControllerDelegate.h"
#import "GTMTransitionPresentationController.h"
#import "GTMTransitionViewSnapshotter.h"
#import "UIViewController+TransitionController.h"

FOUNDATION_EXPORT double GTMotionTransitioningVersionNumber;
FOUNDATION_EXPORT const unsigned char GTMotionTransitioningVersionString[];

