//
//  FanpageViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#define cAlertType_A 0
#define cAlertType_B 1
#define cAlertType_C 2
#define cAlertType_D 3

//#import "TopViewController.h"
#import "FanpageViewController.h"
#import "DetailsDataViewController.h"
#import "loadingAPI.h"
#import "SearchViewCtrl.h"
#import "UIAsyncImageView.h"
#import "FollowlistViewController.h"
#import "FollowerlistViewController.h"
#import "BadgViewController.h"
#import "CuratorViewController.h"
@implementation FanpageViewController

@synthesize re_value;
@synthesize fanpage_id;

-(void) viewDidLoad
{    
    
    //default受け取り
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    fid=[[defaults stringForKey:@"FOLLOW_ID"] intValue];  
    
    [defaults setInteger:fid forKey:@"FROM_ALBUM_FLAG"];
    
    NSLog(@"@FanpageViewController=%d",fid);
    
    
    //アルバムスクロールの初期化
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getFanTitleList:fid];
    NSLog(@"getTitleList%@",restmp);    
    int ID=5;
    int cu_count = [[restmp objectForKey:@"result"] count];
    if(cu_count >0){
        for (int i=0; i<1; i++) 
        {
            NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
            for (NSDictionary *dic in result) 
            {
                ID = [[dic objectForKey:@"rank"]intValue];
            }
        }
    }
    NSDictionary *restmp2 = [loadingapi getAlbumList:fid];
    NSLog(@"アルバム一覧 %@",restmp2);
    
    int cnt = [[restmp2 objectForKey:@"result"] count];
    
    active_tab_image = [UIImage imageNamed:@"fanpage_tab_1.png"];
    nonactive_tab_image = [UIImage imageNamed:@"fanpage_tab_0.png"];
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp2 objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            // 画像を指定したボタン例文
            btn[i] = [[[UIButton alloc] 
                       initWithFrame:CGRectMake(0+(i*107), 0, 107, 37)] autorelease];  // ボタンのサイズを指定する
            [btn[i] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];  // 画像をセットする
            // ボタンが押された時にhogeメソッドを呼び出す
            if(i == 0)[btn[i] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
            [album_scrollView addSubview:btn[i]];
            
            
            //アルバム名
            UILabel *userNameLabel = [[UILabel alloc] init];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.frame = CGRectMake(0+(i*107), 0 , 107, 37);
            userNameLabel.textColor = [UIColor whiteColor];
            userNameLabel.shadowColor = [UIColor grayColor];
            userNameLabel.shadowOffset = CGSizeMake(0, -1);
            userNameLabel.font = [UIFont boldSystemFontOfSize:14];
            userNameLabel.textAlignment = UITextAlignmentCenter;
            userNameLabel.text = [dic objectForKey:@"album_name"];
            [album_scrollView addSubview:userNameLabel];
            
            
            [album_scrollView setContentSize:CGSizeMake(214+(107*i),38)];
        }
    }
    [btn[0] addTarget:self action:@selector(album0_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[1] addTarget:self action:@selector(album1_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[2] addTarget:self action:@selector(album2_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[3] addTarget:self action:@selector(album3_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImage *order_0 = [UIImage imageNamed:@"order_0.png"];
    UIImage *order_1 = [UIImage imageNamed:@"order_1.png"];
    UIImage *order_2 = [UIImage imageNamed:@"order_2.png"];
    UIImage *order_3 = [UIImage imageNamed:@"order_3.png"];
    UIImage *order_4 = [UIImage imageNamed:@"order_4.png"];
    UIImage *order_5 = [UIImage imageNamed:@"order_5.png"];
    NSLog(@"%d",ID);
    switch (ID) {
        case 500:
            img2.image = order_0;
            break;
        case 100:
            img2.image = order_1;
            break;
        case 50:
            img2.image = order_2;
            break;
        case 10:
            img2.image = order_3;
            break;
        case 1:
            img2.image = order_4;
            break;
            
        default:
            img2.image = order_5;
            break;
    }
    
    
    
    [self nextdataloadFanpage];
    [self showMyPageList:0];
    
}

-(void)nextdataloadFanpage
{
    NSLog(@"@FanpageViewController=%d",fid);
    NSString *name=@"";
    int candy_cnt=0;
    int post_cnt=0;
    int title_cnt=0;
    int follower=0;
    int following=0;
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getUserInfo:fid];
    NSLog(@"1 %@",restmp);
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            name=[NSString stringWithFormat:@"%@(%d)",[dic objectForKey:@"name"],fid];//名前
            candy_cnt=[[dic objectForKey:@"candy_cnt"] integerValue];//キャンディ数
            post_cnt=[[dic objectForKey:@"post_cnt"] integerValue];//フォト数
            title_cnt=[[dic objectForKey:@"title_cnt"] integerValue];//バッジ数
            
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
            
            [ai changeImageStyle:[dic objectForKey:@"icon_path"] :60:60 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            CGRect rect = ai.frame;
            rect.size.height = 60;
            rect.size.width = 60;
            ai.frame = rect;
            ai.tag = i;
            //plz set Frame size this erea
            ai.frame = CGRectMake(0, 0, 60, 60);
            [icon_image addSubview:ai];
            [ai release];
        
        }
        //[scrollViewfanpage setContentSize:CGSizeMake(320,230 + (1*108))];
    }
    
    //ブロック判定
    restmp= [loadingapi isBlockUser:fid];
    NSDictionary *resDic = [restmp objectForKey:@"result"];
    if([[resDic objectForKey:@"blocked"]intValue] == 1)
    {
        NSLog(@"ISbloac %@",[resDic objectForKey:@"blocked"]);
        
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"エラー"
                             message:@"このページにはアクセスできません。"
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    
    restmp=[loadingapi getFollowingCount:fid];//フォロー件数
    //NSLog(@"3 %@",restmp);
    
    resDic = [restmp objectForKey:@"result"];
    following=[[resDic objectForKey:@"cnt"] integerValue];
    
    
    restmp=[loadingapi getFollowerCount:fid];//フォロワー件数
    //NSLog(@"4 %@",restmp);
    resDic = [restmp objectForKey:@"result"];
    follower=[[resDic objectForKey:@"cnt"] integerValue];
    
    //APIの呼び出し
    restmp=[loadingapi getDecorationList:fid];
    int badge_count =[[restmp objectForKey:@"result"] count];
    
    NSLog(@"name %@",name);
    NSLog(@"candy_cnt %d",candy_cnt);//キャンディ数
    NSLog(@"post_cnt %d",post_cnt);//フォト数
    NSLog(@"title_cnt %d",title_cnt);//バッジ数
    NSLog(@"following %d",following);
    NSLog(@"follower %d",follower);
    
    NSString* moji1;
    moji1 = [ NSString stringWithFormat : @"%d", candy_cnt];
    NSString* moji2;
    moji2 = [ NSString stringWithFormat : @"%d", post_cnt];
    NSString* moji3;
    moji3 = [ NSString stringWithFormat : @"%d", title_cnt];
    NSString* moji4;
    moji4 = [ NSString stringWithFormat : @"%d", following];
    NSString* moji5;
    moji5 = [ NSString stringWithFormat : @"%d", follower];
    NSString* moji6;
    moji6 = [ NSString stringWithFormat : @"%d", badge_count];
    
    lbl_name.text = name;
    lbl_candy_cnt.text =moji1;
    lbl_post_cnt.text =moji2;
    lbl_title_cnt.text=moji3;
    lbl_follower.text=moji4;
    lbl_following.text= moji5;
    lbl_badge_count.text = moji6;
    
    //f_name=name;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    
    lbl_add_reove_follow.text = @"フォローする";
    followType=0;
    
    restmp=[loadingapi getFollowingList:Uid];
    int cnt = [[restmp objectForKey:@"result"] count];
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        
        for (NSDictionary *dic in result) 
        {
            int follow_id=[[dic objectForKey:@"uid"] integerValue];
            if(fid==follow_id)
            {
                lbl_add_reove_follow.text = @"フォロー中";
                followType=1;
                i=cnt;
            }
        }
    }
}

//アルバム3まで対応、４移行は後日
-(IBAction) album0_btn_down:(id)sender
{
    [btn[0] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
    [btn[1] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[2] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[3] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    //[btn[4] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [self changeDataLoadMyPage:0];
}

-(IBAction) album1_btn_down:(id)sender
{
    [btn[0] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[1] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
    [btn[2] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[3] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    //[btn[4] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [self changeDataLoadMyPage:1];
}
-(IBAction) album2_btn_down:(id)sender
{
    [btn[0] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[1] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[2] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
    [btn[3] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    // [btn[4] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [self changeDataLoadMyPage:2];
}
-(IBAction) album3_btn_down:(id)sender
{
    [btn[0] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[1] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[2] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[3] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
    // [btn[4] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [self changeDataLoadMyPage:3];
}
-(IBAction) album4_btn_down:(id)sender
{
    [btn[0] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[1] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[2] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    [btn[3] setBackgroundImage:nonactive_tab_image forState:UIControlStateNormal];
    //[btn[4] setBackgroundImage:active_tab_image forState:UIControlStateNormal];
    [self changeDataLoadMyPage:4];
}
//・・・・・・・・・・・・・


-(void)changeDataLoadMyPage:(int)albumNum
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    if(albumNum==0)
    {
        [self showMyPageList:0];
    }
    
    int albumID=0;
    
    //アルバムリストを取得
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp =[loadingapi getAlbumList:fid];
    
    
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return;
    for (int i=0; i<cnt; i++)
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            if(albumNum==i)
            {
                albumID=[[dic objectForKey:@"album_id"] integerValue];
            }
            
            NSLog(@"album_name %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"album_name"]]);
            NSLog(@"post_image_id %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_image_id"]]);
            NSLog(@"image_id %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_id"]]);
            NSLog(@"real_path %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"real_path"]]);
        }
    }
    [self showMyPageList:albumID];
}



-(void)viewWillAppear:(BOOL)animated{
    
}

//フォローする
-(IBAction) saveFollow_btn_down:(id)sender;
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
    
    
    NSMutableString *bstr;
    if(followType==0)
    {
        alertType = cAlertType_C;
        bstr = [NSMutableString stringWithFormat:@"%@をフォローしますか？",lbl_name.text];
    }
    else
    {
        alertType = cAlertType_D;
        bstr = [NSMutableString stringWithFormat:@"%@さんのフォローを解除しますか？",lbl_name.text];
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"フォロー";
    alert.message = bstr;
    alert.tag=2;
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"キャンセル"];
    [alert show];
    [alert release];
}



-(void)showMyPageList:(int)albumID
{
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollViewfanpage addSubview:uv];
    
    SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
    
    NSLog(@"Fid =%d",fid);
    int offset=0;
    int limit=30;
    
    if(albumID==0)
    {
        //投稿一覧を表示する
        [searchViewCtrl getAlbumimageList:fid:offset:limit:0];
        
    }
    else
    {
        //受け取ったアルバムIDのリストを取得して表示
        [searchViewCtrl getAlbumimageList:fid:offset:limit:albumID];
    }
    
    
    [scrollViewfanpage addSubview:searchViewCtrl.view];    
}

-(IBAction) follow_btn_down:(id)sender{    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followlistViewController = [[FollowlistViewController alloc] 
                                 initWithNibName:@"FollowlistViewController" 
                                 bundle:nil];
    _followlistViewController.re_num = fid;
	[self.navigationController pushViewController:_followlistViewController 
										 animated:YES];
    
}

-(IBAction) follower_btn_down:(id)sender{   
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followerlistViewController = [[FollowerlistViewController alloc] 
                                   initWithNibName:@"FollowerlistViewController" 
                                   bundle:nil];
    
    _followerlistViewController.re_num = fid;
	[self.navigationController pushViewController:_followerlistViewController 
										 animated:YES];
    
}

-(IBAction) badge_btn_down:(id)sender{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _badgViewController = [[BadgViewController alloc] 
                           initWithNibName:@"BadgViewController" 
                           bundle:nil];
    _badgViewController.re_num = fid;
	[self.navigationController pushViewController:_badgViewController 
										 animated:YES];
    
}

-(IBAction) back_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:NO];
}


-(IBAction) block_btn_down:(id)sender
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
    //NSString *bstr = @"さんをブロックします。お互いのファンページや投稿写真へアクセスできなくなりますがよろしいですか？";
    
    NSMutableString *bstr = [NSMutableString stringWithFormat:@"%@さんをブロックします。お互いのファンページや投稿写真へアクセスできなくなりますがよろしいですか？",lbl_name.text];
    
    // 複数行で書くタイプ（複数ボタンタイプ）
    alertType = cAlertType_B;
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"";
    alert.message = bstr;
    alert.tag=2;
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"キャンセル"];
    [alert show];
    [alert release];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(alertView.tag != 2)
    {
        
        switch (buttonIndex) {
            case 0:
                //１番目のボタンが押されたときの処理を記述する
                break;
            case 1:
                //２番目のボタンが押されたときの処理を記述する
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                _secondViewController = [[SecondViewController alloc] 
                                         initWithNibName:@"SecondView" 
                                         bundle:nil];
                [self.navigationController pushViewController:_secondViewController 
                                                     animated:YES];
                break;
        }
        return;
    }
    
    NSMutableString *bstr;
    UIAlertView *alert;
    //NSDictionary *restmp;
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
	switch (alertType) 
    {
		case cAlertType_A:
            //アラートAを表示した後の処理
			break;
		case cAlertType_B:
            //アラートBを表示した後の処理
            switch (buttonIndex)
        {
            case 0:
                //１番目のボタンが押されたときの処理を記述する
                bstr =[NSMutableString stringWithFormat:@"%@さんをブロックしました。マイページのブロックリストから解除できます。",lbl_name.text];
                
                alert =[[UIAlertView alloc]
                        initWithTitle:@"ブロック"
                        message:bstr
                        delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
                NSLog(@"fid %d",fid);
                [loadingapi saveBlock:fid];
                
                //topへ戻る
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            case 1:
                //２番目のボタンが押されたときの処理を記述する
                break;
        }
			break;
            
            
		case cAlertType_C:
            if(buttonIndex==1) return;
            
            followType=1;
            alert =[[UIAlertView alloc]
                    initWithTitle:@""
                    message:@"フォローしました"
                    delegate:nil
                    cancelButtonTitle:nil
                    otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            [loadingapi saveFollow:fid];//フォロー処理
            
            lbl_add_reove_follow.text = @"フォロー中";
            //表示切り替え
            NSDictionary *restmp=[loadingapi getFollowerCount:fid];//フォロワー件数
            //NSLog(@"4 %@",restmp);
            NSDictionary *resDic = [restmp objectForKey:@"result"];
            lbl_following.text =[resDic objectForKey:@"cnt"];
            break;
		case cAlertType_D:
            if(buttonIndex==1) return;            
            
            followType=0;
            alert =[[UIAlertView alloc]
                    initWithTitle:@""
                    message:@"フォローを解除しました"
                    delegate:nil
                    cancelButtonTitle:nil
                    otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            [loadingapi deleteFollow:fid];//リムーブ処理
            
            lbl_add_reove_follow.text = @"フォローする";
            //表示切り替え
            NSDictionary *restmp2=[loadingapi getFollowerCount:fid];//フォロワー件数
            //NSLog(@"4 %@",restmp);
            NSDictionary *resDic2 = [restmp2 objectForKey:@"result"];
            lbl_following.text =[resDic2 objectForKey:@"cnt"];
            break;
		default:
			break;
	}
    
}


-(IBAction) left_btn_down:(id)sender
{
    ///スーパーハードコーディング！仕様変更時に必ず確認
    if(album_scrollView.frame.origin.x == 0){
        return;
    }
    float x = album_scrollView.frame.origin.x;
    x+=107;
    int sizex =album_scrollView.frame.size.width;
    album_scrollView.frame = CGRectMake(x, 163, sizex, 38);
    
}
-(IBAction) right_btn_down:(id)sender
{
    ///スーパーハードコーディング！仕様変更時に必ず確認
    if(album_scrollView.frame.origin.x == -107){
        return;
    }
    float x = album_scrollView.frame.origin.x;
    x-=107;
    int sizex =album_scrollView.frame.size.width;
    album_scrollView.frame = CGRectMake(x, 163, sizex, 38);
}
- (void)viewDidAppear:(BOOL)animated
{
}
@end
