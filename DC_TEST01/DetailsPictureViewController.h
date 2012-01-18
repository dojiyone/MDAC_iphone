//
//  DetailsPictureViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface DetailsPictureViewController : TopViewController
{
    IBOutlet UIScrollView *imgScrollView;
    IBOutlet UIImageView *myImage;
    
    NSString *re_value;
    NSString *real_path;
    IBOutlet UIImageView *title;
    IBOutlet UIButton *back_btn;
    IBOutlet UILabel *title_lbl;
    IBOutlet UILabel *btn_lbl;
    CGSize mainSize;
    NSDate *startTime;
    int startflag;
    int endflag;
    CGPoint nowSwipeCenter;
    CGPoint defaultRectTate;
    CGPoint defaultRectYoko;
    double defaultScaleTate;
    double defaultScaleYoko;
    int nowAngle;
    UIButton *backButton;
    UIImage *post_image;
    UILabel *backLabel;
}
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)UIImage *post_image;


-(void)showBackButton;
//-(void)moveImage:(id)sender;
-(int)getDirection;
-(void)returnDetailView;
-(void)showSetumeiLabel;
-(void)setDefaultAngle:(int)direction;
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
-(IBAction)swaip:(id)sender;

@end
