//
//  PictureListView.h
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "MGScrollView.h"
#import "MGBox.h"

@interface PictureListView : MGScrollView

@property (nonatomic, strong) NSMutableArray *images;

- (void)render;

@end
