//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplication.mm
//

#import "PhotoApplication.h"
#import "AppDelegate.h"
#import <iosHelpers.h>
#import <SystemImageImplIos.h>
#include <fstream>
#import "tinyxml2.h"
#import "PhotoApplicationOpenGL.h"
#import "PopupMessage.h"
#import "GetPhoto.h"

GlobalAppState appState;
GlobalDecoratorState decoratorState;

std::stack<NSString*> panelContentIdentifierStack;
NSString* currentPanelIdentifier = @"DecoratorHomeSegue";
using namespace tinyxml2;

bool imageIsSquare()
{
    return (appState.myImage.size.width == appState.myImage.size.height);
}


void processBackground(unsigned int effectIndex, bool makeSeamless)
{
    ///If seamless tiling is enabled take the input background and make a seamless version of it
    
    if(makeSeamless)
    {
        SystemImage seamlessImg = makeImageSeamless(SystemImageIOS(appState.backgroundImageRaw));
        appState.backgroundImageTiled = affineTile(seamlessImg);
    }
    else
    {
        appState.backgroundImageTiled = affineTile(SystemImageIOS(appState.backgroundImageRaw));
    }
    
    ///transform the image first, then call the effect function on it
    
    float tx =  (appState.translateParameterX * appState.backgroundImageRaw.size.width) * appState.scaleParameter;
    float ty = (appState.translateParameterY * appState.backgroundImageRaw.size.height) * appState.scaleParameter;
    
    ImageProcessingResult backgroundImageTiled2 = affineTransform(appState.backgroundImageTiled, appState.scaleParameter, 0.0f, 0.0f,appState.scaleParameter, tx, ty);
    
    float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
    
    SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
    appState.backgroundProcessed = toUIImage(cropped);
    
    SystemImage postEffectsImage =appState.effects[effectIndex].effectFunction(cropped);
    
    ///export the post-effects image to the app state
    
    UIImage* post = toUIImage(postEffectsImage);
    
    appState.setBackgroundImage(post);
}

///used in generateLetterboxed().  downsample background based on tiling.  not used everywhere for performance and possible bug introduction.  should be otherwise identical to processbackground().  \todo if it works later merge into processBackground() with a flag.
UIImage* processBackgroundMagic(unsigned int effectIndex, bool makeSeamless)
{
    UIImage* filteredRaw = nil;
    
    if( appState.scaleParameter >= 1.0)
    {
        filteredRaw = appState.backgroundImageRaw;
    }
    else
    {
        float filterRad = .50f / appState.scaleParameter;
        
        ImageProcessingResult seamless = affineTile(SystemImageIOS(appState.backgroundImageRaw));
        
        ImageProcessingResult filtered = gaussianBlur(seamless, filterRad);
        
        float rawW = SystemImageIOS(appState.backgroundImageRaw).getWidth();
        float rawH = SystemImageIOS(appState.backgroundImageRaw).getHeight();
        
        SystemImage filteredCrop = crop(filtered, 0, 0, rawW, rawH);
        
        filteredRaw = toUIImage(filteredCrop);
    }
    
    
    ImageProcessingResult tiledImg; //gets passed on to the transformation below
    
    ///If seamless tiling is enabled take the input background and make a seamless version of it
    if(makeSeamless)
    {
        SystemImage seamlessImg = makeImageSeamless(SystemImageIOS(filteredRaw));
        tiledImg = affineTile(seamlessImg);
    }
    else
    {
        tiledImg = affineTile(SystemImageIOS(filteredRaw));
    }
    
    ///transform the image first, then call the effect function on it
    
    float tx =  (appState.translateParameterX * appState.backgroundImageRaw.size.width) * appState.scaleParameter;
    float ty = (appState.translateParameterY * appState.backgroundImageRaw.size.height) * appState.scaleParameter;
    
    ImageProcessingResult backgroundImageTiled2 = affineTransform(tiledImg, appState.scaleParameter, 0.0f, 0.0f,appState.scaleParameter, tx, ty);
    
    float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
    
    SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
    //appState.backgroundProcessed = toUIImage(cropped);
    
    SystemImage postEffectsImage =appState.effects[effectIndex].effectFunction(cropped);
    
#define MAYBEFIX

    //SystemImage post = postEffectsImage;
    
    //float gaussRad;
    
    //UIImage* gaussed = toUIImage(gaussianBlur(postEffectsImage, gaussRad));
#ifdef MAYBEFIX
    return toUIImage(postEffectsImage);
#else
    
    SystemImage post = postEffectsImage;
    
    float gaussRad;
    
    UIImage* gaussed = toUIImage(gaussianBlur(post, gaussRad));
    
    return gaussed;
#endif
}


