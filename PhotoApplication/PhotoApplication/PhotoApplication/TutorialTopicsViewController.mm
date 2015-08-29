//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  TutorialTopicsViewController.m
//

#import "TutorialTopicsViewController.h"
#include "TutorialCollectionHeaderReusableView.h"
#import "PhotoApplication.h"
#import "PhotoApplicationConstants.h"

//#define NUM_TUTORIALS
NSString* topicNames[NUM_TUTORIALS] =
{
    @"Getting Started",
    @"Color Borders",
    @"Image Borders",
    @"Advanced Borders",
    @"Decorating Overview",
    @"Drawing"
};


@interface TutorialTopicsViewController ()

@end

@implementation TutorialTopicsViewController

static NSString * const reuseIdentifier = @"Cell";

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_topicsLabel.font = [UIFont fontWithName:@"BIG JOHN" size:18];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
  //  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return NUM_TUTORIALS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIButton *topicButton = (UIButton *)[cell viewWithTag:100];
    
    [topicButton setTitle: topicNames[indexPath.row] forState: UIControlStateNormal];
    
    if(!isIpad())
    {
        topicButton.titleLabel.font = [UIFont fontWithName:@"Colaborate-regular" size:30.0];
    }
    else
    {
        topicButton.titleLabel.font = [UIFont fontWithName:@"Colaborate-regular" size:60.0];
    }
    //setTitle forState: UIControlStateNormal = ;
    
    [topicButton addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Configure the cell
    
    return cell;
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
    
    if(isIpad())
    {
        appState.selectedTutorialSlidePaths = tutorialPathPointersIpad[indexPath.row];
        appState.numSlidesInTutorial = tutorialSizeiPad[indexPath.row];
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height <= 480.0f)
        {
            appState.selectedTutorialSlidePaths = tutorialPathPointersIphone4[indexPath.row];
            appState.numSlidesInTutorial = tutorialSizeiPhone4[indexPath.row];
        }
        else
        {
            appState.selectedTutorialSlidePaths = tutorialPathPointersIphone5[indexPath.row];
            appState.numSlidesInTutorial = tutorialSizeiPhone6[indexPath.row];
        }
    }
}



- (IBAction)backPressed:(id)sender event:(id)event
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        TutorialCollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UIButton *backButton = (UIButton *)[headerView viewWithTag:101];
       
        UILabel *topics = (UILabel*)[headerView viewWithTag:100];
        
        if(!isIpad())
        {
            topics.font = [UIFont fontWithName:@"Colaborate-medium" size:30.0];
        }
        else
        {
            topics.font = [UIFont fontWithName:@"Colaborate-medium" size:60.0];
        }
        
        [backButton addTarget:self action:@selector(backPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        
        reusableview = headerView;
    }
    
    /* if (kind == UICollectionElementKindSectionFooter) {
     UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
     
     reusableview = footerview;
     }
     */
    return reusableview;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
