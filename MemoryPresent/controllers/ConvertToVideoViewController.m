//
//  ConvertToVideoViewController.m
//  MemoryPresent
//
//  Created by Kohei Iwasaki on 2014/02/16.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "ConvertToVideoViewController.h"
#import "Animator.h"

@interface ConvertToVideoViewController ()

@end

@implementation ConvertToVideoViewController

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
    
    Animator *animator = [[Animator alloc] init];
    [animator createVideo:[_images mutableCopy]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
