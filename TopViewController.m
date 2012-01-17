//
//  TopViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "loadingAPI.h"

#import "TopViewController.h"
#import "NewViewController.h"
#import "RankingViewController.h"
#import "InfoViewController.h"
#import "PopularTagViewController.h"
#import "SecondViewController.h"
#import "SerchViewController.h"
#import "MypageViewController.h"
#import "PostViewController.h"
#import "SearchViewController.h"
#import "SearchViewCtrl.h"
#import "TageditViewController.h"
#import "CuratorViewController.h"
#import "MysettingViewController.h"
#import "FanpageViewController.h"
#import "BadgViewController.h"
#import "BlocklistViewController.h"
#import "FollowerlistViewController.h"
#import "FollowlistViewController.h"
#import "SettingViewController.h"
#import "TageditViewController.h"
#import "AlubumIconViewController.h"
#import "DetailsViewController.h"
#import "DetailsDataViewController.h"
#import "DetailsCommentsViewController.h"
#import "DetailsShareViewConroller.h"
#import "PostEditViewController.h"
#import "TagpageViewController.h"
#import "DetailsPictureViewController.h"
#import "MGTwitterEngine.h"
#import "SA_OAuthTwitterEngine.h"

#import "HelpView.h"
#import "ruleView.h"
#import "policyView.h"

#import "GADBannerView.h"
#import "GADRequest.h"


const CGFloat kScrollObjHeight	= 106.67;
const CGFloat kScrollObjWidth	= 106.67;
const NSUInteger kNumImages		= 1;

@class loadingAPI;

@implementation TopViewController

@synthesize _rankingViewController;
@synthesize _topViewController;
@synthesize adBanner = adBanner_;
@synthesize _nav;


-(void) viewDidLoad
{
    //Tutorial表示関連//
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    int flag = [defaults integerForKey:@"TUTORIAL_FLAG"];
    [defaults setInteger:0 forKey:@"FROM_ALBUM_FLAG"];
    if(flag ==0)[self ShowTutorial];
    
    //[self bannerLoad];    
    [self nextDataLoad];
    
    
    test_img.userInteractionEnabled = YES;
    [test_img setMultipleTouchEnabled:YES];
    
    //詳細はどこをを経由したか？YES
    //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
    
    
    [self badge_num];
    check_img =[UIImage imageNamed:@"checkbox.gif"];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // 通知センターに通知要求を登録する
    // この例だと、通知センターに"Tuchi"という名前の通知を行う
    [nc addObserver:self selector:@selector(detailButtonPressed:) name:@"Tuchi" object:nil];
}

-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







//ロード完了読み込み////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    //アクティビティ表示
    [self ShowActivity];
}

-(void)badge_num
{
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getNewActivity];//未読アクティビティ最終的に採用する
    NSLog(@"restmp %@",restmp);
    int num = [[restmp objectForKey:@"result"] count];
    info_num.text = [NSString stringWithFormat:@"%d",num];
}

-(void)detailButtonPressed:(NSNotificationCenter*)center
{
    // 通知の送信側から送られた値を取得する
    value = [[center userInfo] objectForKey:@"imageID"];
    //NSLog(@"Value=%@",value);
    int num = [value intValue];
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    NSDictionary *restmp2=[loadingapi detailPostimage:num :NULL];
    //NSDictionary *resDic2 = [restmp2 objectForKey:@"result"];
    NSLog(@"detailrestmp2 %@",restmp2);
    int fid ;

    
    
    int count=[[restmp2 objectForKey:@"result"] count];
    //if ([restmp2 objectForKey:@"result"]==@""||[restmp2 objectForKey:@"result"]==nil) 
    if(count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"エラー"
                              message:@"この写真は削除されたためご覧になれません。"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }    
    NSLog(@"count %d",count);
    int lockedCheck=0;
    int delCheck;
    for (int i=0; i<count; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp2 objectForKey:@"result"] objectAtIndex:i];
        
        
        
        for (NSDictionary *dic in result) 
        {
            fid = [[dic objectForKey:@"uid"]integerValue];
        }
    }

    
    //ブロック判定
    NSDictionary *restmp3= [loadingapi isBlockUser:fid];
    NSDictionary *resDic3 = [restmp3 objectForKey:@"result"];
    if([[resDic3 objectForKey:@"blocked"]intValue] == 1)
    {
        NSLog(@"ISbloac %@",[resDic3 objectForKey:@"blocked"]);
        
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"エラー"
                             message:@"このページにはアクセスできません。"
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
    
    _detailsViewController.re_value = value;
    [self._nav pushViewController:_detailsViewController animated:NO];
    
    NSLog(@"%d",loadcount);
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    //[self netAccessStart];
}




