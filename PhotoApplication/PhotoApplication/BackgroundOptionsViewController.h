//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  BackgroundOptionsViewController.h
//

#import <UIKit/UIKit.h>
#include <ActionSheet.h>

@interface BackgroundOptionsViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundPreviewIPAD;
@property (strong, nonatomic) IBOutlet UISlider *borderSlider;
@property (strong, nonatomic) IBOutlet UIButton *chooseBackgroundButton;
@property (strong, nonatomic) IBOutlet UISlider *translateXSlider;
@property (strong, nonatomic) IBOutlet UISlider *translateYSlider;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollPane;
@property (strong, nonatomic) IBOutlet UISlider *scaleBackgroundSlider;
@property ActionSheet backgroundGetterActionSheet;
@property (strong, nonatomic) IBOutlet UILabel *labelBorder;
@property (strong, nonatomic) IBOutlet UILabel *labelTranslateX;
@property (strong, nonatomic) IBOutlet UILabel *labelTranslateY;
@property (strong, nonatomic) IBOutlet UILabel *labelZoom;
@property (strong, nonatomic) IBOutlet UILabel *labelSectionTitle; //background transformations, ipad
@property (strong, nonatomic) IBOutlet UILabel *currentBackgroundLabelIPAD;

-(void) resetSliders;
-(void) updateSwatch;

@end
