//
//  UIImage+Caffe2.h
//  C2Swift
//
//  Created by Andrey Volodin on 04.05.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "caffe2/core/context.h"
#import "caffe2/core/operator.h"

@interface UIImage (Caffe2)

-(caffe2::TensorCPU*)tensorWithSize:(CGSize)size;

@end

