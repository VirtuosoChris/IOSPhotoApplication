//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  SocialExampleViewController.m
//

#import "SocialExampleViewController.h"
#import "iosHelpers.h"

@interface SocialExampleViewController ()
@end


@implementation SocialExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (BOOL)prefersStatusBarHidden { return YES; }


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* platformString = nil;
    
    if(isIpad())
    {
        platformString = @"ipad";
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height <= 480.0f)
        {
            platformString = @"iphone4s";
        }
        else
        {
            platformString = @"iphone5";
        }
    }
    
    NSString* imageFile = [ NSString stringWithFormat:@"TutorialJPG/%@/Example.jpg",platformString ];
    _imageView.image = [UIImage imageNamed:imageFile];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)escPressed:(id)sender
{
    if(self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
