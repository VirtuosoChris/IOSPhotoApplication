//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  MainViewController.h
//

#import <UIKit/UIKit.h>

#include <ActionSheet.h>
#import "ContainerOptionsViewController.h"

#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *imageIconBUTTON;
@property (weak, nonatomic) IBOutlet UIButton *captionIconBUTTON;
@property (weak, nonatomic) IBOutlet UIButton *decorateIconBUTTON;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toTopConstraint;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *captionButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageIconView;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *previewButton;
@property (strong, nonatomic) IBOutlet UIButton *backgroundSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *decorateButton;
@property (weak, nonatomic) IBOutlet UIImageView *decoratorImageView;
@property UIDocumentInteractionController* dic;
@property ActionSheet actionSheetSocial;
@property ActionSheet actionSheetGet;
@property ActionSheet frameActionSheet;
@property    ContainerOptionsViewController * childViewController;
@end
