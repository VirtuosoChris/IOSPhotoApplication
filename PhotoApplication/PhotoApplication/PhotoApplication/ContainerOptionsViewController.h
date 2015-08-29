//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  ContainerOptionsViewController.h
//

#import <UIKit/UIKit.h>

#define SegueIdentifierFirst @"embedColor"
#define SegueIdentifierSecond @"embedImage"

@interface ContainerOptionsViewController : UIViewController
- (void)swapToColorVC;
- (void)swapToImageVC;
@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property bool transitioning;
@end
