//
//  HelpView.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/12.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView

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
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    wv.frame = CGRectMake(0, 45, 320, 415);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSURL *url = [NSURL URLWithString:@"http://meet-dogsncats.com/meethelp/help.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
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

-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidAppear:(BOOL)animated
{
}
@end
