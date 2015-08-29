//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  EffectsHomeViewController.m
//

#import "EffectsHomeViewController.h"
#import "PhotoApplication.h"
#import "PopupMessage.h"

@interface EffectsHomeViewController ()

@end

@implementation EffectsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoEffectsPressed:(id)sender
{
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel pushBottomPanelContentStack:@"PhotoEffectsSegue"];
    }
}


- (IBAction)backgroundEffectsPressed:(id)sender
{
    
    if(appState.decoratorPanel)
    {
        if(appState.m_previewImageBackgroundDecorator.image)
        {
            [appState.decoratorPanel pushBottomPanelContentStack:@"BackgroundEffectsSegue"];
        }
        else
        {
            popupMessage("Load an image background before adding background effects!", "");
            return;
        }
    }
}


- (IBAction)backPressed:(id)sender
{
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel popBottomPanelContentStack];
    }
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
