//
//  GTViewController.m
//  GTMotionTransitioning
//
//  Created by liuxc123 on 08/14/2018.
//  Copyright (c) 2018 liuxc123. All rights reserved.
//

#import "GTViewController.h"
#import <GTMotionTransitioning/GTMotionTransitioning.h>

@interface GTViewController ()

@end

@implementation GTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"Transitioning";

    [self presentViewController:vc animated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
