//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  TutorialViewController.m
//

#import "TutorialViewController.h"
#import "iosHelpers.h"
#import "PhotoApplication.h"

@interface TutorialViewController ()
@end


@implementation TutorialViewController


const float secondsFadeTransition = .50f;

-(void) timerFired
{
    [self setupDisplayLink];
}


-(void) stopTimer
{
    [_myTimer invalidate];
    _myTimer = nil;
}


-(void) scheduleTimer
{
    if(_myTimer)
    {
        [self stopTimer];
    }
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.50 target: self selector: @selector(timerFired) userInfo: nil repeats: NO];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self activateUI];
}


-(void) activateUI
{
    if(_displayLink)
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    [self scheduleTimer];
    self.alpha = 1.0f;
    [self fadeAlpha:1.0f];
    [self activateButtons];
}


- (void)tapOnView:(UITapGestureRecognizer *)sender
{
    [self activateUI];
}


- (void) runDisplayLink:(CADisplayLink *)sender
{
    if(!_startDL)
    {
        _startDL = true;
        _firstTime = sender.timestamp;
    }
    
    CFTimeInterval elapsed = (sender.timestamp - self.firstTime);
    self.alpha = 1.0f - (elapsed / secondsFadeTransition);

    if(self.alpha < 1.0f)
    {
        [self deactivateButtons];
    }
    
    if(self.alpha <= 0.0)
    {
        [self.displayLink invalidate];
        self.displayLink = nil; //don't need to continuously poll if we're faded out
    }
    
    [self fadeAlpha:self.alpha];
}


-(void) setButtonsActive : (bool) active
{
    _prevButton.enabled = active;
    _nextButton.enabled = active;
    _escButton.enabled = active;
}


- (void)setupDisplayLink
{
    _startDL = false;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


-(void) deactivateButtons
{
    [self setButtonsActive: NO];
}


-(void) activateButtons
{
    [self setButtonsActive:YES];
}


-(void) initializeDefaultAlphas
{
    _defAlphaButtonBck = _xButtonBck.alpha;
    _defAlphaSlideBkr = _slideBkr.alpha;
    _defAlphaLeftBck = _leftBck.alpha;
    _defAlphaSlideLabel = _slideLabel.alpha;
    _defAlphaRightBck = _rightBck.alpha;
    _defAlphaPrevButton = _prevButton.alpha;
    _defAlphaEscButton = _escButton.alpha;
    _defAlphaNextButton = _nextButton.alpha;
}


-(void) fadeAlpha : (float) lerpVal
{
    _xButtonBck.alpha = lerpVal * (_defAlphaButtonBck);
    _slideBkr.alpha = lerpVal * _defAlphaSlideBkr;
    _leftBck.alpha = lerpVal * _defAlphaLeftBck;
    _slideLabel.alpha = lerpVal * _defAlphaSlideLabel;
    _rightBck.alpha = lerpVal * _defAlphaRightBck;
    _prevButton.alpha = lerpVal * _defAlphaPrevButton;
    _escButton.alpha = lerpVal * _defAlphaEscButton;
    _nextButton.alpha = lerpVal * _defAlphaNextButton;
}


-(void) nextImage
{
    unsigned int numSlides = appState.numSlidesInTutorial;//isIpad()? 24 : 23;
    
    _currentSlide++;
    _currentSlide %= numSlides;
    
    _slideLabel.text = [NSString stringWithFormat:@"Slide %d of %d", _currentSlide+1, numSlides];

    NSString* imageFile = [self currentImageFile];
    NSString* imageFilePrev = [self prevImageFile];
    NSString* imageFileNext = [self nextImageFile];
    
    ((UIImageView*)[_imageViews objectAtIndex:0]).image = [UIImage imageNamed:imageFilePrev];
    ((UIImageView*)[_imageViews objectAtIndex:1]).image = [UIImage imageNamed:imageFile];
    ((UIImageView*)[_imageViews objectAtIndex:2]).image = [UIImage imageNamed:imageFileNext];
}


-(NSString*) nextImageFile
{
    unsigned int numSlides = appState.numSlidesInTutorial;//isIpad()? 24 : 23;
    
    unsigned int slideToFetch = (_currentSlide +1 ) % numSlides;
    NSString* imageFile = [ NSString stringWithFormat:@"TutorialJPG/%@/%@",_platformString, _fileArray[slideToFetch] ];
    
    return imageFile;
}


-(NSString*) currentImageFile
{
   return [NSString stringWithFormat:@"TutorialJPG/%@/%@",_platformString, _fileArray[_currentSlide]];
}


-(NSString*) prevImageFile
{
    unsigned int numSlides = appState.numSlidesInTutorial;//isIpad()? 24 : 23;
    
    unsigned int slideToFetch = _currentSlide ?  _currentSlide-1 :numSlides - 1;
    NSString* imageFile = [ NSString stringWithFormat:@"TutorialJPG/%@/%@",_platformString, _fileArray[slideToFetch] ];
    
    return imageFile;
}



-(void) prevImage
{
    unsigned int numSlides = appState.numSlidesInTutorial;//isIpad()? 24 : 23;
    
    _currentSlide = _currentSlide ? _currentSlide - 1 : numSlides - 1;
    
    NSString* imageFile = [self currentImageFile];
    NSString* imageFilePrev = [self prevImageFile];
    NSString* imageFileNext = [self nextImageFile];
    
    ((UIImageView*)[_imageViews objectAtIndex:0]).image = [UIImage imageNamed:imageFilePrev];
    ((UIImageView*)[_imageViews objectAtIndex:1]).image = [UIImage imageNamed:imageFile];
    ((UIImageView*)[_imageViews objectAtIndex:2]).image = [UIImage imageNamed:imageFileNext];
    
    _slideLabel.text = [NSString stringWithFormat:@"Slide %d of %d", _currentSlide+1, numSlides];
}


- (IBAction)prevButtonPressed:(id)sender
{
    [self prevImage];
    [self activateUI];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}


- (IBAction)nextPressed:(id)sender
{
    [self nextImage];
    [self activateUI];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self activateUI];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_imageScroller.contentOffset.x < _imageScroller.bounds.size.width)
    {
        [self prevImage];
    }
    else if(_imageScroller.contentOffset.x > _imageScroller.bounds.size.width)
    {
        [self nextImage];
    }
    
    _imageScroller.contentOffset = CGPointMake(_imageScroller.bounds.size.width, 0);
}


