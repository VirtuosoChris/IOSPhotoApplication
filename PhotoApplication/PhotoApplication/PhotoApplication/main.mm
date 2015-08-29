//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  main.m
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "PhotoApplication.h"
#import "GLESContext.h"
#import "PhotoApplicationOpenGL.h"

int main(int argc, char * argv[])
{
    @autoreleasepool
    {
        try
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        catch(const std::runtime_error& e)
        {
            std::cout<<e.what()<<std::endl;
        }
    }
}
