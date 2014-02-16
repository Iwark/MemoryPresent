//
//  PictureListView.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "PictureListView.h"

@interface PictureListView ()
{
    Const *c;
    MGBox *grid;
}
@end

@implementation PictureListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        grid = [MGBox boxWithSize:self.bounds.size];
        grid.contentLayoutMode = MGLayoutGridStyle;
        [self.boxes addObject:grid];
        
    }
    return self;
}

- (void)render
{
    if(!grid){
        grid = [MGBox boxWithSize:self.bounds.size];
        grid.contentLayoutMode = MGLayoutGridStyle;
        [self.boxes addObject:grid];
    }
    [grid.boxes removeAllObjects];
    for (int i = 0; i < _images.count; i++) {
        MGBox *box = [MGBox boxWithSize:(CGSize){100, 100}];
        box.leftMargin = box.topMargin = 6;
        [grid.boxes addObject:box];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, box.size.width, box.size.height)];
        //box.backgroundColor = [UIColor redColor];
        imgView.image = _images[i];
        [box addSubview:imgView];
        [grid.boxes addObject:box];
    }
    [self layout];
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
