//
//  GTMViewControllerTransitionController.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTMTransitionController.h"

@interface GTMViewControllerTransitionController : NSObject <GTMTransitionController, UIViewControllerTransitioningDelegate>

- (nonnull instancetype)initWithViewController:(nonnull UIViewController *)viewController
NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
