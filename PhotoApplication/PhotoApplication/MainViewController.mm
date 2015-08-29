//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

///
///@file MainViewController.m
///@brief Main view controller for the app
//

#import "MainViewController.h"
#include "SystemImage.h"
#include <iosHelpers.h>
#import "AppDelegate.h"
#include <SystemImageImplIos.h>
#import "AppDelegate.h"
#include <SystemImage.h>
#include <iosHelpers.h>
#include "GetPhoto.h"
#include <SocialIOS.h>
#import <PopupMessage.h>
#import "PhotoApplicationOpenGL.h"

///@brief shortened caption because we want ellipsis at end of long caption instead of middle
NSString* makeShortenedCaption(NSString* caption)
{
    unsigned int MAX_LENGTH = isIpad() ? 5 : 4;
    
    if([caption length] < MAX_LENGTH)
    {
        return caption;
    }
    else
    {
        return [NSString stringWithFormat:@"%@...",[caption substringToIndex:MAX_LENGTH]];
    }
}


void successfulSaveLibrary(const SystemImage& sys )
{
    const char* msg = "Photo saved to the PhotoApplication album and Camera Roll in your photo library.";
    popupMessage(msg,"Successful Save");
}


@interface MainViewController ()
@end


@implementation MainViewController

static bool bannerIsVisible=true;
static bool allowAds = true;
static CGRect rect;

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = allowAds;
    if (!willLeave && shouldExecuteAction)
    {
    }
    return shouldExecuteAction;
}


- (void) transitionInstagramTutorial
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramExampleViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = rect;
        [UIView commitAnimations];
        bannerIsVisible = true;
    }
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(rect, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = false;
    }
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


- (IBAction)backgroundSwitchButtonPressed:(id)sender
{
    [_backgroundSwitchButton setHighlighted:NO];
    
    if(self.childViewController.transitioning)return;
    
    if(appState.backgroundPanelIsImage)
    {
        [self.childViewController swapToColorVC];
        appState.backgroundPanelIsImage=false;
        [_backgroundSwitchButton setTitle:@"Image" forState:UIControlStateNormal];
        _colorImageIconView.image = [UIImage imageNamed:@"Image.png"];
    }
    else
    {
        [self.childViewController swapToImageVC];
        appState.backgroundPanelIsImage=true;
        [_backgroundSwitchButton setTitle:@"Color" forState:UIControlStateNormal];
        _colorImageIconView.image = [UIImage imageNamed:@"Color.png"];
    }
}


///returns uiimage contents of systemimage if under cap; otherwise returns new UIImage with capped image
-(UIImage*) resolutionCap: (SystemImage) img withDimension: (unsigned int) capDim
{
    float maxDim = std::max(img.getWidth(), img.getHeight());
    
    if(maxDim <= capDim)
    {
        return toUIImage(img);
    }
    else
    {
        float downscale = capDim  / maxDim;
        //float newW = img.getWidth() * downscale;
        //float newH = img.getHeight() * downscale;
        return resizedCopyGauss(img, downscale);
        //return toUIImage(img2);
    }
}

 
-(void)newPhoto
{
    auto myLambda = [self](SystemImage img)
    {
        savePhotoToAlbum(img, "PhotoApplication");
        
        importImage([self resolutionCap:img withDimension: PhotoApplication_IMAGE_CAP]);
        
        if(renderer)renderer->clear();
        updateRendererPreviews();
            
        appState.photoCaption = (NSString*)defaultPhotoCaption;
        [self.captionButton setTitle:@"Caption" forState:UIControlStateNormal];
        
        [self setBorderCenterIfSquare:img];
    };
    
    if(appState.isStartState())
    {
        appState.borderScale = 0.0f;
        
        if(appState.imageSliderController)
        {
            [appState.imageSliderController resetSliders];
            appState.imageSliderController.borderSlider.value = appState.borderScale;
            [appState.imageSliderController updateSwatch];
        }
        
        if(appState.colorSliderController)
        {
            [appState.colorSliderController resetColorSliders];
            appState.colorSliderController.borderSlider.value = appState.borderScale;
        }
        
        appState.setBackgroundImagePreview(nil);
        
        updateConstraintsPreview();
    }
    
    getPhotoFromCamera(myLambda);
}


