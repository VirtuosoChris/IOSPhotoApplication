//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplicationAppState.h
//

#ifndef _PhotoApplicationAppState_h
#define _PhotoApplicationAppState_h

#include <array>
#include <SystemImage.h>
#import "BackgroundOptionsViewController.h"
#import "ColorSliderViewController.h"
#import "DecoratorPanelViewController.h"
#import "DecoratorViewController.h"
#import <iosHelpers.h>
#import "SystemImageImplIos.h"
#import "tinyxml2.h"

using namespace tinyxml2;

enum ImageBackgroundLaunchOptions  {NONE, BUILT_IN_BACKGROUND, CAMERA_BACKGROUND, LIBRARY_BACKGROUND,CURRENT_PHOTO_BACKGROUND};


inline void loadFloat(XMLElement* elem, const char* str, float& val)
{
    if(elem->Attribute(str))
    {
        val = elem->FloatAttribute(str);
    }
}

inline void loadBool(XMLElement* elem, const char* str, bool& val)
{
    if(elem->Attribute(str))
    {
        val = elem->BoolAttribute(str);
    }
}

inline void loadInt(XMLElement* elem, const char* str, int& val)
{
    if(elem->Attribute(str))
    {
        val = elem->IntAttribute(str);
    }
}

inline void loadString(XMLElement* elem, const char* str, const char* val)
{
    const char* rval = 0;
    if((rval = elem->Attribute(str)))
    {
        val = rval;
    }
}


struct ImageBackgroundSettings
{
    float translateParameterX;
    float translateParameterY;
    float scaleParameter;
    
    ImageBackgroundSettings() : translateParameterX(0.0f),translateParameterY(0.0f),scaleParameter(1.0f){}
    
    void save(XMLPrinter& printer)const
    {
        printer.PushAttribute("translateParameterX", translateParameterX);
        printer.PushAttribute("translateParameterY", translateParameterY);
        printer.PushAttribute("scaleParameter", scaleParameter);
    }
    
    void load(XMLElement* saveElem)
    {
        
        loadFloat(saveElem,"translateParameterX", translateParameterX);
        loadFloat(saveElem, "translateParameterY", translateParameterY);
        loadFloat(saveElem, "scaleParameter", scaleParameter);
    }
};


struct BackgroundSettings : public ImageBackgroundSettings
{
    float borderScale;
    
    BackgroundSettings() : borderScale(0.0f){}
    
    void save(XMLPrinter& printer)const
    {
        const ImageBackgroundSettings& imageBackSetts = *this;
        imageBackSetts.save(printer);
        printer.PushAttribute("borderScale", borderScale);
    }
    
    void load(XMLElement* saveElem)
    {
        ImageBackgroundSettings& imageBackSetts = *this;
        imageBackSetts.load(saveElem);
        loadFloat(saveElem,"borderScale", borderScale);
    }
};

///App state that can be directly serialized : no pointers or strings, structs containing primitive types only
struct PhotoApplicationAppState : BackgroundSettings
{
    bool backgroundPanelIsImage;
    
    PhotoApplicationAppState() : backgroundPanelIsImage(false){}
    
    void save(XMLPrinter& printer)const
    {
        const BackgroundSettings& backgroundSettings = *this;
        backgroundSettings.save(printer);
        printer.PushAttribute("backgroundPanelIsImage", backgroundPanelIsImage);
    }
    
    
    void load(XMLElement* saveElem)
    {
        BackgroundSettings& backgroundSettings = *this;
        backgroundSettings.load(saveElem);
        loadBool(saveElem,"backgroundPanelIsImage", backgroundPanelIsImage);
    }
};


struct PhotoEffect
{
    std::string effectName;
    std::function<SystemImage(SystemImage)> effectFunction;
    UIImage* effectPreview;
};


#ifndef APP_EXTENSION
///Global App State for PhotoApplication that doesn't need serialization or deserialization on save and restore
struct EphemeralAppState
{
    UIImage* letterboxedImage;   ///< A pointer to the final image once it's been rendered
    
    UIImageView* m_previewImage; ///< The image view showing the image itself in the preview pane
    UIImageView* m_previewImageBackground; ///< The image view showing the background in the preview pane

    UIImageView* m_previewImageDecorator; ///< The image view showing the image itself in the preview pane
    UIImageView* m_previewImageBackgroundDecorator; ///< The image view showing the background in the preview pane

