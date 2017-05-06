//
//  UIImage+Caffe2.m
//  C2Swift
//
//  Created by Andrey Volodin on 04.05.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import "UIImage+Caffe2.h"

CGImageRef CGImageCopyWithSize(CGImageRef input, CGSize targetSize) {
    //const size_t width = CGImageGetWidth(input);
    //const size_t height = CGImageGetHeight(input);
    const size_t bitsPerComponent = CGImageGetBitsPerComponent(input);
    const size_t bytesPerRow = CGImageGetBytesPerRow(input);
    const CGColorSpaceRef colorSpace = CGImageGetColorSpace(input);
    const CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(input);
    
    CGContextRef contextRef = CGBitmapContextCreate(nil, targetSize.width, targetSize.height,
                                                    bitsPerComponent, bytesPerRow,
                                                    colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextDrawImage(contextRef, (CGRect){ CGPointZero, (CGSize){ targetSize.width , targetSize.height } }, input);
    
    return CGBitmapContextCreateImage(contextRef);
}

@implementation UIImage (Caffe2)

-(caffe2::TensorCPU*)tensorWithSize:(CGSize)size {
    CGImage* thisCG = self.CGImage;
    
    //const size_t height = CGImageGetHeight(thisCG);
    //const size_t width  = CGImageGetWidth(thisCG);
    const int targetHeight = (int)size.height;
    const int targetWidth  = (int)size.width;
    const int crops = 1;
    const int channels = 3;
    const int targetSize = targetHeight * targetWidth;
    
    unsigned short* rawImageData = new unsigned short[targetHeight * targetWidth * 4];
    
    CGContextRef contextRef = CGBitmapContextCreate(rawImageData,
                                                 targetWidth, targetHeight,
                                                 8, targetWidth * 4,
                                                 CGImageGetColorSpace(thisCG),
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, targetWidth, targetHeight), CGImageCopyWithSize(thisCG, size));

    CGContextRelease(contextRef);
    
    auto input = new caffe2::TensorCPU();
    
    float* inputPlanar = (float*)malloc(sizeof(float) * crops * channels * targetHeight * targetWidth);
    
    for (auto i = 0; i < targetHeight; ++i) {
        for (auto j = 0; j < targetWidth; ++j) {
            // Convert from RGBA to BGR
            inputPlanar[i * targetWidth + j + 0 * targetSize] = (float) rawImageData[(i * targetWidth + j) * 4 + 2];
            inputPlanar[i * targetWidth + j + 1 * targetSize] = (float) rawImageData[(i * targetWidth + j) * 4 + 1];
            inputPlanar[i * targetWidth + j + 2 * targetSize] = (float) rawImageData[(i * targetWidth + j) * 4 + 0];
        }
    }
    
    input->Resize(std::vector<int>({crops, channels, targetHeight, targetWidth}));
    input->ShareExternalPointer(inputPlanar, 0, [inputPlanar](void*) -> void { free(inputPlanar); });
    
    return input;
}

@end
