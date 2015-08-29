//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  BackgroundEffectsViewController.h
//

#import <UIKit/UIKit.h>

@interface BackgroundEffectsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *effectsScroller;
@property (weak, nonatomic) IBOutlet UISwitch *seamlessToggle;
@end
