//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  TutorialViewController.h
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *xButtonBck;
@property (strong, nonatomic) IBOutlet UIImageView *slideBkr;
@property (strong, nonatomic) IBOutlet UIImageView *leftBck;
@property (strong, nonatomic) IBOutlet UILabel *slideLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightBck;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *escButton;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property NSString* platformString;
@property NSString* const* fileArray;
@property unsigned int currentSlide;
@property NSArray *imageViews;

@property float alpha;
@property float defAlphaButtonBck;
@property float defAlphaSlideBkr;
@property float defAlphaLeftBck;
@property float defAlphaSlideLabel;
@property float defAlphaRightBck;
@property float defAlphaPrevButton;
@property float defAlphaEscButton;
@property float defAlphaNextButton;

@property CADisplayLink* displayLink;
@property NSTimer* myTimer;
@property bool startDL;
@property CFTimeInterval firstTime;




@end
