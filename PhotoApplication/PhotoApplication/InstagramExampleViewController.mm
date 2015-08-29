//
//  InstagramExampleViewController.m
//

#import "InstagramExampleViewController.h"
#import <iosHelpers.h>

@interface InstagramExampleViewController ()
@end


@implementation InstagramExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* platformString = nil;
    
    if(isIpad())
    {
        platformString = @"ipad";
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height <= 480.0f)
        {
            platformString = @"iphone4s";
        }
        else
        {
            platformString = @"iphone5";
        }
    }
    
    NSString* imageFile = [ NSString stringWithFormat:@"TutorialJPG/%@/InstagramTutorial.jpg",platformString ];
    _imageView.image = [UIImage imageNamed:imageFile];
}


-(BOOL) prefersStatusBarHidden
{
    return  YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)escPressed:(id)sender
{
    if(self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
