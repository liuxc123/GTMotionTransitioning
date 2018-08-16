//
//  GTMViewControllerTransitionCoordinator.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMTransitionContext.h"

@protocol GTMTransition;
@protocol GTMViewControllerTransitionCoordinatorDelegate;

@interface GTMViewControllerTransitionCoordinator : NSObject <UIViewControllerAnimatedTransitioning>

- (nonnull instancetype)initWithTransition:(nonnull NSObject<GTMTransition> *)transition
                                 direction:(GTMTransitionDirection)direction
                      sourceViewController:(nullable UIViewController *)sourceViewController
                        backViewController:(nonnull UIViewController *)backViewController
                        foreViewController:(nonnull UIViewController *)foreViewController
                    presentationController:(nullable UIPresentationController *)presentationController;
- (nonnull instancetype)init NS_UNAVAILABLE;

- (nonnull NSArray<NSObject<GTMTransition> *> *)activeTransitions;

@property(nonatomic, weak, nullable) id<GTMViewControllerTransitionCoordinatorDelegate> delegate;

@end

@protocol GTMViewControllerTransitionCoordinatorDelegate

- (void)transitionDidCompleteWithCoordinator:(nonnull GTMViewControllerTransitionCoordinator *)coordinator;

@end