- (void)nextDataLoad
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* category=[defaults stringForKey:@"MDAC_CATEGORY"];
    if(category==nil)  
    {
        category=@"0%2c1";
        [defaults setObject:category forKey:@"MDAC_CATEGORY"];
    }
    
    loadingapi = [[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getPickupPicture];
    
    
	SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] init];  
    [searchViewCtrl bannerLoad:self];
    
    //読み込み数を設定
    searchViewCtrl->offset=0;
    searchViewCtrl->limit=19;
    
    
    
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    searchViewCtrl->uv=uv;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    
    int offset=searchViewCtrl->offset-1;
    int limit=searchViewCtrl->limit +1; 
    [scrollView addSubview:searchViewCtrl.view];
    [searchViewCtrl getPostimageByNewList :offset:limit];//オフセット(pickup分+１)、読み込み数
    //[searchViewCtrl showEnd];
    
    [searchViewCtrl showImgPicComment:restmp];
    //[searchViewCtrl getPickupPicture];//背景の上に描画したいので後から
    [self netAccessEnd];
}


-(void)bannerLoad
{
    /*
    self.adBanner = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                     self.view.frame.size.height-53,
                                                                     GAD_SIZE_320x50.width,
                                                                     GAD_SIZE_320x50.height)] autorelease];
    self.adBanner.adUnitID = MY_BANNER_UNIT_ID;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self createRequest]];
    */
    //adBanner_=self.adBanner;
}
/*
 -(void)layoutScroll
 {
 // note: the following can be done in Interface Builder, but we show this in code for clarity
 [scrollView setBackgroundColor:[UIColor blackColor]];
 [scrollView setCanCancelContentTouches:YES];
 scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
 scrollView.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our scrollview
 scrollView.scrollEnabled = YES;
 scrollView.delegate =self;
 // pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
 // if you want free-flowing scroll, don't set this property.
 scrollView.pagingEnabled = YES;
 
 
 //API起動
 loadingapi = [[loadingAPI alloc] init];
 [loadingapi getPickupPicture];
 NSUInteger piccount= [loadingapi getNowOffsetLoadCount];
 
 [loadingapi getPostimageByNewList :0:39];//オフセット、読み込み数
 
 NSUInteger i=piccount;
 UIImage *image;
 }
 */
-(void)loginAlert
{
    
    // 複数行で書くタイプ（複数ボタンタイプ）
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"SNSにログインが必要です";
    alert.message = @"この操作を行うには、各SNSにログインが必要です。OKを押すと設定画面が開きます";
    [alert addButtonWithTitle:@"キャンセル"];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}


//運営がロックしてるかチェック
-(bool)lockedAlert
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    NSString *lockedTitle=@"";
    NSString *lockedMess=@"";
    NSDictionary *restmp;
    bool lockedCheck=false;
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //ユーザーが削除されてるか確認
    
    restmp= [loadingapi getUserInfo:Uid];
    NSLog(@"lock %@",restmp);
    int count=[[restmp objectForKey:@"result"] count];
    for (int i=0; i<count; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            if([[dic objectForKey:@"del_flag"]integerValue]==1)
            {
                lockedCheck=true;
                lockedTitle=@"システムエラー";
                lockedMess=@"システムエラーが発生しました";
            }
            else if([[dic objectForKey:@"lock_flag"]integerValue]==1)
            {
                lockedCheck=true;
                lockedTitle=@"注意";
                lockedMess=[NSString stringWithFormat:@"あなたのアカウントはロックされています。ロック解除については運営までお問い合わせください。\n管理ID:%d",Uid];                
            }
        }
    }
    /*return false;
     
     restmp= [loadingapi isLocked];
     NSLog(@"lock %@",restmp);
     
     int nowLock2= [[[restmp objectForKey:@"result"] objectForKey:@"locked"]integerValue];
     if(nowLock2==1)
     {
     
     lockedCheck=true;
     lockedTitle=@"注意";
     lockedMess=[NSString stringWithFormat:@"あなたのアカウントはロックされています。ロック解除については運営までお問い合わせください。\n管理ID:%d",Uid];
     }
     */
    
    //ロック中
    if(lockedCheck==true)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:lockedTitle
                              message:lockedMess
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
    return lockedCheck;
}

