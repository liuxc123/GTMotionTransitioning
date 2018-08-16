//
//  UIViewController+GTMTransitionController.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GTMTransitionController;

@interface UIViewController (TransitionController)

/**
 A transition controller may be used to implement custom transitions.

 The transition controller is lazily created upon access.

 Side effects: If the view controller's transitioningDelegate is nil when the controller is created,
 then the controller will also be set to the transitioningDelegate property.
 */
@property(nonatomic, strong, readonly, nonnull) id<GTMTransitionController> gtm_transitionController;

@end
