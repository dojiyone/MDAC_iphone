//
//  PostDataEditViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 12/01/18.
//  Copyright (c) 2012年 CyberMuse, Inc. All rights reserved.
//

#import "PostDataEditViewController.h"
#import "PostEditViewController.h"
#import "loadingAPI.h"
#import "SecondViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "MixiTestViewController.h"
#import "AlertTableTagViewController.h"
#import "DetailsViewController.h"
#import "DetailsShareViewConroller.h"
#import "TopViewController.h"
#import "MypageViewController.h"

@implementation PostDataEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
