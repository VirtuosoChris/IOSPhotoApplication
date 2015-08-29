//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  HelpViewController.m
//

#import "HelpViewController.h"
#include <iostream>
#include <iosHelpers.h>
#include <iAd/iAd.h>


@interface HelpViewController ()
@end

@implementation HelpViewController

static bool bannerIsVisible=true;
static bool allowAds = true;

static CGRect rect;


- (IBAction)ratePressed:(id)sender
{
    NSString* str = @"itms-apps://itunes.apple.com/app/id898616216";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)getPhotoApplication:(id)sender
{
    NSString* str = @"itms-apps://itunes.apple.com/app/id898616216";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)rateFree:(id)sender
{
    NSString* str = @"itms-apps://itunes.apple.com/app/id918899129";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    static bool once = false;
    
    if(!once)
    {
        rect = banner.frame;
        once=true;
    }
    
    BOOL shouldExecuteAction = allowAds; // your app implements this method

    if (!willLeave && shouldExecuteAction)
    {
    }
    
    return shouldExecuteAction;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = rect;
        [UIView commitAnimations];
        bannerIsVisible = true;
    }
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(rect, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = false;
    }
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


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
	
    static bool onceAd = false;
    
    if(!onceAd){
        rect = _adBanner.frame;
        onceAd=true;
    }
    
    [self bannerView:_adBanner didFailToReceiveAdWithError:nil];
}


- (IBAction)logoTouched:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mycompany.com"]];
}


- (BOOL)prefersStatusBarHidden { return YES; }


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.logoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

    if(_textView)
    {
        _textView.contentInset = UIEdgeInsetsMake(-60,0,0,0);
    }
    
    if(!isIpad())
    {
        self.textView.font =  [UIFont fontWithName:@"Colaborate-Regular" size:16];
        self.bylineLabel.font =  [UIFont fontWithName:@"Colaborate-Light" size:17];
        self.tutorialButton.titleLabel.font = [UIFont fontWithName:@"Colaborate-Regular" size:21];
        self.creditsButton.titleLabel.font =[UIFont fontWithName:@"Colaborate-Regular" size:21];
        ///\todo check in ms free and 3.5 in layout
        self.rateLabel.titleLabel.font =  [UIFont fontWithName:@"Colaborate-Regular" size:21];
        
        self.getPhotoApplicationButton.titleLabel.font =  [UIFont fontWithName:@"Colaborate-Regular" size:21];
    }
    else
    {
        self.textView.font =  [UIFont fontWithName:@"Colaborate-Regular" size:29];
        self.bylineLabel.font =  [UIFont fontWithName:@"Colaborate-Light" size:28];
        self.tutorialButton.titleLabel.font = [UIFont fontWithName:@"Colaborate-Regular" size:45];
        self.rateLabel.titleLabel.font =  [UIFont fontWithName:@"Colaborate-Regular" size:45];
        self.getPhotoApplicationButton.titleLabel.font =  [UIFont fontWithName:@"Colaborate-Regular" size:45];
        self.creditsButton.titleLabel.font =[UIFont fontWithName:@"Colaborate-Regular" size:45];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