-(void) setBorderCenter
{
    appState.borderScale = .5f;// * minBorder + .5f * maxBorder;

    if(appState.imageSliderController)
    {
        appState.imageSliderController.borderSlider.value = appState.borderScale;
    }
    if(appState.colorSliderController)
    {
        appState.colorSliderController.borderSlider.value = appState.borderScale;
    }
    
    updateConstraintsPreview();
}


-(void) setBorderCenterIfSquare : (SystemImage&) img
{
    if((img.getWidth() == img.getHeight()) && appState.borderScale ==0.0f)
    {
        [self setBorderCenter];
    }
}


- (void)getPhoto
{
    auto myLambda = [self](SystemImage img)
    {
        importImage([self resolutionCap:img withDimension:PhotoApplication_IMAGE_CAP]);

        if(renderer)renderer->clear();
        updateRendererPreviews();
        
        appState.photoCaption = (NSString*)defaultPhotoCaption;
        [self.captionButton setTitle:@"Caption" forState:UIControlStateNormal];
        
        [self setBorderCenterIfSquare: img];
    };
    
    if(appState.isStartState())
    {
        appState.borderScale = 0.0f;
        
        if(appState.imageSliderController)
        {
            [appState.imageSliderController resetSliders];
            appState.imageSliderController.borderSlider.value = appState.borderScale;
            [appState.imageSliderController updateSwatch];
        }
        
        if(appState.colorSliderController)
        {
            [appState.colorSliderController resetColorSliders];
            appState.colorSliderController.borderSlider.value = appState.borderScale;
        }
        
        appState.setBackgroundImagePreview(nil);
        
        updateConstraintsPreview();
    }
    
    getPhotoFromLibrary(myLambda);
}


- (IBAction)FrameButtonPressed:(id)sender
{
    _frameActionSheet.display();
}


-(void) shareMail
{
    SystemImage simG = SystemImageIOS(appState.letterboxedImage);
    UIImage* img = toUIImage(simG);
    [self PhotoApplicationMail:img];
}


-(void) shareFacebook
{
    SystemImage simG = SystemImageIOS(appState.letterboxedImage);
    
    const float fbSize = 1024.0f;
    
    SystemImage fbImg = resizedCopy(simG, fbSize, fbSize);
    
    UIImage* img = toUIImage(fbImg);
    
    //savePhotoToAlbum(fbImg);
    
    [self PhotoApplicationFacebook:img];
}


-(void) shareTwitter
{
    SystemImage simG = SystemImageIOS(appState.letterboxedImage);
    
    const float twitterSize = 1024.0f;
    
    SystemImage twitterImg = resizedCopy(simG, twitterSize, twitterSize);
    
    UIImage* img = toUIImage(twitterImg);
    
    [self PhotoApplicationTwitter:img];
}


-(void) PhotoApplicationMail: (UIImage*) image
{
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setSubject: appState.photoCaption];
    
    [mailController setMessageBody: @"" isHTML: NO];

    [mailController setMailComposeDelegate : self];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [mailController addAttachmentData:imageData mimeType:@"image/png"   fileName:@"PhotoApplicationPicture.png"];
    
    [self presentViewController:mailController animated:YES completion:nil];
}


- (IBAction)picturePushed:(id)sender
{
    _actionSheetGet.display();
}


-(void) PhotoApplicationFacebook: (UIImage*) img
{
    SocialPostIOS post;
    post.setInitialText(appState.photoCaption);
    post.addImage(img);
    post.display( serviceType[FACEBOOK] );
}


-(void) PhotoApplicationTwitter: (UIImage*) img
{
    SocialPostIOS post;
    post.setInitialText(appState.photoCaption);
    post.addImage(img);
    post.display( serviceType[TWITTER] );
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appState.colors.size();
}


- (IBAction)cameraButtonPressed:(id)sender
{
    _actionSheetGet.display();
}


- (IBAction)shareButtonPressed:(id)sender
{
    generateLetterboxed();
    
    if( appState.isStartState()){
        popupMessage("Import a photo before trying to share.", "");
        return;
    }
    _actionSheetSocial.display();
}


- (IBAction)helpButtonPressed:(id)sender
{
}


- (BOOL)prefersStatusBarHidden { return YES; }


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}