-(void) pickTutorialPlatform
{
    if(isIpad())
    {
        _platformString = @"ipad";
        //_fileArray = appState;
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height <= 480.0f)
        {
            _platformString = @"iphone4s";
          //  _fileArray = iphone4sfiles;
        }
        else
        {
            _platformString = @"iphone5";
           // _fileArray = iphone5files;
        }
    }
    
    _fileArray = appState.selectedTutorialSlidePaths;
}


-(void) initImageScroller
{
    NSString* imageFile = [self currentImageFile];
    NSString* imageFilePrev = [self prevImageFile];
    NSString* imageFileNext = [self nextImageFile];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFilePrev]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFile]];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileNext]];
    
    _imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, nil];
    _imageScroller.pagingEnabled = YES;
    _imageScroller.bounces = NO;
    
    CGRect cRect = _imageScroller.bounds;
    
    for (int i = 0; i < _imageViews.count; i++)
    {
        UIImageView *cView = [_imageViews objectAtIndex:i];
        cView.frame = cRect;
        [_imageScroller addSubview:cView];
        cRect.origin.x += cRect.size.width;
    }
    _imageScroller.contentSize = CGSizeMake(cRect.origin.x, _imageScroller.bounds.size.height);
    _imageScroller.contentOffset = CGPointMake(_imageScroller.bounds.size.width, 0);
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _alpha = 1.0f;
    _currentSlide = 0u;
    
    [self pickTutorialPlatform];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
   
    [self initImageScroller];
    
    unsigned int numSlides = appState.numSlidesInTutorial;//isIpad()? 24 : 23;
    
    
    _slideLabel.text = [NSString stringWithFormat:@"Slide %d of %d", 1, numSlides];
    
    [self initializeDefaultAlphas];
    
}


- (IBAction)escPressed:(id)sender
{
   /* if(self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }*/
    
    if(_displayLink)
    {
       [_displayLink invalidate];
        _displayLink=nil;
    }
    
    if(_myTimer)
    {
        [self stopTimer];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)prefersStatusBarHidden { return YES; }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
