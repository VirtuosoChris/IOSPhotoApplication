//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorViewController.h
//

#import <UIKit/UIKit.h>
#import "DecoratorPanelViewController.h"
#import "GLViewIOS.h"
#import <iAd/iAd.h>

@interface DecoratorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backIconBUTTON;
@property (weak, nonatomic) IBOutlet UIButton *optionsIconBUTTON;
@property (weak, nonatomic) IBOutlet UIButton *letterboxIconBUTTON;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property DecoratorPanelViewController* bottomPanelViewController;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *letterboxButton;
@property (strong, nonatomic) IBOutlet GLViewIOS *glView;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIImageView *backIconView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsIconView;
@property (weak, nonatomic) IBOutlet UIImageView *letterboxIconView;
-(void) decoratorPanelUpdated;
@end
