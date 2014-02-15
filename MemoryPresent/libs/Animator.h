//
//  Animator.h
//  img-to-video
//
//  Created by 呉 季樺 on 2014/2/16.
//  Copyright (c) 2014年 Carmen Ferrara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Animator : NSObject
- (IBAction)createVideo:(NSMutableArray *) imageArray;

@end