    UIImageView* m_decoratorImageView;
    
    ColorSliderViewController* colorSliderController;
    BackgroundOptionsViewController* imageSliderController;
    CGRect originalSizePreview;///< Original size of imageview for preview square that gets scaled
    CGRect originalSizePreviewDecorate; ///< Original size of imageview for preview square that gets scaled on decorator screen
    unsigned int numBackgroundsInSelectedPack;
    
    PathArrayPtr selectedBackgroundPackPaths;
    unsigned int numSlidesInTutorial;
    PathArrayPtr selectedTutorialSlidePaths;
 
    
    std::vector<UIColor*> colors;
    UIImage* defaultBackground; //"touch here to begin" button graphic
    ImageProcessingResult backgroundImageTiled; ///< affine tiled intermediate image for image background
    UIImage* backgroundProcessed; ///< Image background after all processing
    ImageBackgroundLaunchOptions imageLaunchOptions;
    
    DecoratorPanelViewController* decoratorPanel;
    DecoratorViewController* decoratorVC;
    
    std::vector<PhotoEffect> effects;
    
    EphemeralAppState() :
        letterboxedImage(nil),
        m_previewImage(nil),
        m_previewImageBackground(nil),
        m_previewImageDecorator(nil),
        m_previewImageBackgroundDecorator(nil),
        colorSliderController(nil),
        imageSliderController(nil),
        numBackgroundsInSelectedPack(NUM_BACKGROUNDS_PHOTO),
        selectedBackgroundPackPaths((PathArrayPtr)backgroundPathsPhoto),
        defaultBackground([UIImage imageNamed:@"DefaultImage.jpg"]),
        backgroundProcessed(nil),
        imageLaunchOptions(NONE),
        decoratorPanel(nil),
        decoratorVC(nil),
        m_decoratorImageView(nil)
    {
    }
};
#endif


///the entire global state of the app goes here.  PhotoApplicationAppState gets read/write as a struct, ephemeralappstate doesn't serialize, and any remaining fields here directly get custom (de)serialization
struct GlobalAppState : public PhotoApplicationAppState
#ifndef APP_EXTENSION
, EphemeralAppState
#endif
{
    UIImage* myImage;
    UIImage* importedImage;
    NSString* photoCaption;
    UIImage* backgroundImageRaw; //image background we loaded
    UIColor* currentColor;
    bool isDecorating;
    
    GlobalAppState() :
        myImage(nil),
#ifndef APP_EXTENSION
    photoCaption((NSString*)defaultPhotoCaption),
#endif
    backgroundImageRaw(nil),
        currentColor([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]),
        isDecorating(false)
    {
    }
    
    void save(XMLPrinter& printer)const
    {
        const PhotoApplicationAppState& appState = *this;
        appState.save(printer);
        printer.PushAttribute("caption", NSStringToString(photoCaption).c_str());
        const CGFloat *components = CGColorGetComponents(currentColor.CGColor);
        printer.PushAttribute("currentColorR", components[0]);
        printer.PushAttribute("currentColorG", components[1]);
        printer.PushAttribute("currentColorB", components[2]);
        printer.PushAttribute("isDecorating", isDecorating);
    }
    
    void load(XMLElement* saveElem)
    {
        PhotoApplicationAppState& appState = *this;
      
        appState.load(saveElem);
        
        const char* captionIn = saveElem->Attribute("caption");
        float redIn = saveElem->FloatAttribute("currentColorR");
        float greenIn = saveElem->FloatAttribute("currentColorG");
        float blueIn = saveElem->FloatAttribute("currentColorB");
    
        if(captionIn)
        {
            photoCaption = [NSString stringWithFormat:@"%s", captionIn];
        }
       
        currentColor = [UIColor colorWithRed:redIn green:greenIn blue:blueIn alpha:1.0];
        
        loadBool(saveElem, "isDecorating", isDecorating);
    }
    
    
#ifndef APP_EXTENSION
    void setForegroundImage(UIImage* img)
    {
        myImage = img;
        setForegroundImagePreview(img);
    }
    
    
    void setForegroundImagePreview(UIImage* img)
    {
        [m_previewImage setImage:img];
        [m_previewImageDecorator setImage: img];
    }
    
    bool isStartState()const
    {
        return m_previewImage.image == defaultBackground;
    }
    
    void setBackgroundImagePreview(UIImage* img)
    {
        //backgroundProcessed = img;
        [m_previewImageBackground setImage:img];
        [m_previewImageBackgroundDecorator setImage: img];
        
        if(!img)
        {
            [m_previewImageBackground setBackgroundColor:currentColor];
            [m_previewImageBackgroundDecorator setBackgroundColor:currentColor];
        }
    }
    
    void setBackgroundImage(UIImage* img)
    {
        backgroundProcessed = img;
        setBackgroundImagePreview(img);
    }
#endif
    
};


