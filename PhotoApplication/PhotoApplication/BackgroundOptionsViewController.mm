//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  BackgroundOptionsViewController.m
//

#import "BackgroundOptionsViewController.h"
#import "appDelegate.h"
#include <iosHelpers.h>
#include <GetPhoto.h>
#include <SystemImageImplIos.h>
#import <PopupMessage.h>


///@brief loaded picture background downsample to MAX_BACKGROUND_DIM pixels on a side maximum, reset sliders, create tilable image
void pictureLoadedLambda(SystemImage img)
{
    const float MAX_BACKGROUND_DIM = 768;
    
    [appState.imageSliderController resetSliders];
    
    UIImage* imgU= nil;
    
    float maxDim = std::max(img.getWidth(), img.getHeight());
    
    if(maxDim <= MAX_BACKGROUND_DIM)
    {
        imgU = toUIImage(img);
    }
    else
    {
        float downscale =  MAX_BACKGROUND_DIM / maxDim;
        imgU = resizedCopyGauss(img, downscale);
    }
    
    
    decoratorState.seamlessEnabled=false;
    decoratorState.currentPhotoFilterBackground=0;
    
    appState.backgroundImageRaw = imgU;
    appState.backgroundImageTiled = affineTile(SystemImageIOS(appState.backgroundImageRaw));
    
    
    float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
    
    SystemImage cropped = crop(appState.backgroundImageTiled, 0, 0, squareDim, squareDim);;
    appState.setBackgroundImage(toUIImage(cropped));
                                
    [appState.imageSliderController updateSwatch];
    
    bool noBorder = (appState.borderScale == 0.0f);
    bool isSquare = imageIsSquare();
    
    if(noBorder && isSquare)
    {
        appState.borderScale = 0.50f;
        appState.imageSliderController.borderSlider.value = appState.borderScale;
        updateConstraintsPreview();
    }
};


@interface BackgroundOptionsViewController ()

@end

@implementation BackgroundOptionsViewController


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollPane flashScrollIndicators];
}


-(void) transformImage
{
    if(appState.backgroundImageRaw)
    {
        float tx =  (appState.translateParameterX * appState.backgroundImageRaw.size.width) * appState.scaleParameter;
        float ty = (appState.translateParameterY * appState.backgroundImageRaw.size.height) * appState.scaleParameter;
   
        ImageProcessingResult backgroundImageTiled2 = affineTransform(appState.backgroundImageTiled, appState.scaleParameter, 0.0f, 0.0f,appState.scaleParameter, tx, ty);
        
        float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
        
        //SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
        SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
        appState.setBackgroundImage(toUIImage(cropped));
    }
    else
    {
        appState.setBackgroundImage(nil);
    }
}


- (IBAction)translateXSliderMoved:(id)sender
{
    appState.translateParameterX = _translateXSlider.value;
    [self transformImage];
}


- (IBAction)translateYSliderMoved:(id)sender
{
   // std::cout<<"SLIDER MOVED "<<(translateParameterY-_translateYSlider.value)<<std::endl;
    appState.translateParameterY = _translateYSlider.value;
    //translateParameterY -= fmod(translateParameterY, .1);
    
    [self transformImage];
}


- (IBAction)backgroundZoomSliderMoved:(id)sender
{
    appState.scaleParameter = self.scaleBackgroundSlider.value;
    [self transformImage];
}


- (IBAction)chooseBackgroundButtonPressed:(id)sender {
    
    _backgroundGetterActionSheet.display();
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}


- (IBAction)borderSliderMoved:(id)sender
{
    appState.borderScale = self.borderSlider.value;
    updateConstraintsPreview();
}


-(void)viewDidLayoutSubviews
{
    if(self.scrollPane)
    {
        [self.scrollPane setContentSize:CGSizeMake(300, 220)];
    }
}


