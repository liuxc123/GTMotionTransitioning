//
//  GTMViewControllerTransitionCoordinator.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMViewControllerTransitionCoordinator.h"

#import "GTMTransition.h"

@class GTMViewControllerTransitionContextNode;

@protocol GTMViewControllerTransitionContextNodeParent <NSObject>
- (void)childNodeTransitionDidEnd:(GTMViewControllerTransitionContextNode *)childNode;
@end

@interface GTMViewControllerTransitionContextNode : NSObject <GTMTransitionContext, GTMViewControllerTransitionContextNodeParent>
@property(nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property(nonatomic, strong, readonly) id<GTMTransition> transition;
@property(nonatomic, copy, readonly) NSMutableArray<GTMViewControllerTransitionContextNode *> *children;
@end

@implementation GTMViewControllerTransitionContextNode {
    // Every node points to the same array in memory.
    NSMutableArray *_sharedCompletionBlocks;

    BOOL _hasStarted;
    BOOL _didEnd;
    __weak id<GTMViewControllerTransitionContextNodeParent> _parent;
}

@synthesize duration = _duration;
@synthesize direction = _direction;
@synthesize sourceViewController = _sourceViewController;
@synthesize backViewController = _backViewController;
@synthesize foreViewController = _foreViewController;
@synthesize presentationController = _presentationController;

- (instancetype)initWithTransition:(id<GTMTransition>)transition
                         direction:(GTMTransitionDirection)direction
              sourceViewController:(UIViewController *)sourceViewController
                backViewController:(UIViewController *)backViewController
                foreViewController:(UIViewController *)foreViewController
            presentationController:(UIPresentationController *)presentationController
            sharedCompletionBlocks:(NSMutableArray *)sharedCompletionBlocks
                            parent:(id<GTMViewControllerTransitionContextNodeParent>)parent {
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
        _transition = transition;
        _direction = direction;
        _sourceViewController = sourceViewController;
        _backViewController = backViewController;
        _foreViewController = foreViewController;
        _presentationController = presentationController;
        _sharedCompletionBlocks = sharedCompletionBlocks;
        _parent = parent;
    }
    return self;
}

#pragma mark - Private

- (GTMViewControllerTransitionContextNode *)spawnChildWithTransition:(id<GTMTransition>)transition {
    GTMViewControllerTransitionContextNode *node =
    [[GTMViewControllerTransitionContextNode alloc] initWithTransition:transition
                                                             direction:_direction
                                                  sourceViewController:_sourceViewController
                                                    backViewController:_backViewController
                                                    foreViewController:_foreViewController
                                                presentationController:_presentationController
                                                sharedCompletionBlocks:_sharedCompletionBlocks
                                                                parent:self];
    node.transitionContext = _transitionContext;
    return node;
}

- (void)checkAndNotifyOfCompletion {
    BOOL anyChildActive = NO;
    for (GTMViewControllerTransitionContextNode *child in _children) {
        if (!child->_didEnd) {
            anyChildActive = YES;
            break;
        }
    }

    if (!anyChildActive && _didEnd) { // Inform our parent of completion.
        [_parent childNodeTransitionDidEnd:self];
    }
}

#pragma mark - Public

- (void)start {
    if (_hasStarted) {
        return;
    }

    _hasStarted = YES;

    for (GTMViewControllerTransitionContextNode *child in _children) {
        [child attemptFallback];

        [child start];
    }

    if ([_transition respondsToSelector:@selector(startWithContext:)]) {
        [_transition startWithContext:self];
    } else {
        _didEnd = YES;

        [self checkAndNotifyOfCompletion];
    }
}

- (NSArray *)activeTransitions {
    NSMutableArray *activeTransitions = [NSMutableArray array];
    if (!_didEnd) {
        [activeTransitions addObject:self];
    }
    for (GTMViewControllerTransitionContextNode *child in _children) {
        [activeTransitions addObjectsFromArray:[child activeTransitions]];
    }
    return activeTransitions;
}

- (void)setTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;

    for (GTMViewControllerTransitionContextNode *child in _children) {
        child.transitionContext = transitionContext;
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;

    for (GTMViewControllerTransitionContextNode *child in _children) {
        child.duration = duration;
    }
}

- (void)attemptFallback {
    id<GTMTransition> transition = _transition;
    while ([transition respondsToSelector:@selector(fallbackTransitionWithContext:)]) {
        id<GTMTransitionWithFallback> withFallback = (id<GTMTransitionWithFallback>)transition;

        id<GTMTransition> fallback = [withFallback fallbackTransitionWithContext:self];
        if (fallback == transition) {
            break;
        }
        transition = fallback;
    }
    _transition = transition;
}

#pragma mark - GTMViewControllerTransitionContextNodeDelegate

- (void)childNodeTransitionDidEnd:(GTMViewControllerTransitionContextNode *)contextNode {
    [self checkAndNotifyOfCompletion];
}

#pragma mark - GTMTransitionContext

- (void)composeWithTransition:(id<GTMTransition>)transition {
    GTMViewControllerTransitionContextNode *child = [self spawnChildWithTransition:transition];

    [_children addObject:child];

    if (_hasStarted) {
        [child start];
    }
}

- (UIView *)containerView {
    return _transitionContext.containerView;
}

- (void)deferToCompletion:(void (^)(void))work {
    [_sharedCompletionBlocks addObject:[work copy]];
}

- (void)transitionDidEnd {
    if (_didEnd) {
        return; // No use in re-notifying.
    }
    _didEnd = YES;

    [self checkAndNotifyOfCompletion];
}

@end

