//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  CreditsViewController.h
//

#import <UIKit/UIKit.h>
#include <iAd/iAd.h>

@interface CreditsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *desProg;
@property (weak, nonatomic) IBOutlet UILabel *chris;
@property (weak, nonatomic) IBOutlet UILabel *desTest;
@property (weak, nonatomic) IBOutlet UILabel *jav;
@property (weak, nonatomic) IBOutlet UILabel *ui;
@property (weak, nonatomic) IBOutlet UILabel *sah;
@property (weak, nonatomic) IBOutlet UILabel *creditsTitle;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UILabel *thirdPartyTitle;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

@end