- (IBAction)acceptPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(appState.isDecorating)
    {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DecoratorViewController"];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

    if(appState.myImage)
    {
        appState.setForegroundImagePreview(appState.myImage);
    }
    
    if(appState.photoCaption.length && ![appState.photoCaption isEqualToString : (NSString*)defaultPhotoCaption])
    {
        NSString* photoCaption2 = makeShortenedCaption(appState.photoCaption);
        [self.captionButton setTitle:photoCaption2 forState:UIControlStateNormal];
    }
    else
    {
        [self.captionButton setTitle:@"Caption" forState:UIControlStateNormal];
    }
    
    if(appState.backgroundPanelIsImage)
    {
        self.childViewController.currentSegueIdentifier = SegueIdentifierSecond;
        [_backgroundSwitchButton setTitle:@"Color" forState:UIControlStateNormal];
            _colorImageIconView.image = [UIImage imageNamed:@"Color.png"];
    }
    else
    {
        self.childViewController.currentSegueIdentifier = SegueIdentifierFirst;
        [_backgroundSwitchButton setTitle:@"Image" forState:UIControlStateNormal];
                _colorImageIconView.image = [UIImage imageNamed:@"Image.png"];
    }

    [self.childViewController performSegueWithIdentifier:self.childViewController.currentSegueIdentifier sender:nil];
    
    if(decoratorState.decoratorImage)
    {
        _decoratorImageView.image = decoratorState.decoratorImage;
    }
    else
    {
        _decoratorImageView.image = nil;
    }
    
    updateConstraintsPreview();
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedSequeID"])
    {
        _childViewController = (ContainerOptionsViewController *) [segue destinationViewController];
    }
    else
    {
    }
}


void doNothing(){}


bool emailSupported()
{
    return [MFMailComposeViewController  canSendMail];
}


-(void) shareInstagram{
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSString* file  = [NSString stringWithFormat: @"%@%s", appDocumentsPath() , "/instagramtemp.igo"];
        
        NSData* data = UIImageJPEGRepresentation(appState.letterboxedImage,1.0f);
        
        [data writeToFile: file atomically:YES];
        
        NSURL* url = [NSURL fileURLWithPath:file];
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:url];
    
        if(appState.photoCaption)
        {
            NSString* objectStr = appState.photoCaption;
            NSString* keyStr = @"InstagramCaption";
            
            NSDictionary* annotation = [NSDictionary dictionaryWithObjects:&objectStr forKeys:&keyStr count:1];
            
            self.dic.annotation = annotation;
        }
        
        self.dic.UTI = @"com.instagram.exclusivegram";
        
        self.dic.delegate=self;
        
        NSDictionary* dict = [NSDictionary dictionaryWithObject: appState.photoCaption forKey:@"InstagramCaption"];
        self.dic.annotation = dict;
        
        UIViewController *controller = self;
        
        CGRect rect = controller.view.bounds;
    
        if(getDeviceVersion().device == DeviceVersion::IPAD)
        {
            [self.dic presentOpenInMenuFromRect: rect    inView: self.toolbar animated: YES];
        }
        else
        {
            [self.dic presentOpenInMenuFromRect: rect    inView: controller.view animated: YES];
        }
    }
    else
    {
        if(!isIpad())
        {
            popupMessage("Instagram sharing requires the Instagram app!  Please install it from the app store before sharing with Instagram.","");
        }
        else
        {
            static PopupBox instagramPopup("Instagram Not Found!", "You do not have Instagram installed on your iPad.  Would you like to see how to find it in the app store?");
            
            static bool runOnce = false;
            
            if(!runOnce)
            {
                runOnce = true;
                
                auto myLambda = [self](){ [self transitionInstagramTutorial]; };
                
                instagramPopup.push_back( PopupBoxEntry("Yes", myLambda));
                instagramPopup.push_back(PopupBoxEntry("No",[](){} ));
                
            }
            instagramPopup.display();
        }
    }
}


- (IBAction)decoratePressed:(id)sender
{
    [_decorateButton setHighlighted:NO];
    
    if(appState.isStartState())
    {
        popupMessage("Import a photo before decorating!", "");
        return;
    }
    
    //generateLetterboxed(); ///generate the letterboxed image for use as OpenGL texture, for rendering
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DecoratorViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void) highlightDecorateButton
{
    [_decorateButton setHighlighted:YES];
}

