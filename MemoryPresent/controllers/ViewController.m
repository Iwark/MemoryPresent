//
//  ViewController.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/15.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    Const *c;
    
    IBOutlet UILabel *welcomeLabel;
    
}
@end

@implementation ViewController

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
    
    c = [Const sharedConstant];
    
    self.navigationItem.title = @"MemoPre";
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = NAVBAR_COLOR;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
