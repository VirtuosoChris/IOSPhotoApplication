//
// Copyright 2015 Lumialis LLC
//
// Licensed under the TrackingTeam License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at https://tldrlegal.com/license/trackingteam-licence#fulltext
//

//
//  PhotoApplicationOpenGL.h
//

#ifndef _PhotoApplicationOpenGL_h
#define _PhotoApplicationOpenGL_h

#import <OpenGLES/ES2/gl.h>
#import <memory>
#import <GLTexture.h>
#import <GLShader.h>
#import <GLESContext.h>
#import <GLViewIOS.h>
#import "PhotoApplicationShaders.h"
#import <MultidimensionalArray.h>
#import <ImageProcessing.h>
#import <SystemImage.h>
#import "PhotoApplication.h"
#import <SystemImageImplIos.h>
#import <iosHelpers.h>
#import <Mesh.h>
#import <GPUMesh.h>

using namespace Virtuoso;
extern GLESContext context;

struct GLRendererState
{
    GLuint downsampleFramebuffer;
    GLTexture downsampleTexture;
    GLuint previewFramebuffer;
    GLuint drawingFramebuffer;
    GLuint mainRenderbuffer;
    GLTexture drawingBuffer;
    //GLTexture letterboxedTexture;
    GL::GLShader previewProg;
    GL::GLShader drawingProg;
    std::pair<GLint,GLint> mainRenderbufferDims;
    Eigen::Vector2f lastOffset;
};


void screenQuad();


///\todo hack
class GLESContext::IMPLEMENTATION
{
public:
    
    EAGLContext* context;
    
    IMPLEMENTATION(EAGLContext* contextIn):context(contextIn)
    {
    }
    
    IMPLEMENTATION():context(nil)
    {
    }
    
    operator bool ()
    {
        return context;
    }
};


inline void bindLocs(GL::GLShader& shader)
{
    glBindAttribLocation(shader.prog, 0, "position");
    glBindAttribLocation(shader.prog, 1, "texcoord");
    glLinkProgram(shader.prog);
}



class PointBuffer : public Mesh
{
public:
    PointBuffer(float x, float y)
    {
        Mesh::addAttribute("position",2);
        
        AttributeArray::Inserter<2> pos((*this)["position"]);
    
        Mesh::begin(1);
        
        pos.vertex({x,y});
        
        Mesh::end();
    
       /* Mesh::beginIndices(6);
    
        Mesh::insertIndices(0,1,2);
        Mesh::insertIndices(2,3,0);
    
        Mesh::endIndices();*/
    }
};



class LineBuffer : public Mesh
{
public:
    LineBuffer(float lastX, float lastY, float x, float y)
    {
        Mesh::addAttribute("position",2);
        
        AttributeArray::Inserter<2> pos((*this)["position"]);
        
        Mesh::begin(2);
        
        pos.vertex({lastX, lastY});
        pos.vertex({x,y});
        
        Mesh::end();
        
        /* Mesh::beginIndices(6);
         
         Mesh::insertIndices(0,1,2);
         Mesh::insertIndices(2,3,0);
         
         Mesh::endIndices();*/
    }
};



class OpenGLRenderer : public GLRendererState
{

public:
    