-(bool)lockedAlert2
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    NSString *lockedTitle=@"";
    NSString *lockedMess=@"";
    NSDictionary *restmp;
    bool lockedCheck=false;
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    
    //ユーザーが削除されてるか確認
    
    restmp= [loadingapi getUserInfo:Uid];
    NSLog(@"lock %@",restmp);
    int count=[[restmp objectForKey:@"result"] count];
    for (int i=0; i<count; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            if([[dic objectForKey:@"del_flag"]integerValue]==1)
            {
                lockedCheck=true;
                lockedTitle=@"システムエラー";
                lockedMess=@"システムエラーが発生しました";
            }
            else if([[dic objectForKey:@"lock_flag"]integerValue]==1)
            {
                lockedCheck=true;
                lockedTitle=@"注意";
                lockedMess=[NSString stringWithFormat:@"あなたのアカウントはロックされています。ロック解除については運営までお問い合わせください。\n管理ID:%d",Uid];                
            }
        }
    }
    /*return false;
     
     restmp= [loadingapi isLocked];
     NSLog(@"lock %@",restmp);
     
     int nowLock2= [[[restmp objectForKey:@"result"] objectForKey:@"locked"]integerValue];
     if(nowLock2==1)
     {
     
     lockedCheck=true;
     lockedTitle=@"注意";
     lockedMess=[NSString stringWithFormat:@"あなたのアカウントはロックされています。ロック解除については運営までお問い合わせください。\n管理ID:%d",Uid];
     }
     */
    
    //ロック中
    if(lockedCheck==true)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:lockedTitle
                              message:lockedMess
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
    return lockedCheck;
}


// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 2){
        switch (buttonIndex) {
            case 0:
                //１番目のボタンが押されたときの処理を記述する
                alertFinished = YES;
                break;
            case 1:
                //２番目のボタンが押されたときの処理を記述する
                
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 0:
                //１番目のボタンが押されたときの処理を記述する
                break;
            case 1:
                //２番目のボタンが押されたときの処理を記述する
                
                
                //設定画面で登録を促す
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                _secondViewController = [[SecondViewController alloc] 
                                         initWithNibName:@"SecondView" 
                                         bundle:nil];
                [self.navigationController pushViewController:_secondViewController 
                                                     animated:YES];
                break;
        }
    }
}


//画面遷移関係
-(IBAction) reload_btn_down:(id)sender;
{
    /*
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     _tageditViewController = [[TageditViewController alloc] 
     initWithNibName:@"TageditViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_tageditViewController 
     animated:YES];
     */
    [self nextDataLoad];
}

-(IBAction) back_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:NO];
}

//上タブ
-(IBAction) new_btn_down:(id)sender;
{
    BOOL pass_ranking = NO;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
    NSLog(@"deteails back%d",pass_ranking);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController  popToRootViewControllerAnimated:NO];
}

-(IBAction) ranking_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _rankingViewController = [[RankingViewController alloc] 
                              initWithNibName:@"RankingViewController" 
                              bundle:nil];
	[self.navigationController pushViewController:_rankingViewController 
										 animated:NO];
}


-(IBAction) popular_tag_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _popularTagViewController = [[PopularTagViewController alloc] 
                                 initWithNibName:@"PopularTagViewController" 
                                 bundle:nil];
	[self.navigationController pushViewController:_popularTagViewController 
										 animated:NO];
    
}

-(IBAction) info_btn_down:(id)sender;
{    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _infoViewController = [[InfoViewController alloc] 
                           initWithNibName:@"InfoViewController" 
                           bundle:nil];
	[self.navigationController pushViewController:_infoViewController 
										 animated:NO];
    
    
}


//下タブ
-(IBAction) mypage_btn_down:(id)sender;
{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _mypageViewController = [[MypageViewController alloc] 
                             initWithNibName:@"MypageViewController" 
                             bundle:nil];
    
	[self.navigationController pushViewController:_mypageViewController
										 animated:YES];
    
}

-(IBAction) serach_btn_down:(id)sender;
{    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _searchViewController = [[SearchViewController alloc] 
                             initWithNibName:@"SearchViewController" 
                             bundle:nil];
	[self.navigationController pushViewController:_searchViewController 
										 animated:YES];
    
    
}

