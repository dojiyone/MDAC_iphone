//
//  ObjectViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/11/30.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "ObjectViewController.h"

@implementation ObjectViewController

@synthesize topViewController;
@synthesize rankingViewController;
@synthesize infoViewController;


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    rankingViewController = [[UIViewController alloc] init];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) reload_btn_down:(id)sender;
{
    
}

//上タブ
-(IBAction) new_btn_down:(id)sender;
{
    
    NSLog(@"%@",rankingViewController.title);
    
    topViewController = [[UIViewController alloc] 
                             initWithNibName:@"TopViewController" 
                             bundle:nil];
    topViewController.title =@"top";
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:NO];
    
    [self.view addSubview:topViewController.view];
    
    [UIView commitAnimations];
    
    NSLog(@"%@",rankingViewController.title);
    
}

-(IBAction) ranking_btn_down:(id)sender;{
    /*
    NSLog(@"%@",rankingViewController.title);
    
    return;
    rankingViewController = [[UIViewController alloc] 
                                  initWithNibName:@"RankingViewController" 
                                  bundle:nil];
    rankingViewController.title =@"ranking";
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:NO];
    
    [self.view addSubview:rankingViewController.view];
    
    [UIView commitAnimations];
    NSLog(@"%@",rankingViewController.title);
    */
    
}

-(IBAction) popular_tag_btn_down:(id)sender;
{
    popularTagViewController  = [[UIViewController alloc] 
                                 initWithNibName:@"PopularTagViewController" 
                                 bundle:nil];
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:popularTagViewController.view];
    
    [UIView commitAnimations];
    
}

-(IBAction) info_btn_down:(id)sender;
{
    
    NSLog(@"%@",infoViewController.title);
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:NO];
    
    [self.view addSubview:infoViewController.view];
    
    [UIView commitAnimations];
    
}

//下タブ
-(IBAction) mypage_btn_down:(id)sender;
{
    mypageViewController = [[UIViewController alloc] 
                            initWithNibName:@"MypageViewController" 
                            bundle:nil];
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:mypageViewController.view];
    
    [UIView commitAnimations];
    
}
-(IBAction) serach_btn_down:(id)sender;
{    
    
    serchViewController = [[UIViewController alloc] 
                           initWithNibName:@"SerchViewController" 
                           bundle:nil];
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:serchViewController.view];
    
    [UIView commitAnimations];
    
}
-(IBAction) post_btn:(id)sender;
{
    postViewController = [[UIViewController alloc] 
                          initWithNibName:@"PostViewController" 
                          bundle:nil];
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:postViewController.view];
    
    [UIView commitAnimations];
    
}

-(IBAction) category_sort_btn_down:(id)sender;
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"alert TEST"
                          message:@"カテゴリ切り替えアラート"
                          delegate:nil
                          cancelButtonTitle:@"キャンセルボタン"
                          otherButtonTitles:@"他", nil];
    [alert show];
    [alert release];
}

-(IBAction) setting_btn_down:(id)sender;
{
    secondViewController = [[UIViewController alloc] 
                            initWithNibName:@"SecondView" 
                            bundle:nil];
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:secondViewController.view];
    
    [UIView commitAnimations];
    
}


@end
