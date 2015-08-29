//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  BackgroundPackViewController.mm
//

#import "BackgroundPackViewController.h"
#import "PhotoApplication.h"
#import "AppDelegate.h"
#import <iosHelpers.h>
#import "PhotoApplicationButton.h"


@interface BackgroundPackViewController ()

@end

@implementation BackgroundPackViewController

static NSString * const reuseIdentifier = @"Cell";

UICollectionView* myCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//#warning Incomplete method implementation -- Return the number of items in the section
    return NUM_BACKGROUND_PACKS;
}

- (IBAction)myClickEvent:(id)sender event:(id)event
{
    /*NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    */
    
    CGPoint currentTouchPosition = [sender convertPoint:CGPointZero toView:self.collectionView];

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    if(!indexPath)return;
    
    appState.numBackgroundsInSelectedPack = backgroundPackSize[indexPath.row];
    appState.selectedBackgroundPackPaths = backgroundPackPointers[indexPath.row];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    //UILabel* backgroundLabel = (UILabel*)[cell viewWithTag: 99];
    
    //[backgroundLabel setHighlighted:NO];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString* bStr = (NSString*)backgroundPacks[indexPath.row];
    UIImage* bImg = [UIImage imageNamed:(NSString*)backgroundPackPreviewImage[indexPath.row]];
    UIImage* bImg2 = [UIImage imageNamed:(NSString*)backgroundPackPreviewImage2[indexPath.row]];
    
    UIButton *backgroundButton = (UIButton *)[cell viewWithTag:100]; //button to click
    UIImageView* backgroundImageView = (UIImageView*)[cell viewWithTag:101]; //preview picture 1
    UIImageView* backgroundImageView2 = (UIImageView*)[cell viewWithTag:102]; //preview picture 2
    
    UILabel* backgroundLabel = (UILabel*)[cell viewWithTag: 99];
    backgroundLabel.highlightedTextColor = [UIColor whiteColor];
    
    ((PhotoApplicationButton*)backgroundButton).backgroundLabel = backgroundLabel;
    
    if(!isIpad())
    {
        backgroundLabel.font = [UIFont fontWithName:@"Colaborate-Bold" size:22];
    }
    else
    {
        backgroundLabel.font = [UIFont fontWithName:@"Colaborate-Bold" size:50];
    }
    
    [backgroundButton addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    /*[backgroundButton addTarget:self action:@selector(touchDownEvent:event:) forControlEvents:UIControlEventTouchDown];
    
    [backgroundButton addTarget:self action:@selector(touchCancelEvent:event:) forControlEvents:UIControlEventTouchCancel];
    
    [backgroundButton addTarget:self action:@selector(touchCancelEvent:event:) forControlEvents:UIControlEventTouchUpOutside];
    */
    
    
    
    
    backgroundImageView.image = bImg;
    backgroundImageView2.image = bImg2;
    backgroundLabel.text = bStr;
    
    //backgroundLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    //backgroundLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
