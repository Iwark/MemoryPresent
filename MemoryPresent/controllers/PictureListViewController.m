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
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result) {
                if(![photos containsObject:result]) {
                    // ALAssetのタイプが「写真」を追加
                    if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [photos addObject:result];
                        UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                        NSLog(@"a!?");
                        if(img){
                            NSLog(@"aaaaaa");
                            [plv.images addObject:img];
                        }
                    }
                }
            }else{
                NSLog(@"bbbbbbb");
                [plv render];
            }
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