-(void) updateSwatch
{
    if(isIpad())
    {
        
        if(appState.backgroundImageRaw)
        {
            self.backgroundPreviewIPAD.image = appState.backgroundImageRaw;
            [self.chooseBackgroundButton setTitle:@"" forState: UIControlStateNormal];
            appState.setBackgroundImagePreview(appState.backgroundProcessed);
            self.chooseBackgroundButton.backgroundColor = [UIColor blackColor];
        }
        else
        {
            appState.setBackgroundImagePreview(nil);
            self.backgroundPreviewIPAD.image = [UIImage imageNamed:@"Choose-Background.jpg"];
            //[self.chooseBackgroundButton setTitle:@"Choose" forState: UIControlStateNormal];
            self.chooseBackgroundButton.backgroundColor = [UIColor blackColor];
        }
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.translateXSlider.value = appState.translateParameterX;
    self.translateYSlider.value = appState.translateParameterY;
    self.scaleBackgroundSlider.value = appState.scaleParameter;

    appState.setBackgroundImagePreview(appState.backgroundProcessed);
  
    [self updateSwatch];
    
    updateConstraintsPreview();
    
    auto imageLaunchOptions2 = appState.imageLaunchOptions; //copy for testing below
    appState.imageLaunchOptions = NONE;//reset the launch options for the view controller

    switch(imageLaunchOptions2)
    {
        case NONE:
        {
            break;
        }
        case BUILT_IN_BACKGROUND:
        {
            //[self resetSliders];
            
            //UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BackgroundPickerViewController"];
            
            /*UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BackgroundNavigation"];
            
            [self presentViewController:vc animated:YES completion:nil];*/
            
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BackgroundPackController"];
            
            [self.navigationController pushViewController: vc animated:YES];             

            break;
        }
        case LIBRARY_BACKGROUND:
        {
            getPhotoFromLibrary(pictureLoadedLambda);
        
            break;
        }
        case CAMERA_BACKGROUND:
        {
            getPhotoFromCamera(pictureLoadedLambda);
            
            break;
        }
            
        case CURRENT_PHOTO_BACKGROUND:
        {
            generateLetterboxed();
            pictureLoadedLambda(SystemImageIOS(appState.letterboxedImage));
            
            appState.scaleParameter = minImageBackgroundScale;
            appState.imageSliderController.scaleBackgroundSlider.value = appState.scaleParameter;
            
            [self transformImage];
            
            break;
        }
        default:throw std::runtime_error("Out of bounds enum for imageLaunchOptions");break;
    }
}


-(void) resetSliders
{
    appState.translateParameterX = 0.0f;
    appState.translateParameterY= 0.0f;
    appState.scaleParameter = 1.0f;
    
    self.translateXSlider.value = appState.translateParameterX;
    self.translateYSlider.value = appState.translateParameterY;
    self.scaleBackgroundSlider.value = appState.scaleParameter;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    appState.imageSliderController = self;
 
    self.borderSlider.value = appState.borderScale;
    self.borderSlider.minimumValue = 0.0f;
    self.borderSlider.maximumValue = 1.0f;
    
    self.translateXSlider.minimumValue = -1.0f;
    self.translateXSlider.maximumValue=1.0f;
    self.translateXSlider.value = appState.translateParameterX;
    
    self.translateYSlider.minimumValue = -1.0f;
    self.translateYSlider.maximumValue=1.0f;
    self.translateYSlider.value = appState.translateParameterY;
    
    self.scaleBackgroundSlider.minimumValue = minImageBackgroundScale;
    self.scaleBackgroundSlider.maximumValue = maxImageBackgroundScale;
    self.scaleBackgroundSlider.value = appState.scaleParameter;

    auto builtInLambda = [self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BackgroundPackController"];
        
        [self.navigationController pushViewController: vc animated:YES];
    };
    
    auto libraryLambda = []()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        getPhotoFromLibrary(pictureLoadedLambda);
    };
    
    auto cameraLambda = []()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        getPhotoFromCamera(pictureLoadedLambda);
        
    };
    
    auto currentPictureLambda = []()
    {
        if(appState.isStartState())
        {
            popupMessage("Import a photo first!", "");
            return;
        }
        
        generateLetterboxed();

        pictureLoadedLambda(SystemImageIOS(appState.letterboxedImage));
        
        appState.scaleParameter = minImageBackgroundScale;
        appState.imageSliderController.scaleBackgroundSlider.value = appState.scaleParameter;
        [appState.imageSliderController transformImage];
    };
    
    _backgroundGetterActionSheet.title = "Get Background Image From:";
    _backgroundGetterActionSheet.push_back(ActionSheetEntry("Background Packs", builtInLambda));
    _backgroundGetterActionSheet.push_back(ActionSheetEntry("Photo Library", libraryLambda));
    _backgroundGetterActionSheet.push_back(ActionSheetEntry("Camera", cameraLambda));
    _backgroundGetterActionSheet.push_back(ActionSheetEntry("Current Picture", currentPictureLambda));
    _backgroundGetterActionSheet.push_back(ActionSheetEntry("Cancel", [](){}, CANCEL_ENTRY));
    
    updateConstraintsPreview();

    self.currentBackgroundLabelIPAD.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
    self.labelSectionTitle.font =  [UIFont fontWithName:@"Colaborate-Medium" size:24];
    self.labelBorder.font =  [UIFont fontWithName:@"Colaborate-Light" size:16];
    self.labelZoom.font =  [UIFont fontWithName:@"Colaborate-Light" size:16];
    self.labelTranslateX.font =  [UIFont fontWithName:@"Colaborate-Light" size:16];
    self.labelTranslateY.font =  [UIFont fontWithName:@"Colaborate-Light" size:16];
    self.chooseBackgroundButton.titleLabel.font =[UIFont fontWithName:@"BIG JOHN" size:20];
    
    [self updateSwatch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)touchDown:(id)sender
{
    std::cout<<"TOUCH DOWN"<<std::endl;
}


- (IBAction)upInside:(id)sender
{
    std::cout<<"TOUCH UP IN "<<std::endl;
}


- (IBAction)upOutside:(id)sender
{
    std::cout<<"TOUCH UP OUT "<<std::endl;
}

@end
