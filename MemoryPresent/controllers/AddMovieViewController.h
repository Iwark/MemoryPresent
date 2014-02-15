//
//  AddMovieViewController.h
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK.h"

@interface AddMovieViewController : UIViewController <FBFriendPickerDelegate,  UISearchBarDelegate>{
    
    //IBOutlet UILabel *friendNameLabel;
    
    //facebok SDK
    FBFriendPickerViewController *friendPickerController;
    UISearchBar *friendSearchBar;
    NSString *searchText;
}

@end
