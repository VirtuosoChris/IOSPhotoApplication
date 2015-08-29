//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorDrawingHomeViewController.h
//

#import <UIKit/UIKit.h>

@interface DecoratorDrawingHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *colorBar;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *penLabel;
@property (weak, nonatomic) IBOutlet UIButton *eraseButton;
@property (weak, nonatomic) IBOutlet UIButton *eraserToggleButton;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIButton *currentColorSquare;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentColorButton;
@property (weak, nonatomic) IBOutlet UISlider *penSlider;
@property (weak, nonatomic) IBOutlet UIImageView *colorSquareIpad;
@property (weak, nonatomic) IBOutlet UILabel *currentColorLabelIpad;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *penColorLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *colorScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

