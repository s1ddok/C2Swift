//
//  C2Wrapper.m
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import "C2Wrapper.h"
#import "UIImage+Caffe2.h"
#include "mpscnn_test.h"

#include "caffe2/core/context.h"
#include "caffe2/core/operator.h"
#include "caffe2/core/flags.h"
#include "caffe2/core/init.h"
#include "caffe2/core/predictor.h"
#include "caffe2/utils/proto_utils.h"
#include "imagenet_classes.h"

using namespace caffe2;

void LoadPBFile(NSString *filePath, caffe2::NetDef *net) {
    NSURL *netURL = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:netURL];
    const void *buffer = [data bytes];
    int len = (int)[data length];
    CAFFE_ENFORCE(net->ParseFromArray(buffer, len));
}

Predictor *getPredictor(NSString *init_net_path, NSString *predict_net_path) {
    caffe2::NetDef init_net, predict_net;
    LoadPBFile(init_net_path, &init_net);
    LoadPBFile(predict_net_path, &predict_net);
    auto predictor = new Predictor(init_net, predict_net);
    init_net.set_name("InitNet");
    predict_net.set_name("PredictNet");
    return predictor;
}

void run(const string& net_path, const string& predict_net_path) {
    caffe2::NetDef init_net, predict_net;
    CAFFE_ENFORCE(ReadProtoFromFile(net_path, &init_net));
    CAFFE_ENFORCE(ReadProtoFromFile(predict_net_path, &predict_net));
    
    // Can be large due to constant fills
    VLOG(1) << "Init net: " << ProtoDebugString(init_net);
    LOG(INFO) << "Predict net: " << ProtoDebugString(predict_net);
    auto predictor = caffe2::make_unique<Predictor>(init_net, predict_net);
    LOG(INFO) << "Checking that a null forward-pass works";
    Predictor::TensorVector inputVec, outputVec;
    predictor->run(inputVec, &outputVec);
    NSLog(@"outputVec size: %lu", outputVec.size());
    NSLog(@"Done running caffe2");
}

@implementation C2Wrapper

+(void)runMPSTests {
    testMPSCNN();
}

+(NSString*)predictWithImage: (UIImage *)image {
    NSString *init_net_path = [NSBundle.mainBundle pathForResource:@"exec_net"
                                                            ofType:@"pb"];
    NSString *predict_net_path = [NSBundle.mainBundle pathForResource:@"predict_net"
                                                               ofType:@"pb"];
    
    caffe2::Predictor *predictor = getPredictor(init_net_path, predict_net_path);
    
    caffe2::TensorCPU* input = [image tensorWithSize:CGSizeMake(256, 256)];
    caffe2::Predictor::TensorVector input_vec{input};
    caffe2::Predictor::TensorVector output_vec;
    predictor->run(input_vec, &output_vec);
    
    float max_value = 0;
    int best_match_index = -1;
    for (auto output : output_vec) {
        for (auto i = 0; i < output->size(); ++i) {
            float val = output->template data<float>()[i];
            if(val > 0.001) {
                if(val>max_value) {
                    max_value = val;
                    best_match_index = i;
                }
            }
        }
    }
    
    // This is to allow us to use memory leak checks.
    google::protobuf::ShutdownProtobufLibrary();
    return [NSString stringWithUTF8String: imagenet_classes[best_match_index]];
}

@end
