//
//  PhotoApplicationConstants.m
//

#import "PhotoApplicationConstants.h"

const float minImageBackgroundScale = .25;
const float maxImageBackgroundScale = 1.750f;

const unsigned int PhotoApplication_IMAGE_CAP = 1300;

//min and max size of border.  values that get lerped using borderScale
float minBorder = .5f;
float maxBorder = 1.0f;

const NSString* defaultPhotoCaption = @" #PhotoApplication";

const NSString* backgroundPathsEaster[NUM_BACKGROUNDS_EASTER] =
{
    @"easter_1.jpg",
    @"easter_2.jpg",
    @"easter_3.jpg",
    @"easter_4.jpg",
    @"easter_5.jpg",
    @"easter_6.jpg",
    @"easter_7.jpg",
    @"easter_8.jpg"
};

const NSString* backgroundPathsTextures[NUM_BACKGROUNDS_TEXTURES] =
{
    @"textures1.jpg",
    @"textures2.jpg",
    @"textures3.jpg",
    @"textures4.jpg",
    @"textures5.jpg",
    @"textures6.jpg",
    @"textures7.jpg",
    @"textures8.jpg",
    @"textures9.jpg",
    @"textures10.jpg",
    @"textures11.jpg",
    @"textures12.jpg"
};

const NSString* backgroundPathsSecretForest[NUM_BACKGROUNDS_SECRETFOREST] =
{
    @"secretforest1.jpg",
    @"secretforest2.jpg",
    @"secretforest3.jpg",
    @"secretforest4.jpg",
    @"secretforest5.jpg",
    @"secretforest6.jpg",
    @"secretforest7.jpg",
    @"secretforest8.jpg",
    @"secretforest9.jpg",
    @"secretforest10.jpg",
    @"secretforest11.jpg",
    @"secretforest12.jpg",
    @"secretforest13.jpg",
    @"secretforest14.jpg"
};

const NSString* backgroundPacks[NUM_BACKGROUND_PACKS] =
{   @"Easter",
    @"Textures",
    @"Photo Textures",
    @"Abstract Patterns",
    @"Light",
    @"Floral",
    @"Outdoors",
    @"Tropical Paradise",
    @"Secret Forest"
};

const NSString* backgroundPackPreviewImage[NUM_BACKGROUND_PACKS] =
{
    @"easter_3.jpg",
    @"textures10.jpg",
    @"popcorn-texture.jpg",
    @"abstract1.jpg",
    @"light1.jpg",
    @"purple-flowers-wallpaper-texture.jpg",
    @"sunlight-on-fall-meadow-grass-close-up.jpg",
    @"tropical1.jpg",
    @"secretforest3.jpg"
};

const NSString* backgroundPackPreviewImage2[NUM_BACKGROUND_PACKS] =
{
    @"easter_4.jpg",
    @"textures5.jpg",
    @"sheet-music-texture.jpg",
    @"abstract2.jpg",
    @"light2.jpg",
    @"yellow-daisies-close-up-texture.jpg",
    @"clouds-in-the-sky.jpg",
    @"tropical2.jpg",
    @"secretforest14.jpg"
};


const unsigned int backgroundPackSize[NUM_BACKGROUND_PACKS] =
{
    NUM_BACKGROUNDS_EASTER,
    NUM_BACKGROUNDS_TEXTURES,
    NUM_BACKGROUNDS_PHOTO,
    NUM_BACKGROUNDS_ABSTRACT,
    NUM_BACKGROUNDS_LIGHTS,
    NUM_BACKGROUNDS_FLORAL,
    NUM_BACKGROUNDS_OUTDOORS,
    NUM_BACKGROUNDS_TROPICAL,
    NUM_BACKGROUNDS_SECRETFOREST
};


const NSString* backgroundPathsAbstract[NUM_BACKGROUNDS_ABSTRACT] =
{
    @"abstract1.jpg",
    @"abstract2.jpg",
    @"abstract3.jpg",
    @"abstract4.jpg",
    @"abstract5.jpg",
    @"abstract6.jpg",
    @"abstract7.jpg",
    @"abstract8.jpg",
    @"abstract9.jpg",
    @"abstract10.jpg"
};

const NSString* backgroundPathsTropical[NUM_BACKGROUNDS_TROPICAL] =
{
    @"tropical1.jpg",
    @"tropical2.jpg",
    @"tropical3.jpg",
    @"tropical4.jpg",
    @"tropical5.jpg",
    @"tropical6.jpg",
    @"tropical7.jpg",
    @"tropical8.jpg",
    @"tropical9.jpg",
    @"tropical10.jpg"
};


/*const NSString* backgroundPathsValentines[NUM_BACKGROUNDS_VALENTINES] =
{
    @"val1.jpg",
    @"val2.jpg",
    @"val3.jpg",
    @"val4.jpg",
};*/

