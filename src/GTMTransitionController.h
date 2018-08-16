//
//  GTMTransitionController.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

@protocol GTMTransition;

/**
 A transition controller is a bridge between UIKit's view controller transitioning APIs and
 Material Motion transitions.

 Each view controller owns its own transition controller via the gtm_transitionController property.
 */
NS_SWIFT_NAME(TransitionController)
@protocol GTMTransitionController <NSObject>

/**
 The transition instance that will govern any presentation or dismissal of the view controller.

 If no transition is provided then a default UIKit transition will be used.

 If the transition conforms to GTMTransitionWithPresentation, then the transition's default modal
 presentation style will be queried and assigned to the associated view controller's
 `modalPresentationStyle` property.
 */
@property(nonatomic, strong, nullable) id<GTMTransition> transition;

/**
 The active transition instance.

 This may be non-nil while a transition is active.
 */
@property(nonatomic, strong, nullable, readonly) id<GTMTransition> activeTransition;

@end