    OpenGLRenderer()
    {
        initializeRenderer();
    }
    
    
    void setDecoratorTexture(UIImage* img)
    {
        if(img)
        {
            glBindFramebuffer(GL_FRAMEBUFFER, drawingFramebuffer);
            
            SystemImageIOS iosImg(img);
            
            //drawingBuffer = systemImageToTexture(iosImg, true);
            
            systemImageToSubTexture(drawingBuffer, iosImg, true);
           
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, drawingBuffer.tex ,0);
            
            glViewport(0,0,PhotoApplication_SQUARE_DIM,PhotoApplication_SQUARE_DIM);
        }
    }
    
    /*void initializeLetterboxedTexture()
    {
        generateLetterboxed(false);
        
        SystemImageIOS iosImg(appState.letterboxedImage);
        
        ///\todo why is flip? temp fix in shader
        systemImageToSubTexture(letterboxedTexture,iosImg);
        
        glBindTexture(GL_TEXTURE_2D, letterboxedTexture.tex);
        
    
        glGenerateMipmap(GL_TEXTURE_2D);
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
        
        //letterboxedTexture = systemImageToTexture(iosImg);
    }*/
    
    
    void clear()
    {
        glClearColor(0,0,0,0);
        glBindFramebuffer(GL_FRAMEBUFFER, drawingFramebuffer);
        glViewport(0,0,PhotoApplication_SQUARE_DIM,PhotoApplication_SQUARE_DIM);
        glClear(GL_COLOR_BUFFER_BIT);
    }
    
    
    void renderPreview()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, previewFramebuffer);
        
        glViewport(0, 0, mainRenderbufferDims.first, mainRenderbufferDims.second);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        glDisable(GL_BLEND);
        
        previewProg.bind();
 //       previewProg.setTexture("picture", 0);
