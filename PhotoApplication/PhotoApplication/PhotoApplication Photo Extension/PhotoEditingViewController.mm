//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoEditingViewController.m
//  PhotoApplication Photo Extension
//

#import "PhotoEditingViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "iosHelpers.h"
#import "GetPhoto.h"
#import "SystemImageImplIos.h"
//#import <Photos/PHAdjustmentData.h>
#include <fstream>

#define PhotoApplication_SQUARE_DIM 2048
static const unsigned int PhotoApplication_VERSION = 200;

float minBorder = .5f;
float maxBorder = 1.0f;
const float minImageBackgroundScale = .25;
const float maxImageBackgroundScale = 1.750f;
float translateParameterX = 0.0f, translateParameterY = 0.0f;


GlobalAppState appState;
//GlobalDecoratorState decoratorState;

NSString* appExtensionPath()
{
    NSURL *groupURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       @"group.PhotoApplication"];
    
    NSString* toString = [groupURL path];
    
    NSLog(@"\nPATH TO SHARED DIR IS %@",toString);
    return toString;
}

///\todo apply to free extension also
void writeAutoSave()
{
    appExtensionPath();
    
    XMLPrinter printer(NULL);
    
    printer.OpenElement("PhotoApplicationSave");
    //XMLDocument doc;
    std::cout<<"LOGGING TO "<<NSStringToString(appExtensionPath())<<std::endl;
    
    NSString* xmlPath = [NSString stringWithFormat:@"%@/autosave.xml", appExtensionPath()];
    
    printer.PushAttribute("Version", PhotoApplication_VERSION);
    
    appState.save(printer);
    
    if(appState.importedImage)
    {
        NSString* myImagePath = [NSString stringWithFormat:@"%@/myImage.png", appExtensionPath()];
        SystemImageIOS myImage(appState.importedImage);
        
        myImage.writeToFile(NSStringToString(myImagePath));
        printer.PushAttribute("photoPath", "myImage.png");
    }
    
    if(appState.backgroundImageRaw)
    {
        printer.PushAttribute("backgroundPath","background.png");
        NSString* backgroundImagePath = [NSString stringWithFormat:@"%@/background.png", appExtensionPath()];
        SystemImageIOS backgroundImage(appState.backgroundImageRaw);
        backgroundImage.writeToFile(NSStringToString(backgroundImagePath));
    }
    
    printer.CloseElement();
    
    std::ofstream file(NSStringToString(xmlPath));
    file<<printer.CStr();
}


@interface PhotoEditingViewController () <PHContentEditingController>
@property (strong) PHContentEditingInput *input;
@end

@implementation PhotoEditingViewController



-(void) pictureLoaded : (SystemImage) img
{
    UIImage* imgU= nil;
    
    float maxDim = std::max(img.getWidth(), img.getHeight());
    
    if(maxDim <= 1024.0f)
    {
        imgU = toUIImage(img);
    }
    else
    {
        float downscale = 1024.0f  / maxDim;
        float newW = img.getWidth() * downscale;
        float newH = img.getHeight() * downscale;
        SystemImage img2 = resizedCopy(img, newW, newH);
        imgU= toUIImage(img2);
    }
    
    appState.backgroundImageRaw = imgU;
    _backgroundImageTiled = affineTile(SystemImageIOS(appState.backgroundImageRaw));
    
    
    float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
    
    SystemImage cropped = crop(_backgroundImageTiled, 0, 0, squareDim, squareDim);;
    _backgroundProcessed = toUIImage(cropped);
};