-(void) highlightCaptionButton
{
    [_captionButton setHighlighted:YES];
}

-(void) highlightSwitchButton
{
    [_backgroundSwitchButton setHighlighted:YES];
}

-(void) captionButtonPressed
{
    [_captionButton setHighlighted:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [_captionIconBUTTON addTarget:self
                           action:@selector(captionButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [_captionIconBUTTON addTarget:self
                           action:@selector(highlightCaptionButton)
                 forControlEvents:UIControlEventTouchDown];
    
    [_decorateIconBUTTON addTarget:self
                            action:@selector(decoratePressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_decorateIconBUTTON addTarget:self
                            action:@selector(highlightDecorateButton)
                  forControlEvents:UIControlEventTouchDown];
    
    [_imageIconBUTTON addTarget:self
                         action:@selector(backgroundSwitchButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    
    
    [_imageIconBUTTON addTarget:self
                         action:@selector(highlightSwitchButton)
               forControlEvents:UIControlEventTouchUpInside];
    
   ///\todo [_decoratorImageView.layer setMinificationFilter:kCAFilterTrilinear];
    
    static bool onceAd = false;
    
    if(!onceAd)
    {
        rect = _adBanner.frame;
        onceAd=true;
    }
    
    [self bannerView:_adBanner didFailToReceiveAdWithError:nil];

    if(isIpad())
    {
        UIFont* middleRowFont = [UIFont fontWithName:@"BIG JOHN" size:20];;
        _backgroundSwitchButton.titleLabel.font = middleRowFont;
        _captionButton.titleLabel.font = middleRowFont;
        _decorateButton.titleLabel.font = middleRowFont;
    }
    else
    {
        UIFont* middleRowFont = [UIFont fontWithName:@"BIG JOHN" size:12];
        _backgroundSwitchButton.titleLabel.font = middleRowFont;
        _captionButton.titleLabel.font = middleRowFont;
        _decorateButton.titleLabel.font = middleRowFont;
    }
    
    self.backgroundImageView.backgroundColor = appState.currentColor;

    static bool once = false;
    
    if(!once)
    {
    //save full size of preview image imagesquare that gets inset against the background.
    //this is used as our target when we scale up and down
        appState.originalSizePreview = self.previewImage.frame;
        once=true;
    }
    
    typedef void (*MyFunc2)(id, SEL);
    
    SEL shareMailSel = @selector(shareMail);
    MyFunc2 shareMailImpl = (MyFunc2)[self methodForSelector:shareMailSel];
    
    std::function<void (void) > shareMailPtr = std::bind(shareMailImpl, self, shareMailSel);
    
    SEL shareFacebookSel = @selector(shareFacebook);
    MyFunc2 shareFacebookImpl = (MyFunc2)[self methodForSelector:shareFacebookSel];
    std::function<void (void) > shareFacebookPtr = std::bind(shareFacebookImpl, self, shareFacebookSel);
    
    SEL shareTwitterSel = @selector(shareTwitter);
    MyFunc2 shareTwitterImpl = (MyFunc2)[self methodForSelector:shareTwitterSel];
    std::function<void (void) > shareTwitterPtr = std::bind(shareTwitterImpl, self, shareTwitterSel);
    
    SEL shareInstagramSel = @selector(shareInstagram);
    MyFunc2 shareInstagramImpl = (MyFunc2)[self methodForSelector:shareInstagramSel];
    std::function<void (void) > shareInstagramPtr = std::bind(shareInstagramImpl, self, shareInstagramSel);
    
    auto saveLibLambda = []()
    {
        savePhotoToAlbum(SystemImageIOS(appState.letterboxedImage), "PhotoApplication", successfulSaveLibrary);
    };
    
    _actionSheetSocial.clear();
    _actionSheetSocial.title = "Share or Save";
    _actionSheetSocial.push_back(ActionSheetEntry("Share on Facebook", shareFacebookPtr));
    _actionSheetSocial.push_back(ActionSheetEntry("Share on Twitter", shareTwitterPtr));
    _actionSheetSocial.push_back(ActionSheetEntry("Share on Instagram", shareInstagramPtr));
    _actionSheetSocial.push_back(ActionSheetEntry("Save to Library", saveLibLambda));
    
    if(emailSupported())
    {
        _actionSheetSocial.push_back(ActionSheetEntry("E-Mail", shareMailPtr));
    }
    
    _actionSheetSocial.push_back(ActionSheetEntry("Cancel", doNothing,CANCEL_ENTRY));

    auto takePhotoLambda = [self](){[self newPhoto];};
    auto getPhotoLambda = [self](){[self getPhoto];};
    
    auto getPhotoCurrentDrawingLambda = [self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Import a photo first!", "");
            return;
        }
        
        generateLetterboxed();
        
        importImage([self resolutionCap: SystemImageIOS(appState.letterboxedImage) withDimension:PhotoApplication_IMAGE_CAP]);
        
        if(renderer)renderer->clear();
        updateRendererPreviews();
        
        appState.photoCaption = (NSString*)defaultPhotoCaption;
        [self.captionButton setTitle:@"Caption" forState:UIControlStateNormal];
        
        UIColor* blackCol = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        if(CGColorEqualToColor(appState.currentColor.CGColor, blackCol.CGColor))
        {
            appState.currentColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        }
        else
        {
            appState.currentColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        }
        
        if(appState.colorSliderController)
        {
            const CGFloat *components = CGColorGetComponents(appState.currentColor.CGColor);
            
            appState.colorSliderController.redSlider.value = components[0];
            appState.colorSliderController.greenSlider.value = components[1];
            appState.colorSliderController.blueSlider.value = components[2];
        }
        
        appState.setBackgroundImagePreview(nil);
       
        ///\todo this may not be necessary to reset the photo filter background
        decoratorState.currentPhotoFilterBackground=0;
        decoratorState.seamlessEnabled=false;
        decoratorState.currentPhotoFilterImage=0;
        ///\todo
        
        appState.backgroundImageRaw  = appState.backgroundProcessed = nil;
        
        [self setBorderCenter];
        
        if(appState.imageSliderController)
        {
            [appState.imageSliderController updateSwatch];
        }
    };
    
    ///\todo when we add decorator features there needs to be a "revert decorations" option that gets called here for every decoration type
    auto startOverLambda = [self]()
    {
        appState.myImage = appState.importedImage = nil;
        
        appState.setForegroundImagePreview(appState.defaultBackground);
        
        appState.translateParameterX = 0.0f;
        appState.translateParameterY = 0.0f;
        appState.scaleParameter = 1.0f;
        appState.borderScale = 0.0f;
        
        appState.currentColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        
        decoratorState.currentPhotoFilterImage=0;
        decoratorState.currentPhotoFilterBackground=0;
        decoratorState.seamlessEnabled=false;
        ///\todo
        
        appState.backgroundImageRaw = nil;
        appState.setBackgroundImage(nil);
        
        //reset caption
        appState.photoCaption = (NSString*)defaultPhotoCaption;
        
        if(appState.imageSliderController)
        {
            [appState.imageSliderController resetSliders];
            appState.imageSliderController.borderSlider.value = appState.borderScale;
            [appState.imageSliderController updateSwatch];
        }
        
        if(appState.colorSliderController)
        {
            [appState.colorSliderController resetColorSliders];
            appState.colorSliderController.borderSlider.value = appState.borderScale;
        }
        
        if(appState.photoCaption.length && ![appState.photoCaption isEqualToString : (NSString*)defaultPhotoCaption])
        {
            NSString* photoCaption2 = makeShortenedCaption(appState.photoCaption);
            [self.captionButton setTitle:photoCaption2 forState:UIControlStateNormal];
        }
        else
        {
            [self.captionButton setTitle:@"Caption" forState:UIControlStateNormal];
        }

        if(renderer)renderer->clear();
        updateRendererPreviews();
        
        self.decoratorImageView.image=nil;
        decoratorState.decoratorImage = nil;
        
        //update preview screen border
        updateConstraintsPreview();
    };
    
    auto promptStartOverLambda = [startOverLambda]()
    {
        static PopupBox box;
        box.clear();
        box.message = "This will clear your work and start over.  Proceed?";
        box.title = "Start Over?";
        
        box.push_back(PopupBoxEntry("Yes", startOverLambda));
        box.push_back(PopupBoxEntry("No", doNothing));
        
        box.display();

    };
    
    
    _actionSheetGet.clear();
    _actionSheetGet.title= "Photo Options";
    _actionSheetGet.push_back(ActionSheetEntry("Take New Photo", takePhotoLambda));
    _actionSheetGet.push_back(ActionSheetEntry("Get Photo From Library", getPhotoLambda));
    _actionSheetGet.push_back(ActionSheetEntry("New From Current Picture", getPhotoCurrentDrawingLambda));
    _actionSheetGet.push_back(ActionSheetEntry("Start Over", promptStartOverLambda));
    _actionSheetGet.push_back(ActionSheetEntry("Cancel", doNothing, CANCEL_ENTRY));
    
    auto colorLambda = [self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        [self.childViewController swapToColorVC];
        appState.backgroundPanelIsImage=false;
        [_backgroundSwitchButton setTitle:@"Image" forState:UIControlStateNormal];
        _colorImageIconView.image = [UIImage imageNamed:@"Image.png"];
        
        bool noBorder = (appState.borderScale == 0.0f);
        bool isSquare = imageIsSquare();
        
        if(noBorder && isSquare)
        {
            appState.borderScale = 0.50f;
            appState.imageSliderController.borderSlider.value = appState.borderScale;
            updateConstraintsPreview();
        }
        
        if(appState.colorSliderController)
        {
           appState.colorSliderController.borderSlider.value = appState.borderScale;
        }
    };
    
    auto imageLambda = [self]()
    {
        [self.childViewController swapToImageVC];
        appState.backgroundPanelIsImage=true;
        [_backgroundSwitchButton setTitle:@"Color" forState:UIControlStateNormal];
        _colorImageIconView.image = [UIImage imageNamed:@"Color.png"];
    };
    
    auto cameraLambda = [imageLambda,self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        appState.imageLaunchOptions = CAMERA_BACKGROUND;
        imageLambda();
    };
    
    auto libraryLambda = [imageLambda,self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        appState.imageLaunchOptions = LIBRARY_BACKGROUND;
        imageLambda();
    };
    

    auto builtInLambda = [imageLambda,self]()
    {
        if(appState.isStartState())
        {
            popupMessage("Load a photo before adding a background!", "");
            return;
        }
        
        appState.imageLaunchOptions = BUILT_IN_BACKGROUND;
        imageLambda();
    };
    
    
    auto currentImageLambda = [imageLambda,self]() //background from current picture
    {
        if(appState.isStartState())
        {
            popupMessage("Import a photo first!", "");
            return;
        }
        
        //we're about to set the background from the letterboxed image, so we can do this with no ill effects.  We're doing this so that the letterboxed image doesn't generate incorrectly if we're using a color.  We have the conditional so that we don't letterbox WIHTOUT the image background if we actually have one.
        
        if(appState.m_previewImageBackground.image == nil)
        {
            appState.backgroundImageRaw  = appState.backgroundProcessed = nil;
            ///\todo
        }
        
        appState.imageLaunchOptions = CURRENT_PHOTO_BACKGROUND;
        imageLambda();
    };
    
    _frameActionSheet.clear();
    _frameActionSheet.title = "Border Type";
    _frameActionSheet.push_back(ActionSheetEntry("Solid Color",colorLambda));
    _frameActionSheet.push_back(ActionSheetEntry("Background Packs",builtInLambda));
    _frameActionSheet.push_back(ActionSheetEntry("Image From Library",libraryLambda));
    _frameActionSheet.push_back(ActionSheetEntry("Image From Camera",cameraLambda));
    _frameActionSheet.push_back(ActionSheetEntry("Border From Current Image",currentImageLambda));
    _frameActionSheet.push_back(ActionSheetEntry("Cancel", doNothing, CANCEL_ENTRY));
    
    appState.m_decoratorImageView = self.decoratorImageView;
    appState.m_previewImage = self.previewImage;
    appState.m_previewImageBackground = self.backgroundImageView;
    
    appState.setForegroundImagePreview(appState.defaultBackground);
    
    updateConstraintsPreview();
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)mailComposeController:
    (MFMailComposeViewController*)controller didFinishWithResult:
    (MFMailComposeResult)result error:
    (NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            popupMessage("Draft saved to Mail App on your device","");
            break;
        case MFMailComposeResultSent:
            popupMessage("Your picture has been sent.", "");
            break;
        case MFMailComposeResultFailed:
            popupMessage("Failed to send e-mail");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
