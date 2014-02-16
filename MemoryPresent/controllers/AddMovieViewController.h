//
//  AddMovieViewController.h
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "FaceDetector.h"
#import "FacebookSDK.h"
#import "CustomFaceRecognizer.h"
#import "OpenCVData.h"
#import "PictureListViewController.h"

@interface AddMovieViewController : UIViewController <FBFriendPickerDelegate,  UISearchBarDelegate>{
    
    IBOutlet UILabel *friendNameLabel;
    IBOutlet FBProfilePictureView *pictureView;
    
    //facebok SDK
    FBFriendPickerViewController *friendPickerController;
    UISearchBar *friendSearchBar;
    NSString *searchText;
}

@end
