//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  CreditsViewController.m
//

#import "CreditsViewController.h"
#include "iosHelpers.h"


@interface CreditsViewController ()

@end

@implementation CreditsViewController

static bool bannerIsVisible=true;
static bool allowAds = true;

static CGRect rect;

- (BOOL)prefersStatusBarHidden { return YES; }


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    int scale = isIpad() ? 2 : 1;
    UIFont* font = [UIFont fontWithName:@"Colaborate-regular" size:18 * scale];
    UIFont* fontbig = [UIFont fontWithName:@"Colaborate-regular" size:24*scale];
    UIFont* fontsm = [UIFont fontWithName:@"Colaborate-regular" size:16*scale];
    
    _creditsTitle.font =[UIFont fontWithName:@"Colaborate-regular" size:32*scale];
    _companyTitle.font = _thirdPartyTitle.font = fontbig;
    
    _chris.font = fontsm;
    _desProg.font = font;
    _desTest.font = font;
    _jav.font = fontsm;
    _ui.font = font;
    _sah.font = fontsm;
    // Do any additional setup after loading the view.
    
    static bool onceAd = false;
    
    if(!onceAd){
        rect = _adBanner.frame;
        onceAd=true;
    }
    
    [self bannerView:_adBanner didFailToReceiveAdWithError:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