-(void) generateLetterboxed
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
    
    if(!_backgroundProcessed)
    {
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
        [(_backgroundProcessed) drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
    }
    
    [img drawInRect:CGRectMake(beginX,beginY,newW,newH)];
    
    _letterboxedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


-(void) transformImage
{
    if(appState.backgroundImageRaw)
    {
        float tx =  (appState.translateParameterX * appState.backgroundImageRaw.size.width) * appState.scaleParameter;
        float ty = (translateParameterY * appState.backgroundImageRaw.size.height) * appState.scaleParameter;
        
        ImageProcessingResult backgroundImageTiled2 = affineTransform(_backgroundImageTiled, appState.scaleParameter, 0.0f, 0.0f,appState.scaleParameter, tx, ty);
        
        float squareDim = std::min<float>(appState.backgroundImageRaw.size.width, appState.backgroundImageRaw.size.height); //was 612
        
        //SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
        SystemImage cropped = crop(backgroundImageTiled2, 0, 0, squareDim, squareDim);
        _backgroundProcessed = toUIImage(cropped);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _colors.push_back([UIColor colorWithRed:1.0f green:1.00f blue:1.00f alpha:1.0f]);
    _colors.push_back([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
    _colors.push_back([UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.0f]);
    _colors.push_back([UIColor colorWithRed:1.0f green:0.50f blue:0.50f alpha:1.0f]);
    _colors.push_back([UIColor redColor] );
    _colors.push_back([UIColor brownColor]);
    _colors.push_back([UIColor colorWithRed:1.0f green:0.90f blue:0.70f alpha:1.0f]);
    _colors.push_back([UIColor orangeColor]);
    _colors.push_back([UIColor yellowColor]);
    _colors.push_back([UIColor greenColor]);
    _colors.push_back([UIColor cyanColor]);
    _colors.push_back([UIColor blueColor]);
    _colors.push_back([UIColor purpleColor]);
    
    // Do any additional setup after loading the view.
    _selectedColor=1;
    _letterboxedImage = nil;
    _backgroundProcessed = nil;
    appState.borderScale = 0.0f;
    appState.currentColor = _colors[_selectedColor];
    appState.scaleParameter = minImageBackgroundScale;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colors.size();
}


- (IBAction)myClickEvent:(id)sender event:(id)event
{
   /* NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView: _colorScroller];
    */
    
    CGPoint currentTouchPosition = [sender convertPoint:CGPointZero toView:_colorScroller];
    
    NSIndexPath *indexPath = [_colorScroller indexPathForItemAtPoint: currentTouchPosition];
    
    if(!indexPath)return;
    
    [[_colorScroller cellForItemAtIndexPath: [NSIndexPath indexPathForRow:_selectedColor inSection:0]] setBackgroundColor: [UIColor clearColor] ];
    _selectedColor = (unsigned int)indexPath.row;
    [[_colorScroller cellForItemAtIndexPath:indexPath] setBackgroundColor: [UIColor whiteColor] ];
    
    appState.currentColor = _colors[indexPath.row];
    _backgroundProcessed = nil; ///clear out the image background
    
    [self generateLetterboxed];
    
    self.preview.image = _letterboxedImage;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(indexPath.row == _selectedColor)
    {
        [cell setBackgroundColor: [UIColor whiteColor] ];
    }
    else
    {
        [cell setBackgroundColor: [UIColor clearColor] ];
    }
    
    UIButton *recipeImageView = (UIButton *)[cell viewWithTag:100];
    
    [recipeImageView  addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    unsigned char imgWidth=1;
    
    unsigned char* dataIn= (new unsigned char[imgWidth*imgWidth*4]);
    
    UIColor* col = _colors[indexPath.row];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoPressed:(id)sender
{
    auto photoBackgroundLambda = [self](SystemImage img)
    {
        [self pictureLoaded:img];
        [self generateLetterboxed];
        _preview.image = _letterboxedImage;
        appState.backgroundImageRaw = toUIImage(img);
    };
    
    getPhotoFromLibrary(self,photoBackgroundLambda,false);
}


- (IBAction)tiledPressed:(id)sender
{
    auto tiledBackgroundLambda = [self](SystemImage img)
    {
        [self pictureLoaded:img];
        [self transformImage];
        [self generateLetterboxed];
        _preview.image = _letterboxedImage;
        appState.backgroundImageRaw = toUIImage(img);
    };
    
    getPhotoFromLibrary(self,tiledBackgroundLambda,false);
}


///@brief launch PhotoApplication
- (IBAction)launchPressed:(id)sender
{
    writeAutoSave();
    
    //NSString *customURL = @"PhotoApplication://";
    NSString *customURL = @"PhotoApplication://?photoextension";
    NSURL *url = [NSURL URLWithString:customURL];
    //[self.extensionContext openURL:url completionHandler: nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - PHContentEditingController

- (BOOL)canHandleAdjustmentData:(PHAdjustmentData *)adjustmentData {
    // Inspect the adjustmentData to determine whether your extension can work with past edits.
    // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
    return NO;
}

- (void)startContentEditingWithInput:(PHContentEditingInput *)contentEditingInput placeholderImage:(UIImage *)placeholderImage {
    // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
    // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
    // If you returned NO, the contentEditingInput has past edits "baked in".

    self.input = contentEditingInput;
    appState.myImage = placeholderImage;
    
    bool isSquare = ([appState.myImage size].width ==  [appState.myImage size].height);
    
    appState.borderScale =  isSquare? 0.50f : 0.0f;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self generateLetterboxed];
    self.preview.image = _letterboxedImage;
}


- (void)finishContentEditingWithCompletionHandler:(void (^)(PHContentEditingOutput *))completionHandler {
    // Update UI to reflect that editing has finished and output is being rendered.
    
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create editing output from the editing input.
        PHContentEditingOutput *output = [[PHContentEditingOutput alloc] initWithContentEditingInput:self.input];
        
        // Provide new adjustments and render output to given location.
          //  output.adjustmentData = nil;//[PHAdjustmentData initWithFormatIdentifier: @"com.mycompany.PhotoApplication.adjustment" formatVersion: @"1.0" data:nil];
            
            NSData* data = [NSData data];
            
            output.adjustmentData = [[PHAdjustmentData alloc] initWithFormatIdentifier:@"com.mycompany.PhotoApplication.adjustment" formatVersion:@"1.0" data:data];
            
        NSData *renderedJPEGData = UIImageJPEGRepresentation(_letterboxedImage,1.0f);;
        
        [renderedJPEGData writeToURL:output.renderedContentURL atomically:YES];
        
        // Call completion handler to commit edit to Photos.
        completionHandler(output);
        
        // Clean up temporary files, etc.
    });
}

- (BOOL)shouldShowCancelConfirmation {
    // Returns whether a confirmation to discard changes should be shown to the user on cancel.
    // (Typically, you should return YES if there are any unsaved changes.)
    return NO;
}

- (void)cancelContentEditing {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
}

@end
