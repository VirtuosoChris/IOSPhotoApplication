//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplication.h
//

#ifndef _PhotoApplication_h
#define _PhotoApplication_h

#include "PhotoApplicationConstants.h"
#include "PhotoApplicationAppState.h"


extern GlobalAppState appState;
extern GlobalDecoratorState decoratorState;

extern std::stack<NSString*> panelContentIdentifierStack;
extern NSString* currentPanelIdentifier;


/****** global functions ******/

///scale the preview panel's image view over the background image view based on the border slider
void updateConstraintsPreview();
void updateConstraintsPreview(UIImageView* viewIn, CGRect originalRect);

bool imageIsSquare();

///Generates the letterboxed image rendering, and writes stores it in the letterboxedImage field in ephemeral app state
void generateLetterboxed(bool decoratorOverlay=true);

void writeAutoSave();

void loadAutoSave();

void loadAutoSaveExtension();

void processBackground(unsigned int effectIndex=0, bool makeSeamless =false);

inline void importImage(UIImage* img)
{
    appState.importedImage = img;
    decoratorState.currentPhotoFilterImage=0;
    appState.setForegroundImage(img);
}


inline void processForeground(unsigned int effectIndex)
{
    SystemImage effectImg = appState.effects[effectIndex].effectFunction(SystemImageIOS(appState.importedImage));
    UIImage* img = toUIImage(effectImg);
    appState.setForegroundImage(img);
}


inline void loadEffects()
{
    appState.effects.push_back({"None", [](SystemImage img) -> SystemImage{return img;}, nil});
    appState.effects.push_back({"Negative", [](SystemImage img) -> SystemImage{return negative(img);},nil});
    appState.effects.push_back({"Pixellate", [](SystemImage img) -> SystemImage {return pixellate(img);},nil});
    
    appState.colors.push_back([UIColor purpleColor]);
    appState.colors.push_back([UIColor blueColor]);
    appState.colors.push_back([UIColor cyanColor]);
    appState.colors.push_back([UIColor greenColor]);
    appState.colors.push_back([UIColor yellowColor]);
    appState.colors.push_back([UIColor orangeColor]);
    appState.colors.push_back([UIColor colorWithRed:1.0f green:0.90f blue:0.70f alpha:1.0f]);
    appState.colors.push_back([UIColor brownColor]);
    appState.colors.push_back([UIColor redColor] );
    appState.colors.push_back([UIColor colorWithRed:1.0f green:0.50f blue:0.50f alpha:1.0f]);
    appState.colors.push_back([UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.0f]);
    appState.colors.push_back([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
    appState.colors.push_back([UIColor colorWithRed:1.0f green:1.00f blue:1.00f alpha:1.0f]);
}

#endif