const NSString* backgroundPathsLights[NUM_BACKGROUNDS_LIGHTS] =
{
    @"light1.jpg",
    @"light2.jpg",
    @"light3.jpg",
    @"light4.jpg",
    @"light5.jpg",
    @"light6.jpg"
};

/*const NSString* backgroundPathsPhoto[NUM_BACKGROUNDS_PHOTO] =
{
    @"clouds-in-the-sky.jpg",
    @"colorful-index-cards-scattered-on-desk-texture.jpg",
    @"green_grass.jpg",
    @"orange-autumn-leaves.jpg",
    @"popcorn-texture.jpg",
    @"parchment-paper-texture1.jpg",
    @"pebble-rock-gravel-texture.jpg",
    @"leaf-texture.jpg",
    @"cut-end-of-log-with-tree-rings-texture.jpg",
    @"roasted-peanuts-texture.jpg",
    @"dried-mud-cracks-texture.jpg",
    @"floral-fabric-texture.jpg",
    @"abstract-shapes-in-cement-texture.jpg",
    @"brilliant-orange-sunset-clouds.jpg",
    @"chain-link-fence-texture.jpg",
    @"mandelbrot.jpg",
    @"pennies.jpg",
    @"pink-curtains-texture.jpg",
    @"pink-fabric-with-floral-pattern-texture.jpg",
    @"purple-flowers-wallpaper-texture.jpg",
    @"scrub-oak-leaves-texture.jpg",
    @"sheet-music-texture.jpg",
    @"sunlight-on-fall-meadow-grass-close-up.jpg",
    @"swirled-yellow-glass-close-up-texture.jpg",
    @"tan-cable-knit-pattern-texture.jpg",
    @"integrated-circuit-board-close-up.jpg",
    @"water-reflecting-spring-trees.jpg",
    @"white-fabric-with-blue-red-and-gold-dots-texture.jpg",
    @"wooden-poles-texture.jpg",
    @"woven-straw-with-diamond-pattern-texture.jpg",
    @"yellow-daisies-close-up-texture.jpg",
    @"woven-straw-texture.jpg"
};*/

const NSString* backgroundPathsPhoto[NUM_BACKGROUNDS_PHOTO] =
{
    @"sheet-music-texture.jpg",
    @"popcorn-texture.jpg",
    @"parchment-paper-texture1.jpg",
    @"pebble-rock-gravel-texture.jpg",
    @"leaf-texture.jpg",
    @"cut-end-of-log-with-tree-rings-texture.jpg",
    @"roasted-peanuts-texture.jpg",
    @"dried-mud-cracks-texture.jpg",
    @"abstract-shapes-in-cement-texture.jpg",
    @"pennies.jpg",
    @"pink-curtains-texture.jpg",
    @"swirled-yellow-glass-close-up-texture.jpg",
    @"tan-cable-knit-pattern-texture.jpg",
    @"integrated-circuit-board-close-up.jpg",
    @"white-fabric-with-blue-red-and-gold-dots-texture.jpg",
    @"wooden-poles-texture.jpg",
    @"woven-straw-with-diamond-pattern-texture.jpg",
    @"woven-straw-texture.jpg",
    @"colorful-index-cards-scattered-on-desk-texture.jpg",
};

const NSString* backgroundPathsOutdoors[NUM_BACKGROUNDS_OUTDOORS] =
{
    @"clouds-in-the-sky.jpg",
    @"green_grass.jpg",
    @"orange-autumn-leaves.jpg",
    @"brilliant-orange-sunset-clouds.jpg",
    @"chain-link-fence-texture.jpg",
    @"scrub-oak-leaves-texture.jpg",
    @"sunlight-on-fall-meadow-grass-close-up.jpg",
    @"water-reflecting-spring-trees.jpg",
};

const NSString* backgroundPathsFloral[NUM_BACKGROUNDS_FLORAL] =
{
    @"floral-fabric-texture.jpg",
    @"pink-fabric-with-floral-pattern-texture.jpg",
    @"purple-flowers-wallpaper-texture.jpg",
    @"yellow-daisies-close-up-texture.jpg",
};


const PathArrayPtr backgroundPackPointers[NUM_BACKGROUND_PACKS] =
{
    (PathArrayPtr) backgroundPathsEaster,
    (PathArrayPtr) backgroundPathsTextures,
    (PathArrayPtr) backgroundPathsPhoto,
    (PathArrayPtr) backgroundPathsAbstract,
    (PathArrayPtr) backgroundPathsLights,
    (PathArrayPtr) backgroundPathsFloral,
    (PathArrayPtr) backgroundPathsOutdoors,
    (PathArrayPtr) backgroundPathsTropical,
    (PathArrayPtr) backgroundPathsSecretForest
};