//this fixed bug where we were on image screen but didn't have an image background: in case of recursive matting, switching "to image" prior to loading image background, or starting over.
//we test based on the preview's background image view because we don't want to always delete the user's image background work.
bool hasImageBackground()
{
    UIImage* visibleBackgroundImage = appState.m_previewImageBackground.image;
    return visibleBackgroundImage;
}



void updateConstraintsPreview(UIImageView* viewIn, CGRect originalRect)
{
    float borderVal = (1.0f - appState.borderScale )* maxBorder + appState.borderScale * minBorder;
    
    float centerX = originalRect.origin.x + .5f * originalRect.size.width;
    float centerY = originalRect.origin.y + .5f * originalRect.size.height;
    
    float newWidth = originalRect.size.width * borderVal;
    float newHeight = originalRect.size.height * borderVal;
    
    float newOriginX = centerX - .5f*newWidth;
    float newOriginY = centerY - .5f*newHeight;
    
    CGRect newRect = CGRectMake(newOriginX, newOriginY, newWidth, newHeight);
    
    [viewIn setFrame:newRect];
}


void updateConstraintsPreview()
{
    updateConstraintsPreview(appState.m_previewImageDecorator, appState.originalSizePreviewDecorate);
    updateConstraintsPreview(appState.m_previewImage, appState.originalSizePreview);
}


