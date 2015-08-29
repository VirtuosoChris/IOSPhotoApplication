//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  CaptionViewController.m
//

#import "CaptionViewController.h"
#include <iostream>
#import "AppDelegate.h"
#include <iosHelpers.h>


//#import <QuartzCore/QuartzCore.h>

@interface CaptionViewController ()

@end

@implementation CaptionViewController

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(self.textBox.scrollEnabled)
    {
        [self.textBox flashScrollIndicators];
    }
    
    [self.textBox becomeFirstResponder];
    
    [self.textBox setText: appState.photoCaption];
    
    _characterCounter.text = [NSString stringWithFormat:@"Characters Remaining %lu", MAX_CAPTION_CHARS-appState.photoCaption.length];
}


static bool bannerIsVisible=true;
static bool allowAds = true;
static CGRect rect;

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


- (BOOL)prefersStatusBarHidden { return YES; }


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if((appState.photoCaption.length ==0) || [appState.photoCaption isEqualToString : (NSString*)defaultPhotoCaption])
    {
        self.textBox.selectedRange = NSMakeRange(0, 0);
    }
    else
    {
        unsigned long beginRange = appState.photoCaption.length - defaultPhotoCaption.length;
        
        if(beginRange >0)
        {
            NSRange substrRange = NSMakeRange(beginRange,
                                             defaultPhotoCaption.length);
            if([ [appState.photoCaption substringWithRange:substrRange] isEqualToString: (NSString*)defaultPhotoCaption])
            {
                self.textBox.selectedRange = NSMakeRange(beginRange, 0);
                return;
            }
        }
        
        if(beginRange >-1)
        {
            NSRange substrRange = NSMakeRange(beginRange+1,
                                              defaultPhotoCaption.length-1);
            
            NSRange substrRange2 = NSMakeRange(1,
                                              defaultPhotoCaption.length-1);
            
            NSString* subPhotoCaption = [defaultPhotoCaption substringWithRange: substrRange2];
            
            if([ [appState.photoCaption substringWithRange:substrRange] isEqualToString: subPhotoCaption])
            {
                self.textBox.selectedRange = NSMakeRange(beginRange+1, 0);
                return;
            }
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    static bool onceAd = false;
    
    //_textBox.layer.cornerRadius = 6.0f;
    //_textBox.layer.masksToBounds = YES;
    
    UIImage* resized = resizedCopy([UIImage imageNamed:@"CaptionBox.jpg"] , CGRectGetWidth(_textBox.frame), CGRectGetHeight(_textBox.frame));
    
    _textBox.backgroundColor = [UIColor colorWithPatternImage: resized];
    
    if(!onceAd)
    {
        rect = _adBanner.frame;
        onceAd=true;
    }
    
    [self bannerView:_adBanner didFailToReceiveAdWithError:nil];
    

    self.textBox.delegate= self;
    
    _characterCounter.text = [NSString stringWithFormat:@"Characters Remaining %u", MAX_CAPTION_CHARS - appState.photoCaption.length];
    
    if(!isIpad())
    {
        self.titleLabel.font = [UIFont fontWithName:@"BIG JOHN" size:18];
        self.textBox.font =  [UIFont fontWithName:@"Colaborate-Light" size:16];
        
        _characterCounter.font = [UIFont fontWithName:@"BIG JOHN" size:16];
    
        if([UIScreen mainScreen].bounds.size.height <= 480.0f) //iPhone 4s and earlier path
        {
            //self.explanation1.font = [UIFont fontWithName:@"Colaborate-Light" size:12];
            //self.explanation2.font = [UIFont fontWithName:@"Colaborate-Light" size:12];
            self.exampleButton.titleLabel.font =[UIFont fontWithName:@"BIG JOHN" size:16];
        }
        else // iPhone 5 and up path
        {
            //self.explanation1.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
            //self.explanation2.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
            
            self.exampleButton.titleLabel.font =[UIFont fontWithName:@"BIG JOHN" size:16];
        }
    }
    else // ipad
    {
        self.titleLabel.font = [UIFont fontWithName:@"BIG JOHN" size:35];
        self.textBox.font =  [UIFont fontWithName:@"Colaborate-Light" size:32];
        
        //self.explanation1.font = [UIFont fontWithName:@"Colaborate-Light" size:20];
        //self.explanation2.font = [UIFont fontWithName:@"Colaborate-Light" size:20];
        self.exampleButton.titleLabel.font =[UIFont fontWithName:@"BIG JOHN" size:30];
        _characterCounter.font = [UIFont fontWithName:@"BIG JOHN" size:18];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textBox becomeFirstResponder];
    
    [self.textBox setText:appState.photoCaption];
    
     _characterCounter.text = [NSString stringWithFormat:@"Characters Remaining %u", MAX_CAPTION_CHARS-appState.photoCaption.length];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    appState.photoCaption = self.textBox.text;
    [self.textBox resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        appState.photoCaption = self.textBox.text;
        
        [self.textBox resignFirstResponder];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    //This accounts for users cutting text, or deleting strings longer than a single character (ie if they select and then hit backspace), or highlighting a range and pasting strings shorter or longer than it.
    return self.textBox.text.length + (text.length - range.length) <= MAX_CAPTION_CHARS;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _characterCounter.text = [NSString stringWithFormat:@"Characters Remaining %u", MAX_CAPTION_CHARS-self.textBox.text.length];
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.textBox resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
