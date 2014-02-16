//
//  PictureListViewController.h
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomFaceRecognizer.h"
#import "OpenCVData.h"
#import "FaceDetector.h"

@interface PictureListViewController : UIViewController

@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSArray *images;

@end
