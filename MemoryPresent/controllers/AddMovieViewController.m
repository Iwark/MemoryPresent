//
//  AddMovieViewController.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "AddMovieViewController.h"

@interface AddMovieViewController ()

@end

@implementation AddMovieViewController

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
    [SVProgressHUD showWithStatus:@"Facebook連携なう"];
    
    [self selectFriendsButtonAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectFriendsButtonAction{
    
    // FBSample logic
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self selectFriendsButtonAction];
                                          }
                                      }];
        return;
    }
    
    if (friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        friendPickerController = [[FBFriendPickerViewController alloc] init];
        friendPickerController.title = @"Select Friends";
        friendPickerController.delegate = self;
        friendPickerController.allowsMultipleSelection = NO;
    }
    
    [friendPickerController loadData];
    [friendPickerController clearSelection];
    
    [self presentViewController:friendPickerController
                       animated:YES
                     completion:^(void){
                         [SVProgressHUD dismiss];
                         [self addSearchBarToFriendPickerView];
                     }
     ];
}

- (void)handlePickerDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name);
        
        [self getUserPhotos:user];
        //[user id], [user birthday]
        
        friendNameLabel.text = user.name;
        pictureView.profileID = user.id;
    }
    
    [self handlePickerDone];
}

- (void)addSearchBarToFriendPickerView
{
    if (friendSearchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        friendSearchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        friendSearchBar.autoresizingMask = friendSearchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        friendSearchBar.delegate = self;
        friendSearchBar.showsCancelButton = YES;
        
        [friendPickerController.canvasView addSubview:friendSearchBar];
        CGRect newFrame = friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        friendPickerController.tableView.frame = newFrame;
    }
}

- (void)handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchText = searchBar.text;
    [friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchText = nil;
    [searchBar resignFirstResponder];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    if (searchText && ![searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

-(void)viewDidUnload{
    friendPickerController = nil;
    friendSearchBar = nil;
    
    [super viewDidUnload];
}


- (void)getUserPhotos:(id<FBGraphUser>)user{
	
    /* make the API call */
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/photos", [user id]]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              //NSLog(@"result = %@",result);
                              int i = 0;
                              NSMutableArray *fileURLs = NSMutableArray.new;
                              NSMutableArray *images = NSMutableArray.new;
                              UIImage *image;
                              for (NSDictionary *data in [result objectForKey:@"data"]) {
                                  //NSLog(@"sourceURL = %@", [data objectForKey:@"source"]);
                                  fileURLs[i] = [NSURL URLWithString:[data objectForKey:@"source"]];
                                  NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURLs[i]]];
                                  image = [UIImage imageWithData:urlData];
                                  images[i] = image;
                                  //NSLog(@"%@", fileURLs[i]);
                                  i++;
                              }
                              
                          }];
    
}


@end