-(IBAction) post_btn:(id)sender;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }
    else
    {
        if([self lockedAlert]==true)    return;//ロックチェック
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _postViewController = [[PostViewController alloc] 
                           initWithNibName:@"PostViewController" 
                           bundle:nil];
	[self.navigationController pushViewController:_postViewController 
										 animated:YES];
    
}
-(IBAction) saveReport_btn_down:(id)sender;
{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }
    else
    {
        if([self lockedAlert]==true)    return;//ロックチェック
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(IBAction) category_sort_btn_down:(id)sender;
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* category=[defaults stringForKey:@"MDAC_CATEGORY"];
    // int nowcategory = [category intValue];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"キャンセル"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"dogs",
                                  @"cats",
                                  @"dogs&cats",
                                  nil];
    if ([category isEqualToString:@"0"]){
        actionSheet.destructiveButtonIndex = 0; 
    }
    else if ([category isEqualToString:@"1"]){
        actionSheet.destructiveButtonIndex = 1; 
    }
    else     if ([category isEqualToString:@"0%2c1"]){
        actionSheet.destructiveButtonIndex = 2; 
    }
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:sender];
    [actionSheet release];    
    
}
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //番号別変更
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* category=[defaults stringForKey:@"MDAC_CATEGORY"];
    //NSLog(@"%d",buttonIndex);
    NSString *upCategory;
    switch (buttonIndex) {
        case 0:upCategory=@"0";
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            [self nextDataLoad];
            break;
        case 1:upCategory=@"1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            [self nextDataLoad];
            break;  
        case 2 :upCategory=@"0%2c1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            [self nextDataLoad];
            break;   
        case 3:
        default:  upCategory=category; 
            break;    
    }
    
}


