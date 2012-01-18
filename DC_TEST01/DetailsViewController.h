//
//  DetailsViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/13.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface DetailsViewController : TopViewController
{
    
    NSString *re_value;
    IBOutlet UILabel *more1_label;
    IBOutlet UILabel *iine_label;
    IBOutlet UIImageView *detail_iamgeView;
    IBOutlet UIImageView *top_image;
    IBOutlet UIButton *img_btn_down;
    IBOutlet UIButton *iine_button;
    IBOutlet UILabel *iine_text;
    int iine_flag;
    
    int uploadFlag;
    int Tw_post_flag;
    int Fb_post_flag;
    int Mx_post_flag;
    
    int fid;
    
    UITextField *textField;
    NSString *uptext;
    int canReport;
    IBOutlet UIScrollView *main_scrollView;
    IBOutlet UIView *main_window;
    IBOutlet UIButton *detail_post_btn;
    IBOutlet UILabel *edit_label;
    IBOutlet UIButton *edit_btn;
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)UIButton *detail_post_btn;
@property (nonatomic,retain)IBOutlet UIView *main_window;
@property (nonatomic,retain)IBOutlet UIScrollView *main_scrollView;
/*@property int Tw_post_flag;
 @property int Fb_post_flag;
 @property int Mx_post_flag;
 @property (nonatomic,retain)IBOutlet UITextField* inputText;
 @property (nonatomic,retain)IBOutlet NSString *uptext;
 */
-(IBAction) iine_down:(id)sender;

- (UIImage*)imageByCropping:(UIImage *)imageToCrop;
- (void)details_info_load;
-(IBAction) postComment_btn_down:(id)sender;
-(IBAction) favorite_btn_down:(id)sender;
-(IBAction) img_btn_down:(id)sender;
-(IBAction) edit_btn_down:(id)sender;


-(void) uploadSNS;
@end
