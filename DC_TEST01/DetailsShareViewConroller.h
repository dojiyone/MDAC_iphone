//
//  DetailsShareViewConroller.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface DetailsShareViewConroller : TopViewController
{
    NSString *image_id;
    NSString *re_value;
    IBOutlet UIButton *mixi_share_btn;
    IBOutlet UIButton *fb_share_btn;
    IBOutlet UIButton *tw_share_btn;
    IBOutlet UIButton *sns_share_btn;
    
    IBOutlet UIImageView *main1;
    IBOutlet UIImageView *main2;
    IBOutlet UIImageView *main3;
    
    int miflag;
    int fbflag;
    int twflag;
    
    UITextField* textView;
    int loadTextView;
    //   NSMutableArray* dataSource_;
    IBOutlet UIScrollView *main_scrollView;
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *image_id;

-(void)inputShare:(NSString *)updateText:(NSString *)post_image_id:(int)Tw_post_flag:(int)Fb_post_flag:(int)Mx_post_flag;

-(NSString *)encodeShorten:(NSString *)imageString;

//-(void)tagButtonPressed:(id)sender;
-(IBAction)sns_share_btn_down:(id)sender;

-(IBAction)Twittershare:(id)sender;
-(IBAction)Facebookshare:(id)sender;
-(IBAction)Mixishare:(id)sender;

-(bool)TwittershareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle;
-(bool)FacebookshareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle;
-(bool)MixishareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle;
@end