-(IBAction) setting_btn_down:(id)sender;
{NSLog(@"@%@",[self nibName]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _secondViewController = [[SecondViewController alloc] 
                             initWithNibName:@"SecondView" 
                             bundle:nil];
	[self.navigationController pushViewController:_secondViewController 
										 animated:YES];
    
}

//詳細4画面
-(IBAction) details_btn_down:(id)sender;
{
    NSLog(@"@%@",[self nibName]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
	[self.navigationController pushViewController:_detailsViewController 
										 animated:NO];
    
    
}

-(IBAction) detailsData_btn_down:(id)sender;
{NSLog(@"@%@",[self nibName]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsDataViewController = [[DetailsDataViewController alloc] 
                                  initWithNibName:@"DetailsDataViewController" 
                                  bundle:nil];
	[self.navigationController pushViewController:_detailsDataViewController 
										 animated:NO];
    
}

-(IBAction) detailsComments_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsCommentsViewController = [[DetailsCommentsViewController alloc] 
                                      initWithNibName:@"DetailsCommentsViewController" 
                                      bundle:nil];
	[self.navigationController pushViewController:_detailsCommentsViewController 
										 animated:NO];
    
}

-(IBAction) detailsShare_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsShareViewConroller = [[DetailsShareViewConroller alloc] 
                                  initWithNibName:@"DetailsShareViewConroller" 
                                  bundle:nil];
    [self.navigationController pushViewController:_detailsShareViewConroller 
                                         animated:NO];
}


//mypage fanpage
-(IBAction) add_follow_btn_down:(id)sender{
    
    NSLog(@"@%@",[self nibName]);
}
-(IBAction) follow_btn_down:(id)sender{    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followlistViewController = [[FollowlistViewController alloc] 
                                 initWithNibName:@"FollowlistViewController" 
                                 bundle:nil];
	[self.navigationController pushViewController:_followlistViewController 
										 animated:YES];
    
}
-(IBAction) follower_btn_down:(id)sender{   
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followerlistViewController = [[FollowerlistViewController alloc] 
                                   initWithNibName:@"FollowerlistViewController" 
                                   bundle:nil];
	[self.navigationController pushViewController:_followerlistViewController 
										 animated:YES];
    
}
-(IBAction) curator_btn_down:(id)sender{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _curatorViewController = [[CuratorViewController alloc] 
                              initWithNibName:@"CuratorViewController" 
                              bundle:nil];
	[self.navigationController pushViewController:_curatorViewController 
										 animated:YES];
    
}
-(IBAction) badge_btn_down:(id)sender{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _badgViewController = [[BadgViewController alloc] 
                           initWithNibName:@"BadgViewController" 
                           bundle:nil];
	[self.navigationController pushViewController:_badgViewController 
										 animated:YES];
    
}
-(IBAction) mypage_setting_btn_down:(id)sender{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _mysettingViewController = [[MysettingViewController alloc] 
                                initWithNibName:@"MysettingViewController" 
                                bundle:nil];
	[self.navigationController pushViewController:_mysettingViewController 
										 animated:YES];
    
}


-(IBAction) Alubum_icon_btn_down:(id)sender{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _alubumIconViewController = [[AlubumIconViewController alloc] 
                                 initWithNibName:@"AlubumIconViewController" 
                                 bundle:nil];
	[self.navigationController pushViewController:_alubumIconViewController 
										 animated:YES];
    
}

-(IBAction) block_btn_down:(id)sender{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _blocklistViewController = [[BlocklistViewController alloc] 
                                initWithNibName:@"BlocklistViewController" 
                                bundle:nil];
	[self.navigationController pushViewController:_blocklistViewController 
										 animated:YES];
    
}

-(IBAction) fanpage_btn_down:(id)sender{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    _fanpageViewController = [[FanpageViewController alloc] 
                              initWithNibName:@"FanpageViewController" 
                              bundle:nil];
	[self.navigationController pushViewController:_fanpageViewController 
										 animated:YES];
    
}

-(IBAction) tagedit_btn_down:(id)sender{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }
    else
    {
        if([self lockedAlert]==true)    return;//ロックチェック
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _tageditViewController = [[TageditViewController alloc] 
                              initWithNibName:@"TageditViewController" 
                              bundle:nil];
	[self.navigationController pushViewController:_tageditViewController 
										 animated:YES];
}



//チュートリアル表示////////////////////////////////////////////////////
- (void)ShowTutorial
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int flag = [defaults integerForKey:@"TUTORIAL_FLAG"];
    
    
    //半透明の黒背景背景
    loadingView = [[UIView alloc] initWithFrame:[[self view] bounds]];
    loadingView.frame = CGRectMake(0, 0, 320, 480);
    [loadingView setBackgroundColor:[UIColor blackColor]];
    [loadingView setAlpha:0.5];
    [self.view addSubview:loadingView];
    
    //スクロールビューを定義
    sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sv.backgroundColor = [UIColor clearColor];
    
    //チュートリアル画像を追加
    img = [UIImage imageNamed:@"tutorial_jp.png"];
    iv = [[UIImageView alloc] initWithImage:img];
    iv.center = CGPointMake(160, 500);
    
    sv.contentSize = iv.bounds.size;
    
    //スクロールを描画
    [self.view addSubview:sv];
    //チュートリアルを描画
    [sv addSubview:iv];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.hidden =NO;
    btn.frame = CGRectMake(275, 18, 30, 30);
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"close2.png"] forState:UIControlStateNormal]; 
    [btn addTarget:self action:@selector(hoge:)forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn];
    
    //チェックボックス
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.hidden =NO;
    btn2.frame = CGRectMake(15, 15, 30, 30);
    [btn2 setTitle:@"" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"checkbox.gif"] forState:UIControlStateNormal]; 
    [btn2 addTarget:self action:@selector(checkbox)forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    if(flag==1)    btn3.hidden =YES;
    else           btn3.hidden =NO;    
    
    btn3.frame = CGRectMake(15, 15, 30, 30);
    [btn3 setTitle:@"" forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"checkbox_on.gif"] forState:UIControlStateNormal]; 
    [btn3 addTarget:self action:@selector(checkbox)forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn3];
    
    UILabel *uLabel = [[UILabel alloc] init];
    uLabel.frame = CGRectMake(42, -5 , 200, 70);
    uLabel.backgroundColor= [UIColor clearColor];
    uLabel.font = [UIFont boldSystemFontOfSize:14];
    uLabel.textAlignment = UITextAlignmentLeft;
    uLabel.text = @"次回起動時も表示する";
    [sv  addSubview:uLabel];
}



