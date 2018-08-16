//
//  GTMTransitionViewSnapshotter.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A view snapshotter creates visual replicas of views so that they may be animated during a
 transition without adversely affecting the original view hierarchy.
 */
NS_SWIFT_NAME(TransitionViewSnapshotter)
@interface GTMTransitionViewSnapshotter : NSObject

/**
 Initializes a snapshotter with a given container view.

 All snapshot views will be added to the container view as a direct subview.
 */
- (nonnull instancetype)initWithContainerView:(nonnull UIView *)containerView NS_DESIGNATED_INITIALIZER;

/**
 Returns a snapshot view of the provided view.

 The snapshotter will keep a reference to the returned view in order to facilitate its eventual
 removal via removeAllSnapshots once the snapshot is no longer needed.

 @param view The view to be snapshotted.
 @param isAppearing If the view is appearing for the first time, a slower form of snapshotting may
 be used. Otherwise, fast snapshotting may be used.
 @return A new UIView instance that can be used as a visual replica of the provided view.
 */
- (nonnull UIView *)snapshotOfView:(nonnull UIView *)view isAppearing:(BOOL)isAppearing;

/**
 Removes all snapshots from their superview and unhide the snapshotted views.
 */
- (void)removeAllSnapshots;

/**
 Unavailable. Use initWithContainerView: instead.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end

