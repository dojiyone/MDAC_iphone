//
//  RankingViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import "loadingAPI.h"
#import "TagpageViewController.h"

@class TopViewController;

@interface RankingViewController : TopViewController
{
@public
    //NSString *loadflag;
    //NSInteger loadflag;
    IBOutlet UINavigationController *_nav2;
    NSString *tagString[8];
    NSString *tagStringSub[6];
    int nowTagNum;
    int reloadFlag;
    
    IBOutlet UILabel *more1_label;
    IBOutlet UILabel *more2_label;
    IBOutlet UILabel *more3_label;
    IBOutlet UILabel *more4_label;
    IBOutlet UILabel *more5_label;
    IBOutlet UILabel *more6_label;
    IBOutlet UILabel *more7_label;
    IBOutlet UILabel *more8_label;
    
    IBOutlet UIScrollView *scrollView1;
    IBOutlet UIScrollView *scrollView2;
    IBOutlet UIScrollView *scrollView3;
    IBOutlet UIScrollView *scrollView4;
    IBOutlet UIScrollView *scrollView5;
    IBOutlet UIScrollView *scrollView6;
    IBOutlet UIScrollView *scrollView7;
    IBOutlet UIScrollView *scrollView8;
    IBOutlet UIScrollView *MainScrollView; 
    IBOutlet UIView *MainView;
    
    //IBOutlet UIScrollView *nowScrollView;
    NSString *tag_value;
}
//@property (nonatomic,retain)NSString *loadflag;
@property (assign) IBOutlet UINavigationController *_nav2;


- (void)layoutScrollImages2:(UIScrollView *)nowScrollView;
- (void)RankinglayoutScroll;
//- (void)nextDataLoadRankingView;

-(void)buttonTouched:(id)sender;//:(UIButton*)button;

-(void)loadNewScrollView;
-(void)loadNextScrollView;

-(IBAction) more0_btn_down:(id)sender;
-(IBAction) more1_btn_down:(id)sender;
-(IBAction) more2_btn_down:(id)sender;
-(IBAction) more3_btn_down:(id)sender;
-(IBAction) more4_btn_down:(id)sender;
-(IBAction) more5_btn_down:(id)sender;
-(IBAction) more6_btn_down:(id)sender;
-(IBAction) more7_btn_down:(id)sender;


@end
