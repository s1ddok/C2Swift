//
//  C2Wrapper.m
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import "C2Wrapper.h"
#include "caffe2/core/common.h"

#include "caffe2/core/logging.h"
#include "caffe2/core/workspace.h"
#include "caffe2/utils/proto_utils.h"

using namespace caffe2;

@implementation C2Wrapper

-(void)foo {
    NetDef netdef;
    {
        auto& op = *(netdef.add_op());
    }
    
}

@end
