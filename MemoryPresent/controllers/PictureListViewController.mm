//
//  PictureListViewController.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "PictureListViewController.h"
#import "PictureListView.h"
@interface PictureListViewController ()
{
    IBOutlet PictureListView *plv;
    NSMutableArray *photos;
    CustomFaceRecognizer *faceRecognizer;
    FaceDetector *faceDetector;
    BOOL modelAvailable;
}
@end

@implementation PictureListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
    faceDetector = [[FaceDetector alloc] init];
    modelAvailable = [faceRecognizer trainModel];
    
    [SVProgressHUD show];
    
    plv.images = [[NSMutableArray alloc] init];
    [self searchPhotos];
    if(photos.count > 0){
        NSLog(@"%@",photos);
        plv.images = photos;
        [plv render];
    }
    
}

- (void)searchPhotos {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    photos = [[NSMutableArray alloc] init];
    // フォトライブラリへアクセスし、引数のブロックを実行
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil){
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result) {
                    if(![photos containsObject:result]) {
                        // ALAssetのタイプが「写真」を追加
                        if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                            [photos addObject:result];
                            UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                            if(img){
                                cv::Mat cvimage = [OpenCVData cvMatFromUIImage:img usingColorSpace:CV_RGBA2BGRA];
                                const std::vector<cv::Rect> faces = [faceDetector facesFromImage:cvimage];
                                if([self parseFaces:faces forImage:cvimage]){
                                    [plv.images addObject:img];
                                }
                            }
                        }
                    }
                }else{
                    NSLog(@"9");
                }
            }];
        }else{
            NSLog(@"8");
            [plv render];
            [SVProgressHUD dismiss];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (BOOL)parseFaces:(const std::vector<cv::Rect> &)faces forImage:(cv::Mat&)image
{
    // No faces found
    if (faces.size() != 1) {
        return NO;
    }
    
    // We only care about the first face
    cv::Rect face = faces[0];
    
    // By default highlight the face in red, no match found
    CGColor *highlightColor = [[UIColor redColor] CGColor];
    NSString *message = @"No match found";
    NSString *confidence = @"";
    
    // Unless the database is empty, try a match
    if (modelAvailable) {
        NSLog(@"aaa");
        NSDictionary *match = [faceRecognizer recognizeFace:face inImage:image];
        
        // Match found
        if ([match objectForKey:@"personID"] != [NSNumber numberWithInt:-1]) {
            NSLog(@"bbb");
            message = [match objectForKey:@"personName"];
            highlightColor = [[UIColor greenColor] CGColor];
            
            NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
            [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            confidenceFormatter.maximumFractionDigits = 2;
            
            confidence = [NSString stringWithFormat:@"Confidence: %@",
                          [confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];
        }
    }else{
        NSLog(@"bbbb");
    }
    
    // All changes to the UI have to happen on the main thread
    NSLog(@"message:%@",message);
    NSLog(@"confidence:%@",confidence);
    if([message isEqualToString:_name]){
        return YES;
    }else{
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