//アクティビティの次回起動チェック
-(void) checkbox
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int flag = [defaults integerForKey:@"TUTORIAL_FLAG"];
    if(flag ==0)
    {
        btn3.hidden =YES;
        [defaults setInteger:1 forKey:@"TUTORIAL_FLAG"];
    }
    else
    {    
        btn3.hidden =NO;
        [defaults setInteger:0 forKey:@"TUTORIAL_FLAG"];
    }
    
    NSLog(@"flag %d" , [defaults integerForKey:@"TUTORIAL_FLAG"]);
    
}


//アクティビティの表示///////////////////////////////////////////////////
- (void)ShowActivity
{
    //Activityの有無を確認
    loadingapi = [[loadingAPI alloc] init];
    NSDictionary *restmp =[loadingapi getNewActivity];    
    
    NSLog(@"%@",[restmp objectForKey:@"result"]);
    int i;
    int cnt = [[restmp objectForKey:@"result"] count];
    
    //アクティビティなし
    if(cnt<=0) return;
    
    
    //  SecondViewController *svc = [[SecondViewController alloc]init]; 
    //  if([svc getSnsLoginStatus:1]==1)Tw_post_flag =1;
    //  if([svc getSnsLoginStatus:2]==1)Fb_post_flag =1;
    //  if([svc getSnsLoginStatus:3]==1)Mx_post_flag =1;
    
    
    
    
    DetailsShareViewConroller *dts = [[DetailsShareViewConroller alloc]init];
    
    
    NSString *actMsg=@"";
    NSString *pic_path=@"badge03_01.png";
    NSString *activity_type;
    //int activity_id;
    for (i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog(@"res %@",result);
        for (NSDictionary *dic in result) 
        {
            activity_type=[dic objectForKey:@"activity_type"];
            NSString *activity_id=[dic objectForKey:@"activity_id"];
            
            if ([activity_type isEqualToString:@"EV00"])
            {
                actMsg=@"スタートアップ参加！／スタートアップバッジを入手！";
                pic_path=@"badge03_01.png";
            }
            else if ([activity_type isEqualToString:@"EV01"])
            {
                actMsg=@"お誕生日おめでとう！／ハッピーバスデーバッジを入手！";
                pic_path=@"badge03_02.png";
            }
            //
            else if([activity_type isEqualToString:@"SN00"])
            {
                actMsg=@"初めてのSNS投稿！／SNS投稿デビューバッジを入手！";
                pic_path=@"badge02_01.png";        
            }
            else if([activity_type isEqualToString:@"SN01"])
            {
                actMsg=@"SNS投稿×10回達成！／「Thanks share!ブロンズ」バッジを入手！";
                pic_path=@"badge02_02.png";        
            }
            else if([activity_type isEqualToString:@"SN02"])
            {
                actMsg=@"SNS投稿×50回達成！／「Thanks share!シルバー」バッジを入手！";
                pic_path=@"badge02_03.png";        
            }
            else if([activity_type isEqualToString:@"SN03"])
            {
                actMsg=@"SNS投稿×100回達成！／「Thanks share!ゴールド」バッジを入手！";
                pic_path=@"badge02_04.png";        
            }
            else if([activity_type isEqualToString:@"SN04"])
            {
                actMsg=@"SNS投稿×300回達成！／「Thanks share!ダイヤ」バッジを入手！";
                pic_path=@"badge02_05.png";        
            }
            //
            else if([activity_type isEqualToString:@"II00"])
            {
                actMsg=@"初めてのイイネ！／イイネデビューバッジを入手！";
                pic_path=@"badge01_01.png";        
            }
            else if([activity_type isEqualToString:@"II01"])
            {
                actMsg=@"イイネ×5回達成！／「ドッグリスト」バッジを入手！";
                pic_path=@"badge01_02.png"; 
            }
            else if([activity_type isEqualToString:@"II02"])
            {
                actMsg=@"隠れネコ派バッジを入手！";
                pic_path=@"badge01_03.png";
            }
            else if([activity_type isEqualToString:@"II03"])
            {
                actMsg=@"イイネ×10回達成！／「ブロンズドッグリスト」バッジを入手！";
                pic_path=@"badge01_04.png";
            }
            else if([activity_type isEqualToString:@"II04"])
            {
                actMsg=@"イイネ×50回達成！／「シルバードッグリスト」バッジを入手！";
                pic_path=@"badge01_05.png";
            }
            else if([activity_type isEqualToString:@"II05"])
            {
                actMsg=@"イイネ×100回達成！／「ゴールデンドッグリストバッジを入手！";
                pic_path=@"badge01_06.png";
            }
            else if([activity_type isEqualToString:@"II06"])
            {
                actMsg=@"イイネ×5回達成！／「キャットリスト」とバッジを入手！";
                pic_path=@"badge01_07.png";
            }
            else if([activity_type isEqualToString:@"II07"])
            {
                actMsg= @"隠れ犬派バッジを入手！";
                pic_path=@"badge01_08.png";
            }
            else if([activity_type isEqualToString:@"II08"])
            {
                actMsg=@"イイネ×10回達成！／「ブロンズ・キャットリスト」バッジを入手！";
                pic_path=@"badge01_09.png";
            }
            else if([activity_type isEqualToString:@"II09"])
            {
                actMsg=@"イイネ×50回達成！／｢シルバー・キャットリスト｣バッジを入手！";
                pic_path=@"badge01_10.png";
            }
            else if([activity_type isEqualToString:@"II10"])
            {
                actMsg=@"イイネ×100回達成！／「ゴールド・キャットリスト」バッジを入手！";
                pic_path=@"badge01_11.png";
            }
            else if([activity_type isEqualToString:@"PO00"])
            {
                actMsg=@"おめでとうございます！あなたの投稿した写真に5人のｆａｎが「イイネ!」をつけましたので「よくできました」バッジを入手!";
                pic_path=@"badge04_01.png";
            }
            else if([activity_type isEqualToString:@"PO01"])
            {
                actMsg=@"おめでとうございます！あなたの投稿した写真に50人のｆａｎが「イイネ!」をつけましたので「よくできました」バッジを入手!";
                pic_path=@"badge04_02.png";
            }
            
            
            /*      UIAlertView* alert = [[[UIAlertView alloc]initWithTitle:@"　"
             message:@"　"
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:nil, nil
             ]autorelease];
             [alert addButtonWithTitle:@"OK"];
             alert.tag = 2;
             
             UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pic_path]];
             image.center = CGPointMake(142, 130);
             
             UILabel *uLabel = [[UILabel alloc] init];
             uLabel.frame = CGRectMake(20, 215 , 200, 70);
             uLabel.font = [UIFont boldSystemFontOfSize:14];
             uLabel.textAlignment = UITextAlignmentLeft;
             uLabel.text = actMsg;
             
             [alert addSubview:image];
             [alert show];
             //アラートでボタンを押すまで動作を中断する（待つ）
             alertFinished = NO;
             */ /*    while (alertFinished == NO) 
                 { 
                 [[NSRunLoop currentRunLoop]
                 runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]]; //0.5秒
                 }*/
            /* NSLog(@"i%d",i);
             [image release];
             */
            
            
            if(cnt>=3)return;
            
            //Activiy update proc
            //半透明の黒背景背景
            badgView[i] = [[UIView alloc] initWithFrame:[[self view] bounds]];
            [badgView[i] setBackgroundColor:[UIColor blackColor]];
            [badgView[i] setAlpha:0.5];
            //badgView[i].accessibilityIdentifier=activity_id;
            [[self view] addSubview:badgView[i]];
            
            //スクロールビューを定義
            badgSv[i] = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 100, 240, 280)];
            badgSv[i].backgroundColor = [UIColor whiteColor];
            badgSv[i].layer.masksToBounds = YES;  
            badgSv[i].layer.cornerRadius = 10; 
            [badgSv[i] setAlpha:0.0];
            //badgSv[i].accessibilityValue=activity_id;
            
            //アニメーションの対象となるコンテキスト
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            //アニメーションを実行する時間
            [UIView setAnimationDuration:0.5];
            //アニメーションイベントを受け取るview
            [UIView setAnimationDelegate:self];
            //アニメーション終了後に実行される
            [UIView setAnimationDidStopSelector:@selector(endAnimation)];
            
            //TODO: 
            [badgSv[i] setAlpha:1.0];
            // アニメーション開始
            [UIView commitAnimations];	
            
            
            //チュートリアル画像を追加
            img = [UIImage imageNamed:pic_path];
            iv = [[UIImageView alloc] initWithImage:img];
            iv.center = CGPointMake(120, 110);
            
            badgSv[i].contentSize = iv.bounds.size;
            
            //ユーザー名
            UILabel *uLabel = [[UILabel alloc] init];
            uLabel.backgroundColor = [UIColor clearColor];
            [uLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel setNumberOfLines:0];
            
            uLabel.frame = CGRectMake(20, 215 , 200, 70);
            //uLabel.textColor = [UIColor Color];
            uLabel.font = [UIFont boldSystemFontOfSize:14];
            uLabel.textAlignment = UITextAlignmentLeft;
            uLabel.text = actMsg;
            
            [badgSv[i] addSubview:uLabel];
            
            //スクロールを描画
            [self.view addSubview:badgSv[i]];
            //チュートリアルを描画
            [badgSv[i] addSubview:iv];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.hidden =NO;
            btn.tag=i;
            [btn setAccessibilityLabel:activity_id];
            btn.frame = CGRectMake(0, 0, 240, 280);
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal]; 
            [btn addTarget:self action:@selector(hoge2:)forControlEvents:UIControlEventTouchDown];
            
            [badgSv[i] addSubview:btn];
            
            //バッジデータ削除
            [loadingapi updateReadFlag:activity_id];
            
            
            //メインSNSにバッジ情報を投稿
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];    
            NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];    
            if ([MainSNS isEqualToString:@"twitter"])
            {
                [dts inputShare:actMsg:nil:1:0:0];//SNSに投稿
            }
            else if ([MainSNS isEqualToString:@"facebook"])
            {
                [dts inputShare:actMsg:nil:0:1:0];
            }
            else if ([MainSNS isEqualToString:@"mixi"])
            {
                [dts inputShare:actMsg:nil:0:0:1];
            }
        }
    }
    [dts release];
}
/*
 - (void)willPresentAlertView:(UIAlertView *)alertView{
 if (alertView.tag == 2) {
 CGRect frame = alertView.frame;
 frame.origin.y = 70;
 frame.size.height = 350;
 alertView.frame = frame;
 
 for (UIView* view in alertView.subviews){
 frame = view.frame;
 if (frame.origin.y > 44) {
 frame.origin.y += 210;
 view.frame = frame;
 }
 }
 }
 }
 */