@interface GTMViewControllerTransitionCoordinator() <GTMViewControllerTransitionContextNodeParent>
@end

@implementation GTMViewControllerTransitionCoordinator {
    GTMTransitionDirection _direction;
    UIPresentationController *_presentationController;

    GTMViewControllerTransitionContextNode *_root;
    NSMutableArray *_completionBlocks;

    id<UIViewControllerContextTransitioning> _transitionContext;
}

- (instancetype)initWithTransition:(NSObject<GTMTransition> *)transition
                         direction:(GTMTransitionDirection)direction
              sourceViewController:(UIViewController *)sourceViewController
                backViewController:(UIViewController *)backViewController
                foreViewController:(UIViewController *)foreViewController
            presentationController:(UIPresentationController *)presentationController {
    self = [super init];
    if (self) {
        _direction = direction;
        _presentationController = presentationController;

        _completionBlocks = [NSMutableArray array];

        // Build our contexts:

        _root = [[GTMViewControllerTransitionContextNode alloc] initWithTransition:transition
                                                                         direction:direction
                                                              sourceViewController:sourceViewController
                                                                backViewController:backViewController
                                                                foreViewController:foreViewController
                                                            presentationController:presentationController
                                                            sharedCompletionBlocks:_completionBlocks
                                                                            parent:self];

        if (_presentationController
            && [_presentationController respondsToSelector:@selector(startWithContext:)]) {
            GTMViewControllerTransitionContextNode *presentationNode =
            [[GTMViewControllerTransitionContextNode alloc] initWithTransition:(id<GTMTransition>)_presentationController
                                                                     direction:direction
                                                          sourceViewController:sourceViewController
                                                            backViewController:backViewController
                                                            foreViewController:foreViewController
                                                        presentationController:presentationController
                                                        sharedCompletionBlocks:_completionBlocks
                                                                        parent:_root];
            [_root.children addObject:presentationNode];
        }

        if ([transition respondsToSelector:@selector(canPerformTransitionWithContext:)]) {
            id<GTMTransitionWithFeasibility> withFeasibility = (id<GTMTransitionWithFeasibility>)transition;
            if (![withFeasibility canPerformTransitionWithContext:_root]) {
                self = nil;
                return nil; // No active transitions means no need for a coordinator.
            }
        }
    }
    return self;
}

#pragma mark - GTMViewControllerTransitionContextNodeDelegate

- (void)childNodeTransitionDidEnd:(GTMViewControllerTransitionContextNode *)node {
    if (_root != nil && _root == node) {
        _root = nil;

        for (void (^work)(void) in _completionBlocks) {
            work();
        }
        [_completionBlocks removeAllObjects];

        [_transitionContext completeTransition:true];
        _transitionContext = nil;

        [_delegate transitionDidCompleteWithCoordinator:self];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = 0.35;
    if ([_root.transition respondsToSelector:@selector(transitionDurationWithContext:)]) {
        id<GTMTransitionWithCustomDuration> withCustomDuration = (id<GTMTransitionWithCustomDuration>)_root.transition;
        duration = [withCustomDuration transitionDurationWithContext:_root];
    }
    _root.duration = duration;
    return duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;

    [self initiateTransition];
}

// TODO(featherless): Implement interactive transitioning. Need to implement
// UIViewControllerInteractiveTransitioning here and isInteractive and interactionController* in
// GTMViewControllerTransitionController.

- (NSArray<NSObject<GTMTransition> *> *)activeTransitions {
    return [_root activeTransitions];
}

#pragma mark - Private

- (void)initiateTransition {
    _root.transitionContext = _transitionContext;

    UIViewController *from = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    if (fromView == nil) {
        fromView = from.view;
    }
    if (fromView != nil && fromView == from.view) {
        CGRect finalFrame = [_transitionContext finalFrameForViewController:from];
        if (!CGRectIsEmpty(finalFrame)) {
            fromView.frame = finalFrame;
        }
    }

    UIViewController *to = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [_transitionContext viewForKey:UITransitionContextToViewKey];
    if (toView == nil) {
        toView = to.view;
    }
    if (toView != nil && toView == to.view) {
        CGRect finalFrame = [_transitionContext finalFrameForViewController:to];
        if (!CGRectIsEmpty(finalFrame)) {
            toView.frame = finalFrame;
        }

        if (toView.superview == nil) {
            switch (_direction) {
                case GTMTransitionDirectionForward:
                    [_transitionContext.containerView addSubview:toView];
                    break;

                case GTMTransitionDirectionBackward:
                    [_transitionContext.containerView insertSubview:toView atIndex:0];
                    break;
            }
        }
    }

    [toView layoutIfNeeded];

    [_root attemptFallback];
    [self anticipateOnlyExplicitAnimations];

    [CATransaction begin];
    [CATransaction setAnimationDuration:[self transitionDuration:_transitionContext]];

    [_root start];

    [CATransaction commit];
}

// UIKit transitions will not animate any of the system animations (status bar changes, notably)
// unless we have at least one implicit UIView animation. Material Motion doesn't use implicit
// animations out of the box, so to ensure that system animations still occur we create an
// invisible throwaway view and apply an animation to it.
- (void)anticipateOnlyExplicitAnimations {
    UIView *throwawayView = [[UIView alloc] init];
    [_transitionContext.containerView addSubview:throwawayView];

    [UIView animateWithDuration:[self transitionDuration:_transitionContext]
                     animations:^{
                         throwawayView.frame = CGRectOffset(throwawayView.frame, 1, 0);

                     }
                     completion:^(BOOL finished) {
                         [throwawayView removeFromSuperview];
                     }];
}

@end

