//
//  MypageViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/12/01.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "MypageViewController.h"
#import "SearchViewCtrl.h"
#import "loadingAPI.h"
#import "FollowlistViewController.h"
#import "FollowerlistViewController.h"
#import "UIAsyncImageView.h"
#import "BadgViewController.h"

@implementation MypageViewController

-(IBAction) back_btn_down:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"FOLLOW_ID"]; 
    [defaults setInteger:0 forKey:@"FROM_ALBUM_FLAG"];
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getTitleList];
    NSLog(@"getTitleList%@",restmp);
    int ID=0;
    
    int cu_count = [[restmp objectForKey:@"result"] count];
    for (int i=0; i<cu_count; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            if(ID <[[dic objectForKey:@"rank"]intValue]){
                ID = [[dic objectForKey:@"rank"]intValue];
            }
        }
    }
    
    Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    NSDictionary *restmp2 = [loadingapi getAlbumList:Uid];
    NSLog(@"アルバム一覧 %@",restmp2);
    
    int cnt = [[restmp2 objectForKey:@"result"] count];
    
    active_tab_image = [UIImage imageNamed:@"fanpage_tab_1.png"];
    nonactive_tab_image = [UIImage imageNamed:@"fanpage_tab_0.png"];
    /*
     //アルバムスクロールの初期値を設定
     UIView *uv = [[UIView alloc] init];
     uv.frame = CGRectMake(0,0,1000, 38);
     uv.backgroundColor = [UIColor whiteColor];
     [album_scrollView addSubview:uv];
     
     float x = -107;//album_scrollView.frame.origin.x;
     NSLog(@"floatx %f",x);
     x+=107;
     int sizex =album_scrollView.frame.size.width;//534;//
     NSLog(@"intsizex %d",sizex);
     album_scrollView.frame = CGRectMake(x, 163, sizex, 38);
     
     
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
     
     NSLog(@"album %@", userNameLabel.text);
     [album_scrollView addSubview:userNameLabel];
     
     [album_scrollView setContentSize:CGSizeMake(107+107*i,38)];
     }
     }
     */
    
    
    UIImage *order_0 = [UIImage imageNamed:@"order_0.png"];
    UIImage *order_1 = [UIImage imageNamed:@"order_1.png"];
    UIImage *order_2 = [UIImage imageNamed:@"order_2.png"];
    UIImage *order_3 = [UIImage imageNamed:@"order_3.png"];
    UIImage *order_4 = [UIImage imageNamed:@"order_4.png"];
    UIImage *order_5 = [UIImage imageNamed:@"order_5.png"];
    NSLog(@"ID,%d",ID);
    switch (ID) {
        case 500:
            icon_image.image = order_0;
            break;
        case 100:
            icon_image.image = order_1;
            break;
        case 50:
            icon_image.image = order_2;
            break;
        case 10:
            icon_image.image = order_3;
            break;
        case 1:
            icon_image.image = order_4;
            break;       
        case 0:
            icon_image.image = order_5;
            break;
            
        default:
            icon_image.image = order_5;
            break;
    }
    // Do any additional setup after loading the view from its nib.
    [self nextdataloadMypage];
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


-(void)changeDataLoadMyPage:(int)albumNum
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    
    if(albumNum==0)
    {
        [self showMyPageList:0];
    }
    
    int albumID=0;
    
    //アルバムリストを取得
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp =[loadingapi getAlbumList:Uid];
    
    
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

