//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoEditingViewController.h
//  PhotoApplication Photo Extension
//

#import <UIKit/UIKit.h>
#include <vector>
#import <SystemImage.h>
#import "PhotoApplicationAppState.h"

@interface PhotoEditingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UILabel *colorBackgroundLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *colorScroller;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *tiledButton;
@property (weak, nonatomic) IBOutlet UIButton *launchButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

//@property float borderScale;
//@property UIColor* currentColor;
@property UIImage* letterboxedImage;
@property UIImage* backgroundProcessed;
//@property UIImage* myImage;
@property std::vector<UIColor*> colors;
@property unsigned int selectedColor;
//@property UIImage* backgroundImageRaw;
@property ImageProcessingResult backgroundImageTiled;
//@property float scaleParameter;

@end
