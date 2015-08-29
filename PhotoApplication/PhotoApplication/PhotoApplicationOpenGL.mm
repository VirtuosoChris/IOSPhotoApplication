//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplicationOpenGL.m
//

#import <Foundation/Foundation.h>
#import "PhotoApplicationShaders.h"
#import "PhotoApplicationOpenGL.h"
#include "Quad.h"
#include "GpuMesh.h"
#include "Mesh.h"


std::shared_ptr<OpenGLRenderer> renderer;

using namespace Virtuoso;
void screenQuad()
{
    static Virtuoso::Quad q;
    static Virtuoso::GPUMesh quad(q);
    
    quad.push();
    
}
