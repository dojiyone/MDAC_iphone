//
//  FanpageViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface FanpageViewController : TopViewController
{    
    IBOutlet UIScrollView *scrollViewfanpage;
    NSString *re_value;
    NSString *fanpage_id;
    int fid;
    
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_candy_cnt;
    IBOutlet UILabel *lbl_post_cnt;
    IBOutlet UILabel *lbl_title_cnt;
    IBOutlet UILabel *lbl_follower;
    IBOutlet UILabel *lbl_following;
    IBOutlet UILabel *lbl_add_reove_follow;
    IBOutlet UILabel *lbl_badge_count;
    
    
    IBOutlet UIButton *btn[4];
    IBOutlet UIScrollView *album_scrollView;
    UIImage *active_tab_image;
    UIImage *nonactive_tab_image;
    
    IBOutlet UIImageView *icon_image;
    int alertType;
    int followType;
    // NSString *f_name;
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *fanpage_id;


-(void)nextdataloadFanpage;

-(IBAction) album0_btn_down:(id)sender;
-(IBAction) album1_btn_down:(id)sender;
-(IBAction) album2_btn_down:(id)sender;
-(IBAction) album3_btn_down:(id)sender;
-(IBAction) album4_btn_down:(id)sender;

-(void)changeDataLoadMyPage:(int)albumNum;

-(IBAction) album0_btn_down:(id)sender;
-(IBAction) album1_btn_down:(id)sender;
-(IBAction) album2_btn_down:(id)sender;
-(IBAction) album3_btn_down:(id)sender;
-(IBAction) album4_btn_down:(id)sender;

-(void)showMyPageList:(int)albumID;

-(IBAction) saveFollow_btn_down:(id)sender;

-(IBAction) left_btn_down:(id)sender;
-(IBAction) right_btn_down:(id)sender;


//上ラベル
-(IBAction) back_btn_down:(id)sender;
-(IBAction) follow_btn_down:(id)sender;

@end
