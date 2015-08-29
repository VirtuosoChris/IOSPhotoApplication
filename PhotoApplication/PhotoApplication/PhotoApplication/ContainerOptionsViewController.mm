//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

///
///@file ContainerOptionsViewController.m
///@brief Handles all the magic for swapping the bottom panel view controllers
//


#import "ContainerOptionsViewController.h"
#include <iostream>
#import "AppDelegate.h"

@interface ContainerOptionsViewController ()

@end

@implementation ContainerOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.transitioning = false;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.childViewControllers.count >0)
    {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    }
    else
    {
        [self addChildViewController:segue.destinationViewController];
        ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
        [segue.destinationViewController didMoveToParentViewController:self];
    }
}


- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    self.transitioning = true;
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:.250 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished)
    {
        self.transitioning = false;
        self.transitioning = false;
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}


- (void)swapToImageVC
{
    if(!appState.backgroundPanelIsImage || (appState.imageLaunchOptions!= NONE))
    {
     [self performSegueWithIdentifier:SegueIdentifierSecond sender:nil];
    }
}


- (void)swapToColorVC
{
    if(appState.backgroundPanelIsImage)
    {
        [self performSegueWithIdentifier:SegueIdentifierFirst sender:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