-(void)nextdataloadMypage
{
    NSString *name=@"";
    int candy_cnt=0;
    int post_cnt=0;
    int title_cnt=0;
    int follower=0;
    int following=0;
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getUserInfo:Uid];
    
    NSLog(@"1 %@",restmp);
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            name=[NSString stringWithFormat:@"%@(%d)",[dic objectForKey:@"name"],Uid];//名前
            candy_cnt=[[dic objectForKey:@"candy_cnt"] integerValue];//キャンディ数
            post_cnt=[[dic objectForKey:@"post_cnt"] integerValue];//フォト数
            title_cnt=[[dic objectForKey:@"title_cnt"] integerValue];//バッジ数
            
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
            
            [ai changeImageStyle:[dic objectForKey:@"icon_path"] :60:60 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            NSLog(@"icon_path %@",[dic objectForKey:@"icon_path"]);
            ai.userInteractionEnabled=YES;
            
            
            CGRect rect = ai.frame;
            rect.size.height = 60;
            rect.size.width = 60;
            ai.frame = rect;
            ai.tag = i;
            //plz set Frame size this erea
            ai.frame = CGRectMake(0, 0, 60, 60);
            
            NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"icon_path"]];
            NSLog(@"uri = %@",uri);
            NSData *dt = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:uri]];
            UIImage *image = [[UIImage alloc] initWithData:dt];
            
            //ユーザーアイコン（ボタン）
            UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconButton setTitle:@"" forState:UIControlStateNormal];
            [iconButton setBackgroundImage:image forState:UIControlStateNormal];
            //[iconButton sizeToFit];
            iconButton.frame = CGRectMake(4, 51, 60, 60);//画像サイズがいかなる場合でも77×77にする
            iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            iconButton.tag = [[dic objectForKey:@"uid"] integerValue];
            [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:iconButton];
            
            [ai release];
            
            
        }
    }
    
    
    Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    NSDictionary *restmp2 = [loadingapi getAlbumList:Uid];
    NSLog(@"アルバム一覧 %@",restmp2);
    
    int cnt = [[restmp2 objectForKey:@"result"] count];
    
    active_tab_image = [UIImage imageNamed:@"fanpage_tab_1.png"];
    nonactive_tab_image = [UIImage imageNamed:@"fanpage_tab_0.png"];
    
    
    
    float x = -107;//album_scrollView.frame.origin.x;
    
    //アルバムスクロールの初期値を設定
    //backwidth=107*(cnt-1);
    backuv = [[UIView alloc] init];
    backuv.frame = CGRectMake(0,0,1200, 38);
    backuv.backgroundColor = [UIColor whiteColor];
    [album_scrollView addSubview:backuv];
    
    NSLog(@"floatx %f",x);
    x+=107;
    int sizex =album_scrollView.frame.size.width;//534;//
    NSLog(@"intsizex %d",sizex);
    album_scrollView.frame = CGRectMake(x, 163,320, 38);
    
    
    
    
    
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
            [backuv addSubview:btn[i]];
            
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
            [backuv addSubview:userNameLabel];
            
            [album_scrollView setContentSize:CGSizeMake(214+(107*i),38)];
        }
    }
    [btn[0] addTarget:self action:@selector(album0_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[1] addTarget:self action:@selector(album1_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[2] addTarget:self action:@selector(album2_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    [btn[3] addTarget:self action:@selector(album3_btn_down:) forControlEvents:UIControlEventTouchUpInside];
    restmp=[loadingapi getFollowingCount:Uid];//フォロー件数
    //NSLog(@"3 %@",restmp);
    
    NSDictionary *resDic = [restmp objectForKey:@"result"];
    following=[[resDic objectForKey:@"cnt"] integerValue];
    
    restmp=[loadingapi getFollowerCount:Uid];//フォロワー件数
    
    //NSLog(@"4 %@",restmp);
    resDic = [restmp objectForKey:@"result"];
    follower=[[resDic objectForKey:@"cnt"] integerValue];
    
    //APIの呼び出し
    restmp=[loadingapi getDecorationList:Uid];
    int badge_count =[[restmp objectForKey:@"result"] count];
    
    
    /*  for (int i=0; i<1; i++) 
     {
     NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
     for (NSDictionary *dic in result) 
     {
     follower=[[dic objectForKey:@"cnt"] integerValue];
     }
     }
     */
    
    /*
     restmp=[loadingapi getDecorationList:Uid];//バッジ一覧を取得
     NSLog(@"2 %@",restmp);
     for (int i=0; i<1; i++) 
     {
     NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
     for (NSDictionary *dic in result) 
     {
     candy_cnt=[[dic objectForKey:@"result"] integerValue];//バッジ数
     NSLog(@"bajji_cnt %d",bajji_cnt);
     }
     }*/
    
    
    
    
    
    NSLog(@"name %@",name);
    NSLog(@"candy_cnt %d",candy_cnt);//キャンディ数
    NSLog(@"post_cnt %d",post_cnt);//フォト数
    NSLog(@"title_cnt %d",title_cnt);//バッジ数
    NSLog(@"following %d",following);
    NSLog(@"follower %d",follower);
    NSLog(@"badge_count %d",badge_count);
    
    
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
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    
    userNameLabel.text = @"9";
    
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.frame = CGRectMake(90, 87, 200, 20);
    userNameLabel.textColor =[UIColor colorWithRed:0.800 green:0.400 blue:0.400 alpha:1.0];
    userNameLabel.font = [UIFont boldSystemFontOfSize:14];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:userNameLabel];
    
    [self showMyPageList:0];
    //とりあえずトップビューのリストを表示する
    
}

-(void)showMyPageList:(int)albumID
{
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollViewmypage addSubview:uv];
    
    SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
    
    int offset=0;
    int limit=30;
    if(albumID==0)
    {        
        [searchViewCtrl getAlbumimageList:Uid:offset:limit:0];
    }
    else
    {
        //受け取ったアルバムIDのリストを取得して表示
        [searchViewCtrl getAlbumimageList:Uid:offset:limit:albumID];
    }
    
    
    [scrollViewmypage addSubview:searchViewCtrl.view];  
    
    //[searchViewCtrl.thumbnailView setContentSize:CGSizeMake(320,)];
    
}

-(IBAction) follow_btn_down:(id)sender{    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followlistViewController = [[FollowlistViewController alloc] 
                                 initWithNibName:@"FollowlistViewController" 
                                 bundle:nil];
    _followlistViewController.re_num = Uid;
	[self.navigationController pushViewController:_followlistViewController 
										 animated:YES];
    
}
-(IBAction) follower_btn_down:(id)sender{   
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _followerlistViewController = [[FollowerlistViewController alloc] 
                                   initWithNibName:@"FollowerlistViewController" 
                                   bundle:nil];
    
    _followerlistViewController.re_num = Uid;
	[self.navigationController pushViewController:_followerlistViewController 
										 animated:YES];
    
}

-(IBAction) badge_btn_down:(id)sender{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _badgViewController = [[BadgViewController alloc] 
                           initWithNibName:@"BadgViewController" 
                           bundle:nil];
    _badgViewController.re_num = Uid;
	[self.navigationController pushViewController:_badgViewController 
										 animated:YES];
    
}


//左右ボタン
-(IBAction) left_btn_down:(id)sender
{
    NSLog(@"left ");
    album_scrollView.contentOffset=CGPointMake(0, 0);
}
-(IBAction) right_btn_down:(id)sender
{
    NSLog(@"right ");   
    album_scrollView.contentOffset=CGPointMake(107+107, 0);
}

- (void) modalButtonDidPush {
    NSLog(@"long press");
}




@end
