//
//  EditMovie.h
//  MemoryPresent
//
//  Created by InoueAyaka on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
@interface EditMovie : NSObject
@property (nonatomic,strong) AVAssetExportSession *assetExport;

- (void)compositeMovieFromUrl:(NSURL *)outputFileURL;

@end
