//
//  TopViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "DC_TEST01AppDelegate.h"
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>


@class NewViewController;
@class RankingViewController;
@class InfoViewController;
@class PopularTagViewController;
@class SecondViewController;
@class SerchViewController;
@class MypageViewController;
@class PostViewController;
@class TageditViewController;
@class loadingAPI;
@class SearchViewController;
@class CuratorViewController;

@class MysettingViewController;
@class FanpageViewController;
@class BadgViewController;
@class BlocklistViewController;
@class FollowerlistViewController;
@class FollowlistViewController;
@class SettingViewController;
@class TageditViewController;
@class AlubumIconViewController;
@class DetailsViewController;
@class DetailsDataViewController;
@class DetailsCommentsViewController;
@class DetailsShareViewConroller;
@class PostEditViewController;
@class TagpageViewController;
@class DetailsPictureViewController;

//Help関連
@class HelpView;
@class ruleView;
@class policyView;

@class GADBannerView, GADRequest;

@interface TopViewController : UIViewController <GADBannerViewDelegate,UIAlertViewDelegate,SA_OAuthTwitterEngineDelegate,SA_OAuthTwitterControllerDelegate,UIScrollViewDelegate>
{
    IBOutlet UINavigationController *_nav;
    //クラスインスタンス
    DC_TEST01AppDelegate *_DC_TEST01AppDelegate;
    TopViewController *_topViewController;
    NewViewController *_newViewController;
    RankingViewController *_rankingViewController;
    InfoViewController *_infoViewController;
    PopularTagViewController *_popularTagViewController;
    SecondViewController *_secondViewController;
    SerchViewController *_serchViewController;
    SearchViewController *_searchViewController;
    MypageViewController *_mypageViewController;
    PostViewController *_postViewController;
    TageditViewController *_tageditViewController;
    CuratorViewController *_curatorViewController;
    
    MysettingViewController *_mysettingViewController;
    FanpageViewController *_fanpageViewController;
    BadgViewController *_badgViewController;
    BlocklistViewController *_blocklistViewController;
    FollowerlistViewController *_followerlistViewController;
    FollowlistViewController *_followlistViewController;
    SettingViewController *_settingViewController;
    AlubumIconViewController *_alubumIconViewController;
    
    DetailsViewController *_detailsViewController;
    DetailsDataViewController *_detailsDataViewController;
    DetailsCommentsViewController *_detailsCommentsViewController;
    DetailsShareViewConroller *_detailsShareViewConroller;
    PostEditViewController *_postEditViewController;
    TagpageViewController *_tagpageViewController;
    DetailsPictureViewController *_detailsPictureViewController;
    
    HelpView *_helpView;
    ruleView *_ruleView;
    policyView *_policyView;
    
    
    loadingAPI *loadingapi;
    GADBannerView *adBanner_;
    
    id deligate;
    CGPoint _tBegan, _tEnded;
    
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
    
    IBOutlet UILabel *info_num;
    
    //写真表示エリア
    //IBOutlet UIScrollView *uiScrollView; 
	IBOutlet UIScrollView *scrollView;
	
    UIView* loadingView; // 処理中インジケータ画面
    UIActivityIndicatorView* indicator; // 処理中インジケータ
    
    //tutorial
    UIScrollView *sv;
    UIImage *img;
    UIImageView *iv;
    UIImage *check_img;
    UIButton *btn2;
    UIButton *btn3;
    
    IBOutlet UIImageView *test_img;
    
    NSString *value;
    
    BOOL alertFinished;
    UIView* badgView[3];
    UIScrollView *badgSv[3];
    
    int loadcount;
}

@property (nonatomic, retain)RankingViewController *_rankingViewController;
@property(nonatomic, retain) GADBannerView *adBanner;
@property(nonatomic, retain) IBOutlet UINavigationController *_nav;
@property(nonatomic,retain) TopViewController *_topViewController;
@property(nonatomic,retain) NSString *value;


- (GADRequest *)createRequest;
//上ラベル
-(IBAction) reload_btn_down:(id)sender;
-(IBAction) back_btn_down:(id)sender;
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

//Details4画面
-(IBAction) details_btn_down:(id)sender;
-(IBAction) detailsData_btn_down:(id)sender;
-(IBAction) detailsComments_btn_down:(id)sender;
-(IBAction) detailsShare_btn_down:(id)sender;


-(IBAction) saveReport_btn_down:(id)sender;


//Mypage Fanpage
-(IBAction) add_follow_btn_down:(id)sender;
-(IBAction) follow_btn_down:(id)sender;
-(IBAction) follower_btn_down:(id)sender;
-(IBAction) curator_btn_down:(id)sender;
-(IBAction) badge_btn_down:(id)sender;
-(IBAction) mypage_setting_btn_down:(id)sender;
-(IBAction) Alubum_icon_btn_down:(id)sender;
-(IBAction) block_btn_down:(id)sender;
-(IBAction) fanpage_btn_down:(id)sender;
-(IBAction) tagedit_btn_down:(id)sender;


-(void)badge_num;
- (void)netAccessStart;
- (void)netAccessEnd;

- (void) layoutScroll;
- (void) layoutScrollImages;
- (void) bannerLoad;

- (void)nextDataLoad;
- (void)ShowTutorial;
- (void) checkbox;
- (void)ShowActivity;
- (void)loginAlert;
- (bool)lockedAlert;
- (bool)lockedAlert2;
- (void)willPresentAlertView:(UIAlertView *)alertView;
- (void)tweetFromApplication;

- (void) deleteButtonPressed:(id)sender;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;



@end
