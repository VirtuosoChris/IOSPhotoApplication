//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplicationConstants.h
//

#ifndef _PhotoApplicationConstants_h
#define _PhotoApplicationConstants_h

#define NUM_BACKGROUND_PACKS 9

#define NUM_BACKGROUNDS_PHOTO 19
#define NUM_BACKGROUNDS_OUTDOORS 8
#define NUM_BACKGROUNDS_FLORAL 4
#define NUM_BACKGROUNDS_LIGHTS 6
//#define NUM_BACKGROUNDS_VALENTINES 4
#define NUM_BACKGROUNDS_EASTER 8
#define NUM_BACKGROUNDS_TEXTURES 12
#define NUM_BACKGROUNDS_SECRETFOREST 14
#define NUM_BACKGROUNDS_TROPICAL 10
#define NUM_BACKGROUNDS_ABSTRACT 10

#define MAX_CAPTION_CHARS 140

#define PhotoApplication_SQUARE_DIM 2048

extern const unsigned int PhotoApplication_IMAGE_CAP;
static const unsigned int PhotoApplication_VERSION = 200;

#define NUM_TUTORIALS 6

typedef NSString* __strong * PathArrayPtr;

extern const float minImageBackgroundScale;
extern const float maxImageBackgroundScale;

extern const NSString* backgroundPacks[NUM_BACKGROUND_PACKS];
extern const unsigned int backgroundPackSize[NUM_BACKGROUND_PACKS];
extern const NSString* backgroundPackPreviewImage[NUM_BACKGROUND_PACKS];
extern const NSString* backgroundPackPreviewImage2[NUM_BACKGROUND_PACKS];

extern const NSString* backgroundPathsLights[NUM_BACKGROUNDS_LIGHTS];
extern const NSString* backgroundPathsPhoto[NUM_BACKGROUNDS_PHOTO];

extern const NSString* backgroundPathsEaster[NUM_BACKGROUNDS_EASTER];
extern const NSString* backgroundPathsTextures[NUM_BACKGROUNDS_TEXTURES];
extern const NSString* backgroundPathsSecretForest[NUM_BACKGROUNDS_SECRETFOREST];

extern const PathArrayPtr backgroundPackPointers[NUM_BACKGROUND_PACKS];

extern const NSString* defaultPhotoCaption;

//min and max size of border.  values that get lerped using borderScale
extern float minBorder;
extern float maxBorder;

extern NSString* ipadFilesGettingStarted[];
extern NSString* ipadFilesColorBorders[];
extern NSString* ipadFilesImageBorders[];
extern NSString* ipadFilesAdvanced[];
extern NSString* iphone4FilesGettingStarted[];
extern NSString* iphone4FilesColorBorders[];
extern NSString* iphone4FilesImageBorders[];
extern NSString* iphone4FilesAdvanced[];
extern NSString* iphone6FilesGettingStarted[];
extern NSString* iphone6FilesColorBorders[];
extern NSString* iphone6FilesImageBorders[];
extern NSString* iphone6FilesAdvanced[];

extern const PathArrayPtr tutorialPathPointersIpad[NUM_TUTORIALS];
extern const PathArrayPtr tutorialPathPointersIphone5[NUM_TUTORIALS];
extern const PathArrayPtr tutorialPathPointersIphone4[NUM_TUTORIALS];

extern const unsigned int tutorialSizeiPhone6[NUM_TUTORIALS];
extern const unsigned int tutorialSizeiPad[NUM_TUTORIALS];
extern const unsigned int tutorialSizeiPhone4[NUM_TUTORIALS];

#endif
