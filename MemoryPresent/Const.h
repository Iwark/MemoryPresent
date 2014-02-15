//
//  Const.h
//  NagareyamaScouter
//
//  Created by Kohei Iwasaki on 2014/01/26.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBA(rgb,a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]

#define NAVBAR_COLOR RGBA(0x4bc1d2, 1.0)

#define SCREEN(w) (((float)w)/320*c.screenSize.width)

@interface Const : NSObject

@property (nonatomic) CGSize screenSize;
@property (nonatomic) float navHeight;
@property (nonatomic) float statusBarHeight;

+ (instancetype)sharedConstant;

@end
