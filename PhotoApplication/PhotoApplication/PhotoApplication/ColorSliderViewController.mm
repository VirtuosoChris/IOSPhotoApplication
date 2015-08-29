//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

///
///@file ColorSliderViewController.m
///@brief solid color bottom panel view controller
//


#import "ColorSliderViewController.h"
#import "AppDelegate.h"
#include <SystemImage.h>
#include <iosHelpers.h>

@interface ColorSliderViewController ()

@end

@implementation ColorSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}


-(void)viewDidLayoutSubviews
{
    if(self.scrollView)
    {
        [self.scrollView setContentSize:CGSizeMake(300, 220)];//225
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appState.setBackgroundImagePreview(nil);
 
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    self.redSlider.value = components[0];
    self.greenSlider.value = components[1];
    self.blueSlider.value = components[2];
    
    self.borderSlider.value = appState.borderScale;
    
    self.borderSlider.minimumValue = 0.0f;
    self.borderSlider.maximumValue = 1.0f;
}


-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.scrollView flashScrollIndicators];
    [self.collectionViewColors flashScrollIndicators];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    appState.colorSliderController = self;
    
    _labelRed.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
    _labelGreen.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
    _labelBlue.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
    _labelBorder.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appState.colors.size();
}


- (IBAction)myClickEvent:(id)sender event:(id)event
{
    //NSSet *touches = [event touchesForView:sender];
    
    //UITouch *touch = [touches anyObject]; //was alltouches
    
    //CGPoint currentTouchPosition = [touch locationInView: self.collectionViewColors];

    CGPoint currentTouchPosition = [sender convertPoint:CGPointZero toView:self.collectionViewColors];
    
    NSIndexPath *indexPath = [self.collectionViewColors indexPathForItemAtPoint: currentTouchPosition];
    
    if(!indexPath)
    {
        return;
        //std::cout<<"INVALID INDEX PATH"<<std::endl;
    }
    
    appState.currentColor = appState.colors[indexPath.row];
    
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    self.redSlider.value = components[0];
    self.greenSlider.value = components[1];
    self.blueSlider.value = components[2];
    
    appState.setBackgroundImagePreview(nil);
}


-(void) resetColorSliders
{
    appState.currentColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    self.redSlider.value = components[0];
    self.greenSlider.value = components[1];
    self.blueSlider.value = components[2];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIButton *myButton = (UIButton *)[cell viewWithTag:100];
    
    [myButton  addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    unsigned char imgWidth=1;
    
    unsigned char* dataIn= (new unsigned char[imgWidth*imgWidth*4]);
    
    UIColor* col = appState.colors[indexPath.row];
    
    const CGFloat *components = CGColorGetComponents(col.CGColor);
    
    dataIn[0] = 255*components[0];
    dataIn[1] = 255*components[1];
    dataIn[2] = 255*components[2];
    dataIn[3] = 255u;

    SystemImage sysImg(dataIn, imgWidth,imgWidth);
    
    UIImage* colorSquare = toUIImage(sysImg);
    
    delete[] dataIn;
    
    [myButton setBackgroundImage:colorSquare forState:UIControlStateNormal];
    
    return cell;
}


- (IBAction)RedSliderMoved:(id)sender
{
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    appState.currentColor = [UIColor colorWithRed:self.redSlider.value green:components[1] blue:components[2] alpha:1.0f];
    
    appState.setBackgroundImagePreview(nil);
}


- (IBAction)GreenSliderMoved:(id)sender
{
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    appState.currentColor = [UIColor colorWithRed: components[0] green:self.greenSlider.value blue:components[2] alpha:1.0f];
    
    appState.setBackgroundImagePreview(nil);
}


- (IBAction)borderSliderMoved:(id)sender
{
    appState.borderScale = self.borderSlider.value;
    updateConstraintsPreview();
}


- (IBAction)BlueSliderMoved:(id)sender
{
    const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
    
    appState.currentColor = [UIColor colorWithRed: components[0] green:components[1] blue:self.blueSlider.value alpha:1.0f];
    
    appState.setBackgroundImagePreview(nil);
}

@end
