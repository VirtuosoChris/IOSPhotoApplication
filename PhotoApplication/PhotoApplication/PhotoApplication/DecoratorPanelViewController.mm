//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorPanelViewController.m
//

#import "DecoratorPanelViewController.h"
#import "PhotoApplication.h"


@interface DecoratorPanelViewController ()

@end

@implementation DecoratorPanelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appState.decoratorPanel = self;
    
    self.transitioning = false;
   // [self panelHome];
    [self swapPanelContentWithIdentifier:currentPanelIdentifier];
}


-(void) panelHome
{
    if(self.transitioning)return;
    //std::cout<<"HOME PRESSED "<<std::endl;
    currentPanelIdentifier = @"DecoratorHomeSegue";
    panelContentIdentifierStack = std::stack<NSString*>();
    [self swapPanelContentWithIdentifier:currentPanelIdentifier];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) swapPanelContentWithIdentifier : (NSString*) identifier
{
    [appState.decoratorVC decoratorPanelUpdated];
    
    if( [identifier isEqualToString: currentPanelIdentifier] )
    {
        [self performSegueWithIdentifier:identifier sender:nil];
    }
}


-(void) popBottomPanelContentStack
{
    if(self.transitioning)return;

    if(panelContentIdentifierStack.size())
    {
       
        NSString* targetIdentifier = panelContentIdentifierStack.top();
        panelContentIdentifierStack.pop();
        currentPanelIdentifier = targetIdentifier;
        [self swapPanelContentWithIdentifier:targetIdentifier];
    }
}


-(void) pushBottomPanelContentStack : (NSString*)identifier
{
    if(self.transitioning)return;
    panelContentIdentifierStack.push(currentPanelIdentifier);
    currentPanelIdentifier = identifier;
    [self swapPanelContentWithIdentifier:currentPanelIdentifier];
}


//switch the contents of the bottom panel
- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    self.transitioning = true;
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:.250 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        self.transitioning = false;
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.childViewControllers.count > 0)
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


@end