-(void)hoge:(UIButton*)button{
    button.hidden =YES;
    [loadingView removeFromSuperview];
    [sv removeFromSuperview];
}

//アクティビティページの除去
-(void)hoge2:(UIButton*)button
{
    // UIScrollView *badgeSv=button;
    /*   NSLog(@"hoge2lebel %@",button.accessibilityLabel);
     
     NSString *activity_id=button.accessibilityHint;
     
     //チェックしたアクティビティのoff
     loadingapi = [[loadingAPI alloc] init];
     NSDictionary *restmp =[loadingapi updateReadFlag:activity_id];
     NSLog(@"actoff %@",restmp);
     */
    
    button.hidden =YES;
    [badgView[button.tag] removeFromSuperview];
    [badgSv[button.tag] removeFromSuperview];
}


- (void)netAccessStart {
    
    // ネットワークアクセスインジケータON（画面中央）
    loadingView = [[UIView alloc] initWithFrame:[[self view] bounds]];
    [loadingView setBackgroundColor:[UIColor blackColor]];
    [loadingView setAlpha:0.5];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [[self view] addSubview:loadingView];
    [loadingView addSubview:indicator];
    [indicator setFrame:CGRectMake ((320/2)-20, (480/2)-60, 40, 40)];
    [indicator startAnimating];
    
}

- (void)netAccessEnd {
    
    // 画面中央の処理中インジケータ表示OFF
    [indicator stopAnimating];
    //[loadingView removeFromSuperview];
    
}


- (void)dealloc {
    //self.adBanner.delegate = nil;
    //[adBanner_ release];
    [super dealloc];
}





#pragma mark GADRequest generation

// Here we're creating a simple GADRequest and whitelisting the simulator
// and two devices for test ads. You should request test ads during development
// to avoid generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    //Make the request for a test ad
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,                               // Simulator
                           nil];
    
    return request;
}

#pragma mark GADBannerViewDelegate impl

//グーグルアドセンス処理
// Since we've received an ad, let's go ahead and set the frame to display it.
- (void)adViewDidReceiveAd:(GADBannerView *)adView 
{
    NSLog(@"Received ad");
    
    [UIView animateWithDuration:1.0 animations:^ {
        adView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  adView.frame.size.height-47,
                                  adView.frame.size.width,
                                  adView.frame.size.height);
    }];
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error 
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


#pragma mark アクティビティの分岐処理
- (void)adView
{
    NSLog(@"test");
}





@end
