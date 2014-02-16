//
//  EditMovie.m
//  MemoryPresent
//
//  Created by InoueAyaka on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "EditMovie.h"
const float kRecordingFPS = 60.0f;
@implementation EditMovie

- (id)init
{
    self = [super init];
    if (self) {
        //初期化
    }
    
    return self;
}

// 動画の合成処理。コピーライトと会社のロゴを合成する。
- (void)compositeMovieFromUrl:(NSURL *)outputFileURL {
    
    //***** 1. ベースとなる動画のコンポジションを作成。*****//
    
    // 動画URLからアセットを生成
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:outputFileURL options:nil];
    
    // コンポジション作成
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack =
    [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // アセットからトラックを取得
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // コンポジションの設定
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    //***** 2. 合成したいテキストやイラストをCALayerで作成して、合成用コンポジションを生成。*****//
    
    // ロゴのCALayer作成
    //    CVPixelBufferRef buffer = NULL;
    UIImage *happy1;
    UIImage *happy2;
    UIImage *happy3;
    UIImage *happy4;
    UIImage *happy5;
    UIImage *happy6;
    UIImage *happy7;
    
    UIImage *logoImage = [UIImage imageNamed:@"way2.png"]; //ok
    UIImage *image2 = [UIImage imageNamed:@"cake1.png"];
    UIImage *image3 = [UIImage imageNamed:@"hat.png"];
    UIImage *image4 = [UIImage imageNamed:@"cupcake.png"];
    UIImage *image5 = [UIImage imageNamed:@"balloon1.png"];
    UIImage *image6 = [UIImage imageNamed:@"happybday.png"];
    UIImage *image7 = [UIImage imageNamed:@"presentbox.png"];
    
    happy1 = [self pixelBufferFromCGImage:[logoImage CGImage]];
    happy2 = [self pixelBufferFromCGImage:[image2 CGImage]];
    happy3 = [self pixelBufferFromCGImage:[image3 CGImage]];
    happy4 = [self pixelBufferFromCGImage:[image4 CGImage]];
    happy5 = [self pixelBufferFromCGImage:[image5 CGImage]];
    happy6 = [self pixelBufferFromCGImage:[image6 CGImage]];
    happy7 = [self pixelBufferFromCGImage:[image7 CGImage]];
    
    CALayer *logoLayer1 = [CALayer layer];
    CALayer *logoLayer2 = [CALayer layer];
    CALayer *logoLayer3 = [CALayer layer];
    CALayer *logoLayer4 = [CALayer layer];
    CALayer *logoLayer5 = [CALayer layer];
    CALayer *logoLayer6 = [CALayer layer];
    CALayer *logoLayer7 = [CALayer layer];
    
    
    
    
    logoLayer1.contents = (__bridge id)(happy1.CGImage);
    logoLayer1.frame = CGRectMake(20, 250, 400, 400);
    logoLayer1.opacity = 0.9;
    
    logoLayer2.contents = (__bridge id)(happy2.CGImage);
    logoLayer2.frame = CGRectMake(-40,0, 400, 400);
    logoLayer2.opacity = 0.9;
    
    logoLayer3.contents = (__bridge id)(happy3.CGImage);
    logoLayer3.frame = CGRectMake(150, 400, 400, 400);
    logoLayer3.opacity = 0.9;
    
    logoLayer4.contents = (__bridge id)(happy4.CGImage);
    logoLayer4.frame = CGRectMake(800, 250, 500, 500);
    logoLayer4.opacity = 0.9;
    
    logoLayer5.contents = (__bridge id)(happy5.CGImage);
    logoLayer5.frame = CGRectMake(-50, 450, 300, 300);
    
    logoLayer6.contents = (__bridge id)(happy6.CGImage);
    logoLayer6.frame = CGRectMake(350, 10, 600, 600);
    
    
    logoLayer7.contents = (__bridge id)(happy7.CGImage);
    logoLayer7.frame = CGRectMake(950, -50, 300, 300);
    
    // 動画のサイズを取得
    CGSize videoSize = videoTrack.naturalSize;
    
    // コピーライトのCALayerを作成
    CATextLayer *copyrightLayer = [CATextLayer layer];
    copyrightLayer.string = @"Happy_Birthday!!";
    [copyrightLayer setFont:@"Helvetica"];
    copyrightLayer.fontSize = videoSize.height / 6;
    copyrightLayer.wrapped = YES;
    copyrightLayer.bounds = CGRectMake(0, 50, videoSize.width, videoSize.height-50);
    
    
    // 親レイヤーを作成
    CALayer *parentLayer = [CALayer layer];
    parentLayer.backgroundColor = [UIColor blueColor].CGColor;
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame  = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:logoLayer1];
    [parentLayer addSublayer:logoLayer2];
    [parentLayer addSublayer:logoLayer3];
    [parentLayer addSublayer:logoLayer4];
    [parentLayer addSublayer:logoLayer5];
    [parentLayer addSublayer:logoLayer6];
    [parentLayer addSublayer:logoLayer7];
    
    // 合成用コンポジション作成
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1,30); //value divide by timescale
    videoComp.animationTool =
    [AVVideoCompositionCoreAnimationTool
     videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
     inLayer:parentLayer];
    
    // インストラクション作成
    AVMutableVideoCompositionInstruction *instruction =
    [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]); // 時間を設定
    AVMutableVideoCompositionLayerInstruction* layerInstruction =
    [AVMutableVideoCompositionLayerInstruction
     videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    
    // インストラクションを合成用コンポジションに設定
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    //***** 3. AVAssetExportSessionを使用して1と2のコンポジションを合成。*****//
    
    // 1のコンポジションをベースにAVAssetExportを生成
    _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                    presetName:AVAssetExportPresetMediumQuality];
    // 2の合成用コンポジションを設定
    _assetExport.videoComposition = videoComp;
    
    // エクスポートファイルの設定
    NSString* videoName = @"kuman.mov";
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    // ファイルが存在している場合は削除
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    // エクスポード実行
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         
         // 保存
         NSString *str = [[NSBundle mainBundle] pathForResource:@"birthday" ofType:@"mp3"];
         NSURL *url = [NSURL fileURLWithPath:str];
         [self addAudio:url ToVideo:_assetExport.outputURL];
         
         
     }
     ];
}