/*****tutorial path arrays ***/


NSString* ipadFilesGettingStarted[] =
{
    @"GettingStarted/Image1.jpg",
    @"GettingStarted/Image2.jpg",
    @"GettingStarted/Image3.jpg",
    @"GettingStarted/Image4.jpg",
    @"GettingStarted/Image5.jpg",
    @"GettingStarted/Image6.jpg",
    @"GettingStarted/Image7.jpg",
    @"GettingStarted/Image8.jpg"
};


NSString* ipadFilesColorBorders[] =
{
    @"ColorBorders/Image1.jpg",
    @"ColorBorders/Image2.jpg",
    @"ColorBorders/Image3.jpg",
    @"ColorBorders/Image4.jpg"
};

NSString* ipadFilesImageBorders[] =
{
    @"ImageBorders/Image1.jpg",
    @"ImageBorders/Image2.jpg",
    @"ImageBorders/Image3.jpg",
    @"ImageBorders/Image4.jpg",
    @"ImageBorders/Image5.jpg",
    @"ImageBorders/Image6.jpg",
    @"ImageBorders/Image7.jpg"
};

NSString* ipadFilesAdvanced[] =
{
    @"AdvancedBorderFeatures/Image1.jpg",
    @"AdvancedBorderFeatures/Image2.jpg",
    @"AdvancedBorderFeatures/Image3.jpg",
    @"AdvancedBorderFeatures/Image4.jpg",
    @"AdvancedBorderFeatures/Image5.jpg",
    @"AdvancedBorderFeatures/Image6.jpg",
    @"AdvancedBorderFeatures/Image7.jpg",
    @"AdvancedBorderFeatures/Image8.jpg",
    @"AdvancedBorderFeatures/Image9.jpg",
    @"AdvancedBorderFeatures/Image10.jpg"
};

///iphone 4s files
NSString* iphone4FilesGettingStarted[] =
{
    @"GettingStarted/Image1.jpg",
    @"GettingStarted/Image2.jpg",
    @"GettingStarted/Image3.jpg",
    @"GettingStarted/Image4.jpg",
    @"GettingStarted/Image5.jpg",
    @"GettingStarted/Image6.jpg",
    @"GettingStarted/Image7.jpg",
};


NSString* iphone4FilesColorBorders[] =
{
    @"ColorBorders/Image1.jpg",
    @"ColorBorders/Image2.jpg",
    @"ColorBorders/Image3.jpg",
    @"ColorBorders/Image4.jpg"
};

NSString* iphone4FilesImageBorders[] =
{
    @"ImageBorders/Image1.jpg",
    @"ImageBorders/Image2.jpg",
    @"ImageBorders/Image3.jpg",
    @"ImageBorders/Image4.jpg",
    @"ImageBorders/Image5.jpg",
    @"ImageBorders/Image6.jpg",
    @"ImageBorders/Image7.jpg"
};

NSString* iphone4FilesAdvanced[] =
{
    @"AdvancedBorderFeatures/Image1.jpg",
    @"AdvancedBorderFeatures/Image2.jpg",
    @"AdvancedBorderFeatures/Image3.jpg",
    @"AdvancedBorderFeatures/Image4.jpg",
    @"AdvancedBorderFeatures/Image5.jpg",
    @"AdvancedBorderFeatures/Image6.jpg",
    @"AdvancedBorderFeatures/Image7.jpg",
    @"AdvancedBorderFeatures/Image8.jpg",
    @"AdvancedBorderFeatures/Image9.jpg",
    @"AdvancedBorderFeatures/Image10.jpg"
};

///iphone 6 images

NSString* iphone6FilesGettingStarted[] =
{
    @"GettingStarted/Image1.jpg",
    @"GettingStarted/Image2.jpg",
    @"GettingStarted/Image3.jpg",
    @"GettingStarted/Image4.jpg",
    @"GettingStarted/Image5.jpg",
    @"GettingStarted/Image6.jpg",
    @"GettingStarted/Image7.jpg",
    @"GettingStarted/Image8.jpg",
};


NSString* iphone6FilesColorBorders[] =
{
    @"ColorBorders/Image1.jpg",
    @"ColorBorders/Image2.jpg",
    @"ColorBorders/Image3.jpg",
    @"ColorBorders/Image4.jpg"
};

NSString* iphone6FilesImageBorders[] =
{
    @"ImageBorders/Image1.jpg",
    @"ImageBorders/Image2.jpg",
    @"ImageBorders/Image3.jpg",
    @"ImageBorders/Image4.jpg",
    @"ImageBorders/Image5.jpg",
    @"ImageBorders/Image6.jpg"
};

