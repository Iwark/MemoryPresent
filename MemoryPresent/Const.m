//
//  Const.m
//  NagareyamaScouter
//
//  Created by Kohei Iwasaki on 2014/01/26.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "Const.h"

@implementation Const

+ (instancetype)sharedConstant
{
    static Const *_shared = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (id)init
{
    if(self = [super init]){
        _screenSize = [UIScreen mainScreen].applicationFrame.size;
        _statusBarHeight = 20; //[[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return self;
}

@end
