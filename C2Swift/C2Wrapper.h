//
//  C2Wrapper.h
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface C2Wrapper: NSObject

+(void)runMPSTests;

+(NSString*)predictWithImage:(UIImage*)image;

@end
