//
//  Animator.m
//  img-to-video
//
//  Created by 呉 季樺 on 2014/2/16.
//  Copyright (c) 2014年 Carmen Ferrara. All rights reserved.
//

#import "Animator.h"
#import "UIImage+Extras.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Animator

- (NSURL *)createVideo:(NSMutableArray *) imageArray{

    ///////////// setup OR function def if we move this to a separate function ////////////
    // this should be moved to its own function, that can take an imageArray, videoOutputPath, etc...
    //    - (void)exportImages:(NSMutableArray *)imageArray
    // asVideoToPath:(NSString *)videoOutputPath
    // withFrameSize:(CGSize)imageSize
    // framesPerSecond:(NSUInteger)fps {
    
    NSError *error = nil;
    
    
    // set up file manager, and file videoOutputPath, remove "test_output.mp4" if it exists...
    //NSString *videoOutputPath = @"/Users/someuser/Desktop/test_output.mp4";
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *videoOutputPath = [documentsDirectory stringByAppendingPathComponent:@"test_output.mp4"];
    //NSLog(@"-->videoOutputPath= %@", videoOutputPath);
    // get rid of existing mp4 if exists...
    if ([fileMgr removeItemAtPath:videoOutputPath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    
    CGSize imageSize = CGSizeMake(800, 400);
    NSUInteger fps = 30;
    
    /** Replac by input
    
     
    //NSMutableArray *imageArray;
    //imageArray = [[NSMutableArray alloc] initWithObjects:@"download.jpeg", @"download2.jpeg", nil];
    NSMutableArray *imageArray;
    NSArray* imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
    imageArray = [[NSMutableArray alloc] initWithCapacity:imagePaths.count];
    NSLog(@"-->imageArray.count= %i", imageArray.count);
    for (NSString* path in imagePaths)
    {
        [imageArray addObject:[UIImage imageWithContentsOfFile:path]];
        //NSLog(@"-->image path= %@", path);
    }
    
    **/
    
    //////////////     end setup    ///////////////////////////////////
    
    NSLog(@"Start building video from defined frames.");
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:videoOutputPath] fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    int frameCount = 0;
    int numberOfImage = imageArray.count;
    double numberOfSecondsPerFrame = (94.0/numberOfImage);
    NSLog(@"size of array: %d",numberOfImage);
    NSLog(@"30/size= %f", (94.0/numberOfImage));
    double frameDuration = fps * numberOfSecondsPerFrame;
    
    //for(VideoFrame * frm in imageArray)
    NSLog(@"**************************************************");
    for(UIImage * img in imageArray)
    {
        //resize by ggwu
        /**
         UIGraphicsBeginImageContext(imageSize);
         [img drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
         UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         **/
        UIImage* newImage = [img imageByScalingAndCroppingForSize:imageSize];
        
        
        
        //UIImage * img = frm._imageFrame;
        buffer = [self pixelBufferFromCGImage:[newImage CGImage]];
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 94) {
            if (adaptor.assetWriterInput.readyForMoreMediaData)  {
                //print out status:
                NSLog(@"Processing video frame (%d,%d)",frameCount,[imageArray count]);
                
                CMTime frameTime = CMTimeMake(frameCount*frameDuration,(int32_t) fps);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                if(!append_ok){
                    NSError *error = videoWriter.error;
                    if(error!=nil) {
                        NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                    }
                }
            }
            else {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok) {
            printf("error appending image %d times %d\n, with error.", frameCount, j);
        }
        frameCount++;
    }
    NSLog(@"**************************************************");
    
    //Finish the session:
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    NSLog(@"Write Ended");
    
    
    
    ////////////////////////////////////////////////////////////////////////////
    //////////////  OK now add an audio file to move file  /////////////////////
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSString *bundleDirectory = [[NSBundle mainBundle] bundlePath];
    // audio input file...
    NSString *audio_inputFilePath = [bundleDirectory stringByAppendingPathComponent:@"birthday.mp3"];
    NSURL    *audio_inputFileUrl = [NSURL fileURLWithPath:audio_inputFilePath];
    
    // this is the video file that was just written above, full path to file is in --> videoOutputPath
    NSURL    *video_inputFileUrl = [NSURL fileURLWithPath:videoOutputPath];
    
    // create the final video output file as MOV file - may need to be MP4, but this works so far...
    NSString *outputFilePath = [documentsDirectory stringByAppendingPathComponent:@"final_video.mp4"];
    NSURL    *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //nextClipStartTime = CMTimeAdd(nextClipStartTime, a_timeRange.duration);
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    //_assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputFileType = @"public.mpeg-4";
    //NSLog(@"support file types= %@", [_assetExport supportedFileTypes]);
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         //[self saveVideoToAlbum:outputFilePath];
         
         // 端末に保存
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileUrl])
         {
             [library writeVideoAtPathToSavedPhotosAlbum:outputFileUrl
                                         completionBlock:^(NSURL *assetURL, NSError *assetError)
              {
                  if (assetError) {
                      NSLog(@"error: %@",assetError);
                  }else{
                      NSLog(@"success: %@",assetURL);
                      [SVProgressHUD showSuccessWithStatus:@"保存しました"];
                  }
              }];
         }else{
             NSLog(@"aaa");
         }

     }
     ];
    
    ///// THAT IS IT DONE... the final video file will be written here...
    NSLog(@"DONE.....outputFilePath--->%@", outputFileUrl);
    
    // the final video file will be located somewhere like here:
    // /Users/caferrara/Library/Application Support/iPhone Simulator/6.0/Applications/D4B12FEE-E09C-4B12-B772-7F1BD6011BE1/Documents/outputFile.mov
    
    return outputFileUrl;
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    

    
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image {
    
    CGSize size = CGSizeMake(800, 400);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          size.width,
                                          size.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
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
    
    return pxbuffer;
}



@end
