//
//  MovieListView.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/15.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "MovieListView.h"

@interface MovieListView ()
{
    Const *c;
}
@end

@implementation MovieListView

- (id)initWithFrame:(CGRect)frame
{
    self = [MGScrollView scroller];
    if (self) {
        // Initialization code
        c = [Const sharedConstant];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
