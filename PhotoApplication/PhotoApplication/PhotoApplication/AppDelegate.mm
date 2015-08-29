//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

///
///@file AppDelegate.m
///@brief all of the global application state and letterbox renderer is declared here
///


#import "AppDelegate.h"
#import "PhotoApplication.h"
#include "GLESContext.h"
#include <Image.h>
#include <SystemImage.h>
#include <iosHelpers.h>
#include <vector>
#import "PhotoApplicationOpenGL.h"


#include <SystemImage.h>

GLESContext context; ///< OpenGL ES Context

@implementation AppDelegate


bool fromAppExtension = false;

 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
     NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
     NSLog(@"URL scheme:%@", [url scheme]);
     NSLog(@"URL query: %@", [url query]);
     
     if([[url query] isEqualToString: @"photoextension"])
     {
         //reset all app state
         //fromAppExtension=true;
         //appState = GlobalAppState();
         //decoratorState = GlobalDecoratorState();
         //panelContentIdentifierStack = std::stack<NSString*>();
         //currentPanelIdentifier = @"DecoratorHomeSegue";
         
         loadAutoSaveExtension();
     }
     
     return YES;
 }


- (void)applicationWillResignActive:(UIApplication *)application
{
    writeAutoSave();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   // writeAutoSave();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    extern GLESContext context;
    context = GLESContext(GLESContext::GL_ES_2_0);
    
    //create the image effects; must be done prior to loading the autosave.
    loadEffects();
    
    if(!renderer.get())
    {
        context.bind();
        renderer.reset(new OpenGLRenderer());
    }
    
    if(!fromAppExtension)
    {
        loadAutoSave();
    }
    else
    {
        loadAutoSaveExtension();
    }
    
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480)
    {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"iPhoneSmallStoryboard" bundle:nil];
        UIViewController *initViewController = [storyBoard instantiateInitialViewController];
        [self.window setRootViewController:initViewController];
    }
    
    return YES;
}

@end
