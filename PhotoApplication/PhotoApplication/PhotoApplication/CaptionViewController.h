//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  CaptionViewController.h
//

#import <UIKit/UIKit.h>
#import <iad/iAd.h>

@interface CaptionViewController : UIViewController <UITextViewDelegate,ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textBox;
@property (strong, nonatomic) IBOutlet UILabel *characterCounter;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;
@property (strong, nonatomic) IBOutlet UILabel *explanation1;
@property (strong, nonatomic) IBOutlet UILabel *explanation2;
@property (strong, nonatomic) IBOutlet UIButton *exampleButton;
@end
