//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplicationShaders.h
//

#ifndef _PhotoApplicationShaders_h
#define _PhotoApplicationShaders_h


static const char* drawVertexShader =

"precision highp float;\n"
"attribute vec3 position;\n"
"uniform float pointSize;\n"
"\n"
"void main(){\n"
"    gl_PointSize = pointSize;\n"
"    gl_Position = vec4((position.xy * vec2(2.0)) - vec2(1.0), 0.0,1.0);\n"
"\n"
"}\n";


static const char* drawFragmentShader =

"precision highp float;\n"
"uniform vec4 color;\n"
"\n"
"void main()\n"
"{\n"
"    gl_FragColor = color;\n"
"}\n";

/*
static const char* previewFragmentShader =

"precision highp float;\n"
"uniform sampler2D picture;\n"
"uniform sampler2D decoration;\n"
"varying vec2 texcoords;\n"
"\n"
"void main()\n"
"{\n"
"    vec4 lookup = texture2D(picture, vec2(texcoords.s, 1.0 - texcoords.t) );\n"
"    vec4 lookup2 = texture2D(decoration, texcoords);\n"
"    vec3 color = (1.0 - lookup2.a) * lookup.rgb + lookup2.a * lookup2.rgb;\n"
"    gl_FragColor = vec4(color, 1.0);\n"
"}\n";
*/

static const char* previewFragmentShader =
"precision highp float;\n"
"uniform sampler2D decoration;\n"
"varying vec2 texcoords;\n"
"uniform bool premultiplyAlpha;\n"
"\n"
"void main()\n"
"{\n"
"    vec4 lookup2 = texture2D(decoration, texcoords);\n"
"    gl_FragColor = lookup2;\n"
"    //premultiply alpha to work with ios compositing\n"
"    if(premultiplyAlpha){\n"
"    gl_FragColor.rgb *= gl_FragColor.a;\n"
"    }\n"
"}\n";


static const char* previewVertexShader =

"precision highp float;\n"
"\n"
"attribute vec3 position;\n"
"attribute vec2 texcoord;\n"
"\n"
"varying vec2 texcoords;\n"
"\n"
"void main(){\n"
"    texcoords = texcoord;\n"
"    gl_Position = vec4(position,1.0);\n"
"\n"
"}\n";



#endif
