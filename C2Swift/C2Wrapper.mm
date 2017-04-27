//
//  C2Wrapper.m
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import "C2Wrapper.h"
#include "mpscnn_test.h"

using namespace caffe2;

@implementation C2Wrapper

+(void)runMPSTests {
    testMPSCNN();
}

@end