NSString* iphone6FilesAdvanced[] =
{
    @"AdvancedBorderFeatures/Image1.jpg",
    @"AdvancedBorderFeatures/Image2.jpg",
    @"AdvancedBorderFeatures/Image3.jpg",
    @"AdvancedBorderFeatures/Image4.jpg",
    @"AdvancedBorderFeatures/Image5.jpg",
    @"AdvancedBorderFeatures/Image6.jpg",
    @"AdvancedBorderFeatures/Image7.jpg",
    @"AdvancedBorderFeatures/Image8.jpg",
    @"AdvancedBorderFeatures/Image9.jpg",
    @"AdvancedBorderFeatures/Image10.jpg"
};

NSString* iphone6DecoratingOverview[] =
{
    @"DecoratingOverview/Image1.jpg",
    @"DecoratingOverview/Image2.jpg",
    @"DecoratingOverview/Image3.jpg",
    @"DecoratingOverview/Image4.jpg",
    @"DecoratingOverview/Image5.jpg",
    @"DecoratingOverview/Image6.jpg"
};


NSString* iphone6Drawing[] =
{
    @"Drawing/Image1.jpg",
    @"Drawing/Image2.jpg",
    @"Drawing/Image3.jpg",
    @"Drawing/Image4.jpg",
    @"Drawing/Image5.jpg",
    @"Drawing/Image6.jpg",
    @"Drawing/Image7.jpg",
    @"Drawing/Image8.jpg",
    @"Drawing/Image9.jpg",
    @"Drawing/Image10.jpg",
};

NSString* ipadFilesDecoratingOverview[] =
{
    @"DecoratingOverview/Image1.jpg",
    @"DecoratingOverview/Image2.jpg",
    @"DecoratingOverview/Image3.jpg",
    @"DecoratingOverview/Image4.jpg",
    @"DecoratingOverview/Image5.jpg",
    @"DecoratingOverview/Image6.jpg"
};

NSString* ipadFilesDrawing[] =
{
    @"Drawing/Image1.jpg",
    @"Drawing/Image2.jpg",
    @"Drawing/Image3.jpg",
    @"Drawing/Image4.jpg",
    @"Drawing/Image5.jpg",
    @"Drawing/Image6.jpg",
    @"Drawing/Image7.jpg",
    @"Drawing/Image8.jpg"
};

NSString* iphone4DecoratingOverview[] =
{
    @"DecoratingOverview/Image1.jpg",
    @"DecoratingOverview/Image2.jpg",
    @"DecoratingOverview/Image3.jpg",
    @"DecoratingOverview/Image4.jpg",
    @"DecoratingOverview/Image5.jpg",
    @"DecoratingOverview/Image6.jpg"
};

NSString* iphone4Drawing[] =
{
    @"Drawing/Image1.jpg",
    @"Drawing/Image2.jpg",
    @"Drawing/Image3.jpg",
    @"Drawing/Image4.jpg",
    @"Drawing/Image5.jpg",
    @"Drawing/Image6.jpg",
    @"Drawing/Image7.jpg",
    @"Drawing/Image8.jpg",
    @"Drawing/Image9.jpg"
};

const PathArrayPtr tutorialPathPointersIpad[NUM_TUTORIALS] =
{
    (PathArrayPtr) ipadFilesGettingStarted,
    (PathArrayPtr) ipadFilesColorBorders,
    (PathArrayPtr) ipadFilesImageBorders,
    (PathArrayPtr) ipadFilesAdvanced,
    (PathArrayPtr) ipadFilesDecoratingOverview,
    (PathArrayPtr) ipadFilesDrawing
};

const PathArrayPtr tutorialPathPointersIphone5[NUM_TUTORIALS] =
{
    (PathArrayPtr) iphone6FilesGettingStarted,
    (PathArrayPtr) iphone6FilesColorBorders,
    (PathArrayPtr) iphone6FilesImageBorders,
    (PathArrayPtr) iphone6FilesAdvanced,
    (PathArrayPtr) iphone6DecoratingOverview,
    (PathArrayPtr) iphone6Drawing
};

const PathArrayPtr tutorialPathPointersIphone4[NUM_TUTORIALS] =
{
    (PathArrayPtr) iphone4FilesGettingStarted,
    (PathArrayPtr) iphone4FilesColorBorders,
    (PathArrayPtr) iphone4FilesImageBorders,
    (PathArrayPtr) iphone4FilesAdvanced,
    (PathArrayPtr) iphone4DecoratingOverview,
    (PathArrayPtr) iphone4Drawing
};


const unsigned int tutorialSizeiPad[NUM_TUTORIALS] = {8,4,7,10,6,8};
const unsigned int tutorialSizeiPhone6[NUM_TUTORIALS] = {8,4,6,10,6,10};
const unsigned int tutorialSizeiPhone4[NUM_TUTORIALS] = {8,4,6,10,6,9};


