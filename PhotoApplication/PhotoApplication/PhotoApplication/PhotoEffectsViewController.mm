//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoEffectsViewController.m
//

#import "PhotoEffectsViewController.h"
#import "PhotoApplicationOpenGL.h"
#import "PhotoApplication.h"


inline void processPhoto(unsigned int effectIndex)
{
    processForeground(effectIndex);
}


@interface PhotoEffectsViewController ()

@end

@implementation PhotoEffectsViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!isIpad())
    {
        [_effectsScroller setFrame:CGRectMake(5, 46, 300, 110)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    if(self.effectsScroller)
    {
        [self.effectsScroller setContentSize:CGSizeMake(600, 225)];//225
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appState.effects.size();
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_effectsScroller flashScrollIndicators];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(indexPath.row == decoratorState.currentPhotoFilterImage)
    {
        [cell setBackgroundColor: [UIColor whiteColor] ];
    }
    else
    {
        [cell setBackgroundColor: [UIColor clearColor] ];
    }
    
    UIButton *recipeImageView = (UIButton *)[cell viewWithTag:100];
    UIImageView* previewImageView = (UIImageView*)[cell viewWithTag:102];
    UILabel *effectLabel = (UILabel *)[cell viewWithTag:101];
    
    const char* textcstr = appState.effects[indexPath.row].effectName.c_str();
    NSString* textNSString = [NSString stringWithFormat:@"%s", textcstr];
    
    [effectLabel setText: textNSString];
    
    [recipeImageView  addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* effectPreview = nil;
    
    
    
    if(!appState.effects[indexPath.row].effectPreview)
    {
        effectPreview = [UIImage imageNamed:@"effectsPreview.jpg"]; ///\todo
        
        effectPreview = appState.effects[indexPath.row].effectPreview = toUIImage(appState.effects[indexPath.row].effectFunction(SystemImageIOS(effectPreview)));
    }
    else
    {
        effectPreview = appState.effects[indexPath.row].effectPreview;
    }
    
    previewImageView.image = effectPreview;
    
    //[recipeImageView setBackgroundImage:effectPreview forState:UIControlStateNormal];
    
    return cell;
}


- (IBAction)myClickEvent:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: self.effectsScroller];
    
    NSIndexPath *indexPath = [self.effectsScroller indexPathForItemAtPoint: currentTouchPosition];
    
    [[_effectsScroller cellForItemAtIndexPath: [NSIndexPath indexPathForRow:decoratorState.currentPhotoFilterImage inSection:0]] setBackgroundColor: [UIColor clearColor] ];
    
    decoratorState.currentPhotoFilterImage = indexPath.row;
    
    [[_effectsScroller cellForItemAtIndexPath:indexPath] setBackgroundColor: [UIColor whiteColor] ];
    
    processPhoto(indexPath.row);
    
    //renderer->initializeLetterboxedTexture();
    //renderer->renderPreview();
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
