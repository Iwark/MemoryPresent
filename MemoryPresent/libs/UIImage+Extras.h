//
//  UIImage+Extras.h
//  img-to-video
//
//  Created by 呉 季樺 on 2014/2/15.
//  Copyright (c) 2014年 Carmen Ferrara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extras)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)resizingImage:(CGSize)targetSize;

@end