//        previewProg.setTexture("decoration", 1);
        previewProg.setUniform("premultiplyAlpha", true);
        previewProg.setTexture("decoration", 0);
        
        glActiveTexture(GL_TEXTURE0);
        //glBindTexture(GL_TEXTURE_2D,letterboxedTexture.tex);
        //glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, drawingBuffer.tex);
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        glGenerateMipmap(GL_TEXTURE_2D);
       
        //std::cout<<"DRAWING BUFFER TEX IS "<<drawingBuffer.tex<<std::endl;
        
        screenQuad();
        
        context.present();
    }

    void renderPainting(float x, float y)
    {
        glBindFramebuffer(GL_FRAMEBUFFER, drawingFramebuffer);
 
        glViewport(0,0,PhotoApplication_SQUARE_DIM,PhotoApplication_SQUARE_DIM);
        
        //glEnable(GL_BLEND);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        drawingProg.bind();
        
        drawingProg.setUniform("pointSize", decoratorState.penSize);
        
        if(decoratorState.eraserEnabled)
        {
            drawingProg.setUniform("color", 0.0f,0.0f,0.0f, 0.0f);
        }
        else
        {
            drawingProg.setUniform("color", decoratorState.penR, decoratorState.penG, decoratorState.penB, .8);
        }
        
        Eigen::Vector2f penLocation(x,y);
        Eigen::Vector2f lastPenLocation(decoratorState.lastPenX,decoratorState.lastPenY);
        
        //get vector perpendicular to the line direction & normalize
        Eigen::Vector2f offset( (penLocation[1] - lastPenLocation[1]),(lastPenLocation[0] - penLocation[0]));
        
        //if(!offset.norm())return;
        
        offset.normalize();
        
        float frameWidth = PhotoApplication_SQUARE_DIM, frameHeight = PhotoApplication_SQUARE_DIM;
        
        //pass in the normalized offset vector to the shader
        
        //the size should be the size of the pen in clip coords.  penSize is in pixels, so do the appropriate conversions
        //note that this scaled vector is HALF the pen size since it goes from the center to the edge.
        offset[1] *=(.5f * decoratorState.penSize / frameHeight);
        offset[0] *= (.5f * decoratorState.penSize / frameWidth);
        
        float halfPenRadiusClip = offset.norm();//get the magnitude of the offset vector scaled to be the length of the pen radius
        
        Eigen::Vector2f tempdiff = penLocation - lastPenLocation;
        
        //convert from clip vector to pixel vector
        tempdiff[1] += 1.0;
        tempdiff[1] *=.50;
        tempdiff[1] *= frameHeight;
        
        tempdiff[0] += 1.0;
        tempdiff[0] *=.50;
        tempdiff[0] *= frameWidth;
        
        //norm is length of line in pixels.
        //endTC is therefore portion of the way "into" the brush... but we're not using this anymore apparently
        double endTC = tempdiff.norm() / decoratorState.penSize;
        
        Mesh lineModel;
        
        lineModel.addAttribute("position",3);
        
        AttributeArray::Inserter<3> pos((lineModel)["position"]);
        
        lineModel.begin(7);
        
        /*std::cout<<"\n\nDraw call"<<std::endl;
        std::cout<<"last pen location "<<lastPenLocation<<std::endl;
        std::cout<<"Offset "<<offset<<std::endl;
        std::cout<<"Last pen location "<<lastPenLocation<<std::endl;
        std::cout<<"Last offset "<<lastOffset<<std::endl;
        */
        pos.vertex({lastPenLocation[0] + offset[0], lastPenLocation[1] + offset[1], 0.0});
        
        pos.vertex({penLocation[0] + offset[0], penLocation[1] + offset[1],0});
        
        pos.vertex({penLocation[0] - offset[0], penLocation[1] - offset[1],0});
        
        pos.vertex({lastPenLocation[0] - offset[0], lastPenLocation[1] - offset[1], 0.0});
        
        //start connective triangle verts
        

        pos.vertex({lastPenLocation[0], lastPenLocation[1], 0.0});
        pos.vertex({lastPenLocation[0] - lastOffset[0], lastPenLocation[1] - lastOffset[1], 0.0});
        pos.vertex({lastPenLocation[0] + lastOffset[0], lastPenLocation[1] + lastOffset[1], 0.0});
        
        
        
        //insert connective triangles to make the line segments less blocky, eliminate gaps at direction changes
        
        lineModel.end();
        
        lineModel.beginIndices(12);///\todo should take faces?
        
        //line quad
        lineModel.insertIndices(0,1,2);
        lineModel.insertIndices(2,3,0);
        
        lineModel.insertIndices(4,3,5);
        lineModel.insertIndices(4,0,6);
        
        lineModel.endIndices();
        
        GPUMesh mesh(lineModel);
        
        mesh.push();
        lastOffset = offset;
        glFinish();///\todo get rid of finish call
        ///\todo draw points
    }
    
    void initializeDownsampleFramebuffer()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, downsampleFramebuffer);
        ImageFormat downsampleFormat;
        downsampleFormat.channels = 4;
        
        static const float downsampleScale = 1.125f;
        
        unsigned int downsampleSize = mainRenderbufferDims.first * downsampleScale;
        
        downsampleSize = std::max<unsigned int>(downsampleSize, 612);
        
        downsampleSize = std::min<unsigned int>(downsampleSize, PhotoApplication_SQUARE_DIM);
        
        std::cout<<"DOWNSAMPLED DRAWING BUFFER "<<downsampleSize<<std::endl;
        
        downsampleFormat.width = downsampleFormat.height = downsampleSize;
        downsampleTexture = GLTexture(downsampleFormat);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, downsampleTexture.tex, 0);
        glViewport(0, 0, downsampleSize, downsampleSize);
    }
    
    
    void initializeFramebuffer()
    {
        //initialize drawing surface framebuffer
        glBindFramebuffer(GL_FRAMEBUFFER, drawingFramebuffer);
        ImageFormat format;
        
        unsigned int dimToUse = PhotoApplication_SQUARE_DIM;
        
        format.width =dimToUse;
        format.height = dimToUse;
        format.channels=4;
        
        //letterboxedTexture = GLTexture(format);
        
        drawingBuffer = GLTexture(format);
        ///\todo glBindTexture(GL_TEXTURE_2D, drawingBuffer.tex);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, drawingBuffer.tex ,0);
        ///\todo glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
       ///\todo  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        glViewport(0,0,PhotoApplication_SQUARE_DIM,PhotoApplication_SQUARE_DIM);
        glClear(GL_COLOR_BUFFER_BIT);
    }

    
    void initializeShaders()
    {
        previewProg.initializeShaderSource(previewVertexShader, previewFragmentShader);
        previewProg.bind();
        bindLocs(previewProg);
        
        drawingProg.bind();
        drawingProg.initializeShaderSource(drawVertexShader, drawFragmentShader);
        bindLocs(drawingProg);
    }
    
    
    SystemImage getPixels(unsigned int pixelWidth)
    {
        std::shared_ptr<GLubyte> data(new GLubyte[pixelWidth * pixelWidth *  4]);
        
        glReadPixels(0, 0, pixelWidth, pixelWidth, GL_RGBA, GL_UNSIGNED_BYTE, data.get());
        
        LDRImage::index_type dims = {{4,(std::size_t)pixelWidth,(std::size_t)pixelWidth}};
        
        LDRImage img(data, dims);
        
        bool landscape = false;
        
        if(landscape)
        {
            flipHorizontal(img);
            
            SystemImage rval(data.get(), pixelWidth, pixelWidth,4); ///\todo last argument messes this up
            
            UIImage* landscapeImg = [UIImage imageWithCGImage:toUIImage(rval).CGImage scale:1.0f orientation:UIImageOrientationLeft];
            
            return SystemImageIOS(landscapeImg);
            
        }
        else
        {
            flipVertical(img); //OS image coordinate system is upper left
            
            SystemImage rval(data.get(), pixelWidth,pixelWidth,4);
            
            return rval;
        }

    }
    
    SystemImage extractDrawingImageSmooth()
    {
        static bool downsampleInitialized = false;
        
        if(!downsampleInitialized)
        {
            initializeDownsampleFramebuffer();
            downsampleInitialized=true;
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, downsampleFramebuffer);

        //render preview code here.
        glViewport(0, 0, downsampleTexture.width, downsampleTexture.height);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        glDisable(GL_BLEND);
        
        previewProg.bind();
        previewProg.setTexture("decoration", 0);
        previewProg.setUniform("premultiplyAlpha", false);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, drawingBuffer.tex);
        
        ///\todo i think we can axe all of this
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glGenerateMipmap(GL_TEXTURE_2D);
        
        screenQuad();
        
        return getPixels(downsampleTexture.width);
    }
    
    SystemImage extractDrawingImage()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, drawingFramebuffer);
        return getPixels(PhotoApplication_SQUARE_DIM);
    }
    
    void createWindowRenderbuffer(GLViewIOS* glView)
    {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        
        if(mainRenderbuffer)
        {
            glDeleteRenderbuffers(1, &mainRenderbuffer);
        }
        
        mainRenderbuffer = glView.mainRenderBuffer = [GLViewIOS allocateMainRenderBuffer:(CAEAGLLayer*)glView.layer withContext: context.pImpl->context];
        
        glBindFramebuffer(GL_FRAMEBUFFER, previewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, glView.mainRenderBuffer);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, glView.mainRenderBuffer);
        
        mainRenderbufferDims = [glView getRenderBufferDimensions];
        
        glViewport(0, 0, mainRenderbufferDims.first, mainRenderbufferDims.second);
        
        glClear(GL_COLOR_BUFFER_BIT);
    }
    
    
    void initializeRenderer()
    {
        glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
        
        glPixelStorei(GL_PACK_ALIGNMENT, 1);
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        glClearColor(0,0,0,0);
        
        glGenFramebuffers(1, &downsampleFramebuffer);
        glGenFramebuffers(1, &drawingFramebuffer);
        glGenFramebuffers(1, &previewFramebuffer);
        
        initializeShaders();
        initializeFramebuffer();
    }
    
    
    ~OpenGLRenderer()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        
        if(previewFramebuffer)
        {
            glDeleteFramebuffers(1, &previewFramebuffer);
        }
        if(drawingFramebuffer)
        {
            glDeleteFramebuffers(1, &drawingFramebuffer);
        }
        if(mainRenderbuffer)
        {
            glDeleteRenderbuffers(1, &mainRenderbuffer);
        }
    }
};

extern std::shared_ptr<OpenGLRenderer> renderer;

inline void updateRendererPreviews()
{
    if(renderer)
    {
        renderer->renderPreview();
        decoratorState.decoratorImage = toUIImage(renderer->extractDrawingImageSmooth());
        appState.m_decoratorImageView.image = decoratorState.decoratorImage;
    }
}

#endif