void generateLetterboxed(bool decoratorOverlay)
{
    const unsigned int minDimension = PhotoApplication_SQUARE_DIM; //instagram requirement
    UIImage* img = appState.myImage;
    
    unsigned int w =  img.size.width;
    unsigned int h =  img.size.height;
    
    unsigned int dimToScale = std::max<unsigned int>(w,h);
    
    float scale = (float)minDimension / dimToScale;
    unsigned int newW = w * scale;
    unsigned int newH = h * scale;
    
    float borderValue = (1.0f - appState.borderScale) * maxBorder + appState.borderScale*minBorder;
    
    newW *= borderValue;
    newH *= borderValue;
    
    std::size_t beginX,beginY;
    
    beginX = (minDimension - newW  )>>1u;
    beginY = (minDimension - newH )>>1u;
    
    LDRImage::index_type dims = {{4,1,1}};
    LDRImage blackImage(dims);
    
    CGSize destinationSize = CGSizeMake( (CGFloat)minDimension, (CGFloat)minDimension);
    UIGraphicsBeginImageContext(destinationSize);
    
    if(!hasImageBackground())
    {
        //popupMessage("NO IMAGE IN BACKGROUND");
        
        const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
        
        blackImage[0] = 255*components[0];
        blackImage[1] = 255*components[1];
        blackImage[2] = 255*components[2];
        blackImage[3] = 255u;
        
        SystemImage blackImgSys(blackImage.dataPtr(),1u,1u);
        
        [toUIImage(blackImgSys) drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
    }
    else
    {
        //UIImage* processedBack = appState.backgroundProcessed;
        //SystemImageIOS(appState.backgroundProcessed)
        
        UIImage* filteredBackground = processBackgroundMagic(decoratorState.currentPhotoFilterBackground, decoratorState.seamlessEnabled);
    
       // savePhotoToAlbum(SystemImageIOS(appState.backgroundProcessed));
        
      /*  if(!filteredBackground)
        {
            popupMessage("IMG IN BACKGROUND, FILTERED IS NOT VALID");
        }
        else
        {
            //savePhotoToAlbum(SystemImageIOS(filteredBackground));
            popupMessage("IMAGE IN BACKGROUND, FILTERED IS VALID");
        }*/
        
        //[(appState.backgroundProcessed) drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
        [filteredBackground drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
    }
    
    //savePhotoToAlbum(SystemImageIOS(img));
    
    [img drawInRect:CGRectMake(beginX,beginY,newW,newH)];
    
    if(decoratorOverlay && decoratorState.decoratorImage)
    {
        
        SystemImage decImg = SystemImageIOS(decoratorState.decoratorImage);
        
        /*
         ImageProcessingResult gaussResult = gaussianBlur(affineTile(decImg), .75f);
        
        SystemImage filteredDec = crop(gaussResult, 0, 0, decImg.getWidth(), decImg.getHeight());
        */
        
        //[toUIImage(filteredDec) drawInRect:CGRectMake(0, 0, minDimension, minDimension)];

        [toUIImage(decImg) drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
    }
    
    appState.letterboxedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


void writeAutoSave()
{
    
    if(renderer)
    {
        context.bind();
        decoratorState.decoratorImage = toUIImage(renderer->extractDrawingImage());
    }
    
    XMLPrinter printer(NULL);
    
    printer.OpenElement("PhotoApplicationSave");
    //XMLDocument doc;
    std::cout<<"LOGGING TO "<<NSStringToString(appDocumentsPath())<<std::endl;
    
    NSString* xmlPath = [NSString stringWithFormat:@"%@/autosave.xml", appDocumentsPath()];

    printer.PushAttribute("Version", PhotoApplication_VERSION);

    appState.save(printer);
    
    if(appState.importedImage)
    {
        NSString* myImagePath = [NSString stringWithFormat:@"%@/myImage.png", appDocumentsPath()];
        SystemImageIOS myImage(appState.importedImage);
        
        myImage.writeToFile(NSStringToString(myImagePath));
        printer.PushAttribute("photoPath", "myImage.png");
    }
    
    if(appState.backgroundImageRaw)
    {
        printer.PushAttribute("backgroundPath","background.png");
        NSString* backgroundImagePath = [NSString stringWithFormat:@"%@/background.png", appDocumentsPath()];
        SystemImageIOS backgroundImage(appState.backgroundImageRaw);
        backgroundImage.writeToFile(NSStringToString(backgroundImagePath));
    }
    
    
    NSString* stackFilePath = [NSString stringWithFormat:@"%@/stack.txt", appDocumentsPath()];
    std::ofstream stackFile(NSStringToString(stackFilePath).c_str(), std::ios::out);
    
    stackFile<<NSStringToString(currentPanelIdentifier)<<std::endl;
    
    auto panelContentIdentifierStack2 = panelContentIdentifierStack;
    
    while(panelContentIdentifierStack2.size())
    {
        stackFile<<NSStringToString(panelContentIdentifierStack2.top())<<std::endl;
        panelContentIdentifierStack2.pop();
    }
    
    stackFile.close();
    
    printer.CloseElement();
    
    printer.OpenElement("PhotoApplicationDecorationSave");
    printer.PushAttribute("Version", PhotoApplication_VERSION);
    decoratorState.save(printer);
    printer.CloseElement();
    
    std::ofstream file(NSStringToString(xmlPath));
    file<<printer.CStr();
}

void loadAutoSavePath(NSString* directory);


void loadAutoSaveExtension()
{
    NSURL *groupURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       @"group.PhotoApplication"];
    
    
    NSString* toString = [groupURL path];
    
    loadAutoSavePath(toString);
}

void loadAutoSave()
{
    loadAutoSavePath(appDocumentsPath());
}

void loadAutoSavePath(NSString* directory)
{
    
    NSString* xmlPath = [NSString stringWithFormat:@"%@/autosave.xml", directory];
    
    XMLDocument doc;
    
    if(XML_NO_ERROR != doc.LoadFile(NSStringToString(xmlPath).c_str()))
    {
        return;
    }
    
    XMLElement* save = doc.FirstChildElement("PhotoApplicationSave");
    if(!save)return;
    
    const char* photoPath = save->Attribute("photoPath");
    const char* backgroundPath = save->Attribute("backgroundPath");
  
    appState.load(save);
    
    XMLElement* decoratorSave = doc.FirstChildElement("PhotoApplicationDecorationSave");
    if(decoratorSave)
    {
        decoratorState.load(decoratorSave);
    }
    
    if(backgroundPath)
    {
        NSString* backgroundImagePath = [NSString stringWithFormat:@"%@/%s", directory,backgroundPath];
        
        appState.backgroundImageRaw =  toUIImage(SystemImage(NSStringToString(backgroundImagePath)));
        
        processBackground(decoratorState.currentPhotoFilterBackground, decoratorState.seamlessEnabled);
    }
        
    if(photoPath)
    {
        NSString* myImagePath = [NSString stringWithFormat:@"%@/%s", directory, photoPath];
        
        appState.importedImage = appState.myImage = toUIImage(SystemImage(NSStringToString(myImagePath)));
        
        processForeground(decoratorState.currentPhotoFilterImage);
    }
    
    NSString* stackFilePath = [NSString stringWithFormat:@"%@/stack.txt", directory];
    std::ifstream stackFile(NSStringToString(stackFilePath).c_str(), std::ios::in);
    
    if(stackFile.is_open())
    {
        std::string tmp;
        if(stackFile>>tmp)
        {
            currentPanelIdentifier = [NSString stringWithFormat:@"%s", tmp.c_str()];
        }
        
        std::list<std::string> stringList;
        
        while(stackFile>>tmp)
        {
            stringList.push_front(tmp);
        }
        
        for(auto it = stringList.begin(); it != stringList.end(); it++)
        {
            NSString* str = [NSString stringWithFormat:@"%s", it->c_str()];
            panelContentIdentifierStack.push(str);
        }
        
        stackFile.close();
    }
    
    if(decoratorState.decoratorImage)
    {
        renderer->setDecoratorTexture(decoratorState.decoratorImage);
    }
    
    decoratorState.decoratorImage = toUIImage(renderer->extractDrawingImageSmooth());
}