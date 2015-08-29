//
//  BackgroundPickerViewController.m
//

#import "BackgroundPickerViewController.h"
#import "BackgroundOptionsViewController.h"
#import "appDelegate.h"
#include <iostream>
#include <iosHelpers.h>
#include <SystemImageImplIOS.h>




static NSString * const reuseIdentifier = @"Cell";

@interface BackgroundPickerViewController ()
@end


@implementation BackgroundPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
    }
    
    return self;
}


- (BOOL)prefersStatusBarHidden { return YES; }


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appState.numBackgroundsInSelectedPack;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (IBAction)myClickEvent:(id)sender event:(id)event
{
   /* NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    */
    
    CGPoint currentTouchPosition = [sender convertPoint:CGPointZero toView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    if(!indexPath)return;
    
    //we're resetting the background effect state. 
    decoratorState.currentPhotoFilterBackground=0;
    decoratorState.seamlessEnabled=false;
    
    appState.backgroundImageRaw = [UIImage imageNamed:appState.selectedBackgroundPackPaths[indexPath.row]];

    appState.backgroundImageTiled = affineTile(SystemImageIOS(appState.backgroundImageRaw));
    
    float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
    
    SystemImage cropped = crop(appState.backgroundImageTiled, 0, 0, squareDim, squareDim);

    appState.setBackgroundImage(toUIImage(cropped));
    
    bool noBorder = (appState.borderScale == 0.0f);
    bool isSquare = imageIsSquare();
    
    //reset the sliders whether or not the image is square, when we load a new background
    [appState.imageSliderController resetSliders];
    
    if(noBorder && isSquare)
    {
        appState.borderScale = 0.50f;
        appState.imageSliderController.borderSlider.value = appState.borderScale;
        updateConstraintsPreview();
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* bImg = [UIImage imageNamed:appState.selectedBackgroundPackPaths[indexPath.row]];
    
    static NSString *identifier = @"Cell";
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
    UIButton *backgroundButton = (UIButton *)[cell viewWithTag:100];
        
    UIImageView* backgroundImageView = (UIImageView*)[cell viewWithTag:101];
    
    [backgroundButton addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    backgroundImageView.image = bImg;
    
    return cell;
}

@end
