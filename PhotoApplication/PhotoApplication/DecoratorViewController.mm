//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorViewController.m
//

#import "DecoratorViewController.h"
#import "DecoratorPanelViewController.h"
#import <iosHelpers.h>
#import "PhotoApplication.h"
#import "GLViewIOS.h"
#import "PhotoApplicationOpenGL.h"
#import "GLESContext.h"
#import <Timer.h>
#import <PopupMessage.h>

extern GLESContext context;

@interface DecoratorViewController ()

@end

@implementation DecoratorViewController

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


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self decoratorPanelUpdated];
    
    renderer->renderPreview();
    
    updateConstraintsPreview();
    
    appState.isDecorating = true;
}


- (void) viewWillDisappear:(BOOL)animated
{
    Timer t;
    t.reset();
    
   [super viewWillDisappear:animated];
    
    //[_glView setOpaque:YES];
    decoratorState.decoratorImage = toUIImage(renderer->extractDrawingImageSmooth());
    //[_glView setOpaque:NO];
    
    double elapsed  = t.getDelta();
    
    //std::stringstream sstr;
    //sstr<<"TIME TO CAPTURE OPENGL FRAME IS "<<elapsed<<" seconds"<<std::endl;
    
    //popupMessage(sstr.str());

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    static bool onceAd = false;
    
    if(!onceAd)
    {
        rect = _adBanner.frame;
        onceAd=true;
    }
    
    [self bannerView:_adBanner didFailToReceiveAdWithError:nil];
    
    UIFont* middleRowFont  = nil;
   
    middleRowFont = isIpad() ? [UIFont fontWithName:@"BIG JOHN" size:20] : [UIFont fontWithName:@"BIG JOHN" size:12];
    
    _homeButton.titleLabel.font = middleRowFont;
    _backButton.titleLabel.font = middleRowFont;
    _letterboxButton.titleLabel.font = middleRowFont;
    
    appState.decoratorVC = self;
    context.bind();
    
    _glView  = [[GLViewIOS alloc] initWithFrame:_glView.frame];
    [_glView setOpaque:NO];
    [_glView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f]];
    //_glView.layer.compositingFilter = appState.m_previewImage.layer.compositingFilter;
    
    [self.view addSubview:_glView];
    
    appState.m_previewImageDecorator = _previewImage;
    appState.m_previewImageBackgroundDecorator = _backgroundImageView;
    
    
    appState.setForegroundImagePreview(appState.myImage);
    appState.setBackgroundImagePreview(appState.m_previewImageBackground.image); //since we're loading for the first time we'll pull our image from whatever the background image of the preview is on the main screen.  if nil, will set to color
    
    if(!renderer.get())
    {
        renderer.reset(new OpenGLRenderer());
    
        if(decoratorState.decoratorImage)
        {
            renderer->setDecoratorTexture(decoratorState.decoratorImage);
        }
    }
    renderer->createWindowRenderbuffer(_glView);
    
    static bool once = false;
    
    if(!once)
    {
        //save full size of preview image imagesquare that gets inset against the background.
        //this is used as our target when we scale up and down
        appState.originalSizePreviewDecorate = self.previewImage.frame;
        once=true;
    }
    
    updateConstraintsPreview();
    
    [_backIconBUTTON addTarget:self
                 action:@selector(backButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [_optionsIconBUTTON addTarget:self
                        action:@selector(homeButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [_letterboxIconBUTTON addTarget:self
                        action:@selector(letterboxButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    
    [_backIconBUTTON addTarget:self
                        action:@selector(backButtonHighlight)
              forControlEvents:UIControlEventTouchDown];
    
    [_optionsIconBUTTON addTarget:self
                           action:@selector(homeButtonHighlight)
                 forControlEvents:UIControlEventTouchDown];
    
    [_letterboxIconBUTTON addTarget:self
                         action:@selector(letterboxButtonHighlight)
               forControlEvents:UIControlEventTouchDown];
    
    
    
}

-(void) letterboxButtonHighlight
{
    [_letterboxButton setHighlighted:YES];
}

-(void) homeButtonHighlight
{
    [_homeButton setHighlighted:YES];
}

-(void) backButtonHighlight
{
    [_backButton setHighlighted:YES];
}


- (IBAction)backButtonPressed:(id)sender
{
    [_backButton setHighlighted:NO];
    
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel popBottomPanelContentStack];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [_homeButton setHighlighted:NO];
    
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel panelHome];
    }
}

- (IBAction)letterboxButtonPressed:(id)sender
{
    [_letterboxButton setHighlighted:NO];
    
    appState.isDecorating = false;
    
    if(self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void) decoratorPanelUpdated
{
    if(!appState.decoratorPanel)return;
    
    bool stackEmpty = panelContentIdentifierStack.empty();
    _homeButton.enabled = !stackEmpty;
    _homeButton.hidden = stackEmpty;
    _optionsIconView.hidden=stackEmpty;
    
    _backButton.enabled = !stackEmpty;
    _backButton.hidden = stackEmpty;
    _backIconView.hidden = stackEmpty;
}


///The storyboard has an "embed" segue to display the bottom panel of the view controller.
///We don't normally need to do anything about this but we are "hijacking" the message when this segue is fired
///in order to get a pointer to the bottom panel view controller
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    
    if ([segueName isEqualToString: @"DecoratorPanelEmbedSegue"])
    {
        _bottomPanelViewController = (DecoratorPanelViewController*) [segue destinationViewController];
    }
}

@end