- (void)addAudio:(NSURL *)audioUrl ToVideo:(NSURL *)videoUrl
{
    NSLog(@"hi im audio");
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                         presetName:AVAssetExportPresetPassthrough];
    
    NSString* videoName = @"export.mp4";
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    assetExport.outputFileType = @"com.apple.quicktime-movie";
    NSLog(@"file type %@",_assetExport.outputFileType);
    assetExport.outputURL = exportUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         // your completion code here
         NSLog(@"hi im audio%@",assetExport.outputURL);
         
         // 端末に保存
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportUrl])
         {
             [library writeVideoAtPathToSavedPhotosAlbum:exportUrl
                                         completionBlock:^(NSURL *assetURL, NSError *assetError)
              {
                  if (assetError) {
                      NSLog(@"error: %@",assetError);
                  }else{
                      NSLog(@"success: %@",assetURL);
                  }
              }];
         }else{
             NSLog(@"aaa");
         }
         
     }];
}

- (UIImage *) pixelBufferFromCGImage: (CGImageRef) image {
    
    CGSize size = CGSizeMake(400, 400);
    
    CFDictionaryRef empty = NULL; // empty value for attr value.
    CFMutableDictionaryRef attrs = NULL;
    empty = CFDictionaryCreate(kCFAllocatorDefault, // our empty IOSurface properties dictionary
                               NULL,
                               NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                      1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs,
                         kCVPixelBufferIOSurfacePropertiesKey,
                         empty);
    int width = 500;
    int height = 500;
    
    
    int format = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;//kCVPixelFormatType_32BGRA;
    
    CFNumberRef widthKey = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &width);
    CFNumberRef heightKey = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &height);
    CFNumberRef formatKey = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &format);
    
    
    CFDictionaryAddValue(attrs, kCVPixelBufferWidthKey, widthKey);
    CFDictionaryAddValue(attrs, kCVPixelBufferHeightKey, heightKey);
    CFDictionaryAddValue(attrs, kCVPixelBufferPixelFormatTypeKey, formatKey);
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          size.width,
                                          size.height,
                                          kCVPixelFormatType_32ARGB,
                                          attrs,
                                          &pxbuffer);
    if (status != kCVReturnSuccess){
        NSLog(@"Failed to create pixel buffer");
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    //kCGImageAlphaNoneSkipFirst);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    //return pxbuffer;
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pxbuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pxbuffer),
                                                 CVPixelBufferGetHeight(pxbuffer))];
    
    return [UIImage imageWithCGImage:videoImage];
    
    //return [UIImage imageWithCGImage:CGBitmapContextCreateImage (context)];
    
    /* void *baseAddress = pxbuffer;
     CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
     
     UIImage *image = [UIImage imageWithCGImage:pxbuffer];*/
}

@end
