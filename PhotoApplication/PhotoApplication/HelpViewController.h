//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  HelpViewController.h
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface HelpViewController : UIViewController <ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;
@property (strong, nonatomic) IBOutlet UIButton *logoButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bylineLabel;
@property (strong, nonatomic) IBOutlet UIButton *rateLabel;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIButton *getPhotoApplicationButton;
@property (strong, nonatomic) IBOutlet UIButton *tutorialButton;
@end