struct DecoratorStatePen
{
    float penR,penG,penB;
    float penSize;
    float lastPenX;
    float lastPenY;
    bool eraserEnabled;
    
    DecoratorStatePen() : penR(1.0f),penG(0.0f),penB(0.0f),penSize(40.0f), eraserEnabled(0)
    {
    }
    
    void save(XMLPrinter& printer)const
    {
        printer.PushAttribute("penR", penR);
        printer.PushAttribute("penG", penG);
        printer.PushAttribute("penB", penB);
        printer.PushAttribute("penSize", penSize);
        printer.PushAttribute("eraserEnabled", eraserEnabled);
        printer.PushAttribute("lastPenX", lastPenX);
        printer.PushAttribute("lastPenY", lastPenY);
    }
    
    void load(XMLElement* saveElem)
    {
        loadFloat(saveElem, "penR", penR);
        loadFloat(saveElem, "penG", penG);
        loadFloat(saveElem, "penB", penB);
        loadFloat(saveElem, "penSize",penSize);
        loadFloat(saveElem, "lastPenX", lastPenX);
        loadFloat(saveElem, "lastPenY",lastPenY);
        loadBool(saveElem, "eraserEnabled", eraserEnabled);
    }
    
};


struct DecoratorStateEffects
{
    bool seamlessEnabled;
    unsigned int currentPhotoFilterBackground;
    unsigned int currentPhotoFilterImage;
    
    DecoratorStateEffects():
        seamlessEnabled(false),
        currentPhotoFilterImage(0),
        currentPhotoFilterBackground(0)
    {
    }
    
    void save(XMLPrinter& printer)const
    {
        printer.PushAttribute("seamlessEnabled", seamlessEnabled);
        printer.PushAttribute("currentPhotoFilterBackground", currentPhotoFilterBackground);
        printer.PushAttribute("currentPhotoFilterImage", currentPhotoFilterImage);
    }
    
    void load(XMLElement* saveElem)
    {
        loadBool(saveElem, "seamlessEnabled", seamlessEnabled);
        currentPhotoFilterBackground = saveElem->UnsignedAttribute("currentPhotoFilterBackground");
        currentPhotoFilterImage = saveElem->UnsignedAttribute("currentPhotoFilterImage");
    }
};


struct GlobalDecoratorState : public DecoratorStatePen, public DecoratorStateEffects
{
    UIImage* decoratorImage;
    
    GlobalDecoratorState(): decoratorImage(nil){}
    
    void save(XMLPrinter& printer)const
    {
        bool hasDecorationImage = decoratorImage != nil;
        
        const DecoratorStatePen& decoratorStatePen = *this;
        decoratorStatePen.save(printer);
      
        const DecoratorStateEffects& effectsState = *this;
        effectsState.save(printer);
      
        if(hasDecorationImage)
        {
            const char* decorationPath = "decoration.png";
            
            NSString* myImagePath = [NSString stringWithFormat:@"%@/%s", appDocumentsPath(), decorationPath];
            
            SystemImageIOS myImage(decoratorImage);
            
            if(myImage.writeToFile(NSStringToString(myImagePath)))
            {
                printer.PushAttribute("decoratorPath",decorationPath);
            }
        }
    }
    
    
    void load(XMLElement* saveElem)
    {
        DecoratorStatePen& decoratorStatePen = *this;
        decoratorStatePen.load(saveElem);
        
        DecoratorStateEffects& effectsState = *this;
        effectsState.load(saveElem);
        const char* path = saveElem->Attribute("decoratorPath");
        
        if(path)
        {
            NSString* myImagePath = [NSString stringWithFormat:@"%@/%s", appDocumentsPath(), path];
            
            decoratorImage =toUIImage(SystemImage(NSStringToString(myImagePath)));
        }
    }
};

#endif
