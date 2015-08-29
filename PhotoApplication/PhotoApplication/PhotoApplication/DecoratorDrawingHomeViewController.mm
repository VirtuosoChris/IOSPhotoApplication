//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  DecoratorDrawingHomeViewController.m
//

#import "DecoratorDrawingHomeViewController.h"
#import "PhotoApplication.h"
#import "PhotoApplicationOpenGL.h"
#import "PopupMessage.h"

@interface DecoratorDrawingHomeViewController ()

@end

@implementation DecoratorDrawingHomeViewController

- (IBAction)myClickEvent:(id)sender event:(id)event
{
   /* NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: self.colorScroller];
    */
    
    CGPoint currentTouchPosition = [sender convertPoint:CGPointZero toView:self.colorScroller];
    
    NSIndexPath *indexPath = [self.colorScroller indexPathForItemAtPoint: currentTouchPosition];
    
    if(!indexPath)return;
    
    const CGFloat *components = CGColorGetComponents(appState.colors[indexPath.row].CGColor);
    
    decoratorState.penR = self.redSlider.value = components[0];
    decoratorState.penG = self.greenSlider.value = components[1];
    decoratorState.penB = self.blueSlider.value = components[2];
    
    [self setCurrentColorSquareColor: [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0] ];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIButton *recipeImageView = (UIButton *)[cell viewWithTag:100];
    
    [recipeImageView  addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    unsigned char imgWidth=1;
    
    unsigned char* dataIn= (new unsigned char[imgWidth*imgWidth*4]);
    
    UIColor* col = appState.colors[indexPath.row];
    
    const CGFloat *components = CGColorGetComponents(col.CGColor);
    
    dataIn[0] = 255*components[0];
    dataIn[1] = 255*components[1];
    dataIn[2] = 255*components[2];
    dataIn[3] = 255u;
    
    SystemImage sysImg(dataIn, imgWidth,imgWidth);
    
    UIImage* colorSquare = toUIImage(sysImg);
    
    delete[] dataIn;
    
    [recipeImageView setBackgroundImage:colorSquare forState:UIControlStateNormal];
    
    return cell;
}


///button to clear all drawing
- (IBAction)erasePressed:(id)sender
{
    
    static PopupBox box;
    box.clear();
    box.message = "This will clear all drawing from your picture.  Proceed?";
    box.title = "Clear drawing?";
    
    auto doNothing = [](){};
    auto startOverLambda = []()
    {
        renderer->clear();
        updateRendererPreviews();
    };
    
    decoratorState.decoratorImage= nil;
    
    box.push_back(PopupBoxEntry("Yes", startOverLambda));
    box.push_back(PopupBoxEntry("No", doNothing));
    
    box.display();

}


-(void) setInstructionLabelText
{
    if(decoratorState.eraserEnabled)
    {
        _instructionLabel.text = @"Touch Preview Square To Erase";
    }
    else
    {
        _instructionLabel.text = @"Touch Preview Square To Draw";
    }
}


- (IBAction)eraserTogglePressed:(id)sender
{
    decoratorState.eraserEnabled = !decoratorState.eraserEnabled;
    [_eraserToggleButton setTitle: decoratorState.eraserEnabled ? @"Use Pen" : @"Use Eraser"
                                                                               forState:UIControlStateNormal];
    [self setInstructionLabelText];
}

- (IBAction)currentColorPressed:(id)sender
{    
    if(appState.decoratorPanel)
    {
        [appState.decoratorPanel pushBottomPanelContentStack:@"DecoratorDrawingColorSegue"];
    }
}


- (void) setCurrentColorSquareColor : (UIColor*) color
{
    unsigned char imgWidth=1;

    unsigned char* dataIn= (new unsigned char[imgWidth*imgWidth*4]);

    const CGFloat *components = CGColorGetComponents(color.CGColor);

    dataIn[0] = 255*components[0];
    dataIn[1] = 255*components[1];
    dataIn[2] = 255*components[2];
    dataIn[3] = 255u;

    SystemImage sysImg(dataIn, imgWidth,imgWidth);

    UIImage* colorSquare = toUIImage(sysImg);

    delete[] dataIn;

    [_currentColorSquare setBackgroundImage:colorSquare forState:UIControlStateNormal];
    
    _colorSquareIpad.image = colorSquare;
    
    _colorBar.backgroundColor = [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    _penColorLabel.font = [UIFont fontWithName:@"Colaborate-Bold" size:14];
    _titleLabel.font = [UIFont fontWithName:@"BIG JOHN" size:18];

    _penSlider.minimumValue = 40.0f;
    _penSlider.maximumValue = 110.0f;
    
    UIFont* font16 = [UIFont fontWithName:@"Colaborate-Medium" size:12];
    UIFont* font24 = [UIFont fontWithName:@"Colaborate-Medium" size:18];
    

    _currentColorButton.titleLabel.font = font24;
    _eraseButton.titleLabel.font = font24;
    _eraserToggleButton.titleLabel.font = font24;
    
    _currentColorLabelIpad.font = font24;
    
    if(!isIpad())
    {
        _penLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
        _redLabel.font = font16;
        _greenLabel.font = font16;
        _blueLabel.font = font16;
    
        _instructionLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:14];
    }
    else
    {
        _penLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
        _redLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
        _greenLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
        _blueLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
        
        _instructionLabel.font = [UIFont fontWithName:@"Colaborate-Light" size:16];
    }
    
      _colorBar.backgroundColor = [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0];
    
    [self setInstructionLabelText];
   
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _redSlider.value = decoratorState.penR;
    _greenSlider.value = decoratorState.penG;
    _blueSlider.value = decoratorState.penB;
    _penSlider.value = decoratorState.penSize;
    
    ///\todo abstract this
    auto drawPtLambdaBegin = [](float x, float y)
    {
        decoratorState.lastPenX = x;
        decoratorState.lastPenY = y;
        renderer->lastOffset = Eigen::Vector2f(0.0,0.0);
        
        //float frameWidth = PhotoApplication_SQUARE_DIM, frameHeight = PhotoApplication_SQUARE_DIM;
        
        //pass in the normalized offset vector to the shader
        
        //the size should be the size of the pen in clip coords.  penSize is in pixels, so do the appropriate conversions
        //note that this scaled vector is HALF the pen size since it goes from the center to the edge.
        
        //renderer->lastOffset = ( (penLocation[1] - lastPenLocation[1]),(lastPenLocation[0] - penLocation[0]));
        
        //renderer->lastOffset[1] *= (.5f * decoratorState.penSize / frameHeight);
        //renderer->lastOffset[0] *= (.5f * decoratorState.penSize / frameWidth);
    };
    
    auto drawPtLambda = [](float x, float y)
    {
        //if( (decoratorState.lastPenX != x) && (decoratorState.lastPenY != y))
        {
            renderer->renderPainting(x,y);
            renderer->renderPreview();
            
            decoratorState.lastPenX = x;
            decoratorState.lastPenY = y;
        }
    };
    
    auto drawPtLambdaEnd = [](float x, float y)
    {
        renderer->renderPainting(x,y);
        renderer->renderPreview();
        
        decoratorState.lastPenX = x;
        decoratorState.lastPenY = y;
        renderer->lastOffset = Eigen::Vector2f(0.0,0.0);
    };
    
    InputHandler input;
    input.touchBegin = drawPtLambdaBegin;
    input.touchMove = drawPtLambda;
    input.touchEnd = drawPtLambdaEnd;
    
    std::stack<InputHandler>& stack =appState.decoratorVC.glView->inputHandler;
    
    stack.push(input);
    
    [self setCurrentColorSquareColor: [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0] ];
    
    [_eraserToggleButton setTitle: decoratorState.eraserEnabled ? @"Use Pen" : @"Use Eraser"
                         forState:UIControlStateNormal];
    
   
    [self setInstructionLabelText];
    
    if(isIpad())
    {
        [_colorScroller setFrame:CGRectMake(0, 53, 733, 50)];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    appState.decoratorVC.glView->inputHandler.pop();
}


- (IBAction)redSliderMoved:(id)sender
{
    decoratorState.penR = _redSlider.value;
    
    [self setCurrentColorSquareColor: [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0] ];
}


- (IBAction)greenSliderMoved:(id)sender
{
    decoratorState.penG = _greenSlider.value;
    
    [self setCurrentColorSquareColor: [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0] ];
}


- (IBAction)blueSliderMoved:(id)sender
{
    decoratorState.penB = _blueSlider.value;
    
    [self setCurrentColorSquareColor: [UIColor colorWithRed:decoratorState.penR green:decoratorState.penG blue:decoratorState.penB alpha:1.0] ];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return appState.colors.size();
}


- (IBAction)penSliderMoved:(id)sender
{
    decoratorState.penSize = _penSlider.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
