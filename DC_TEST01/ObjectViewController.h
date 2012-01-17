//
//  ObjectViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/11/30.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondViewController.h"

@interface ObjectViewController : UIViewController
{
    
@public
    
    UIViewController *topViewController;
    UIViewController *rankingViewController;
    UIViewController *secondViewController;
    UIViewController *infoViewController;
    UIViewController *popularTagViewController;
    UIViewController *serchViewController;
    UIViewController *mypageViewController;
    UIViewController *postViewController;
    
    /*
    ObjectViewController *objectViewController;
    TopViewController *topViewController;
    RankingViewController *rankingViewController;
    SecondViewController *secondViewController;
    InfoViewController *infoViewController;
    PopularTagViewController *popularTagViewController;
    SerchViewController *serchViewController;
    MypageViewController *mypageViewController;
    PostViewController *postViewController;
    */
    //上ラベル
    IBOutlet UIButton *reload_btn;
    //上タブ
    IBOutlet UIButton *new_btn;
    IBOutlet UIButton *ranking_btn;
    IBOutlet UIButton *popular_tag_btn;
    IBOutlet UIButton *info_btn;
    //下タブ
    IBOutlet UIButton *mypage_btn;
    IBOutlet UIButton *serach_btn;
    IBOutlet UIButton *post_btn;
    IBOutlet UIButton *category_sort_btn;
    IBOutlet UIButton *setting_btn;
    
    IBOutlet UIImageView *img2;
}

@property (nonatomic,retain) UIViewController *topViewController;
@property (nonatomic,retain) UIViewController *rankingViewController;
@property (nonatomic,retain) UIViewController *infoViewController;

//上ラベル
-(IBAction) reload_btn_down:(id)sender;
//上タブ
-(IBAction) new_btn_down:(id)sender;
-(IBAction) ranking_btn_down:(id)sender;
-(IBAction) popular_tag_btn_down:(id)sender;
-(IBAction) info_btn_down:(id)sender;
//下タブ
-(IBAction) mypage_btn_down:(id)sender;
-(IBAction) serach_btn_down:(id)sender;
-(IBAction) post_btn:(id)sender;
-(IBAction) category_sort_btn_down:(id)sender;
-(IBAction) setting_btn_down:(id)sender;

@end
