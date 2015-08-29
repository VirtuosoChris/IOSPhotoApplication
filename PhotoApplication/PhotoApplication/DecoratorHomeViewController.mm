//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorHomeViewController.m
//

#import "DecoratorHomeViewController.h"
#import "PhotoApplication.h"
#import "PopupMessage.h"
#import "PhotoApplicationOpenGL.h"

@interface DecoratorHomeViewController ()

@end

@implementation DecoratorHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UIFont* font=nil;
    if(!isIpad())
    {
        font = [UIFont fontWithName:@"Colaborate-Medium" size:24];
    }
    else
    {
        font = [UIFont fontWithName:@"Colaborate-Medium" size:38];
    }
    
    _titleText.font = [UIFont fontWithName:@"BIG JOHN" size:18];

    _moreButtonPressed.titleLabel.font = font;
    _drawingButton.titleLabel.font = font;
    _moreButtonPressed.enabled  = NO;
    _clearAllButton.titleLabel.font = font;
    _backToLetterboxButton.titleLabel.font = font;
    _effectsButton.titleLabel.font = font;
}


- (IBAction)backToLetterboxPressed:(id)sender
{
    if(appState.decoratorVC)
    {
        appState.isDecorating = false;
        [appState.decoratorVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearAllPressed:(id)sender
{
    static PopupBox box;
    box.clear();
    box.message = "This will clear all decorations from your picture.  Proceed?";
    box.title = "Clear Decorations?";
    
    auto doNothing = [](){};
    auto startOverLambda = []()
    {
        renderer->clear();
        updateRendererPreviews();
    
        //we will clear the effect decoration from the background even if the color background is what's currently visible.  since process background sets the current preview to the image background, we will immediately set it to what was there before, so if it's nil we will continue to see the color background.
        
        UIImage* prevBackground = appState.m_previewImageBackground.image;
        
        if(appState.backgroundImageRaw)
        {
            processBackground(0,false);
        }
        
        if(!prevBackground)
        {
            appState.setBackgroundImagePreview(nil);
        }
        
        appState.setForegroundImage(appState.importedImage);
        
        decoratorState.decoratorImage = nil;
    
        decoratorState.currentPhotoFilterImage=0;
        decoratorState.currentPhotoFilterBackground=0;
        decoratorState.seamlessEnabled=false;
    };
    
    box.push_back(PopupBoxEntry("Yes", startOverLambda));
    box.push_back(PopupBoxEntry("No", doNothing));
    
    box.display();
}


- (IBAction)effectsPressed:(id)sender
{
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel pushBottomPanelContentStack:@"EffectsHomeSegue"];
    }
}


- (IBAction)drawingButtonPressed:(id)sender
{
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel pushBottomPanelContentStack:@"DecoratorDrawingHomeSegue"];
    }
}


- (IBAction)moreButtonPressed:(id)sender
{
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel pushBottomPanelContentStack:@"DecoratorP2Segue"];
    }
}

@end
