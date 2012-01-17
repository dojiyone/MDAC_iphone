//
//  MypageViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/12/01.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface MypageViewController : TopViewController
{
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_candy_cnt;
    IBOutlet UILabel *lbl_post_cnt;
    IBOutlet UILabel *lbl_title_cnt;
    IBOutlet UILabel *lbl_follower;
    IBOutlet UILabel *lbl_following;
    IBOutlet UILabel *lbl_badge_count;
    IBOutlet UIImageView *icon_image;
    int Uid;
    
    IBOutlet UIButton *btn[4];
    
    IBOutlet UIScrollView *scrollViewmypage;
    IBOutlet UIScrollView *album_scrollView;
    UIImage *active_tab_image;
    UIImage *nonactive_tab_image;
    
    UIView *backuv;
    //int backwidth;
}

-(IBAction) album0_btn_down:(id)sender;
-(IBAction) album1_btn_down:(id)sender;
-(IBAction) album2_btn_down:(id)sender;
-(IBAction) album3_btn_down:(id)sender;
-(IBAction) album4_btn_down:(id)sender;


-(IBAction) left_btn_down:(id)sender;
-(IBAction) right_btn_down:(id)sender;

-(void)changeDataLoadMyPage:(int)albumNum;
-(void)showMyPageList:(int)nowSelectPage;
-(void)nextdataloadMypage;
@end
