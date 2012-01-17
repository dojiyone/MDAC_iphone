//
//  RankingViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//
#include <QuartzCore/CALayer.h>
#import "RankingViewController.h"
#import "SearchViewCtrl.h"
#import "loadingAPI.h"

#import "UIAsyncImageView.h"

const CGFloat kScrollObjHeight2	= 100.0;
const CGFloat kScrollObjWidth2	= 100.0;
//const NSUInteger kNumImages2	= 10;


@implementation RankingViewController
//@synthesize loadflag;
@synthesize _nav2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"FROM_ALBUM_FLAG"];
    //NSLog(@"load %@",loadflag);
    // if([loadflag isEqualToString:@"l"]) return;
    
    [self layoutScrollImages2:MainScrollView];
    
    [MainScrollView setContentSize:CGSizeMake(320,2041)];
    
    //詳細はどこをを経由したか？YES
    //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
    /* int pass_ranking = 1;
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
     NSLog(@"%d",pass_ranking);
     
     */
    [self badge_num];
    [MainScrollView release];
    
    [self RankinglayoutScroll];    
}


-(void)viewWillAppear:(BOOL)animated{
    //if([loadflag isEqualToString:@"l"]) return;
    //loadflag=@"l";
    //[self netAccessStart];
}


//ロード完了読み込み
- (void)viewDidAppear:(BOOL)animated
{
    //if([loadflag isEqualToString:@"l"]) return;
    //loadflag=@"l";
    //[self RankinglayoutScroll];    
    //[self netAccessEnd];
}


//スクロールビュー生成
- (void)RankinglayoutScroll
{
    
    NSLog(@"scroll");
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    NSDictionary *restmp;
    //ロード改善実験失敗
    //if(restmp !=nil)return;
    restmp = [loadingapi getPublicTagList];
    
    NSLog(@"%@",[restmp objectForKey:@"result"]);
    //タグ用配列定義
    int tagNum=8;
    nowTagNum=tagNum;
    //まず６つの公式タグを取得
    int i=0;
    for (i=0; i<tagNum-2; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            //各tagキーの文字列を取り出し配列に入れる
            tagString[i] = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]];
            
            if([tagString[i] isEqualToString:@"かわいい"])
                tagStringSub[i] = [tagString[i] stringByAppendingString:@"／Cutie"];
            else if([tagString[i] isEqualToString:@"ブサカワ"])
                tagStringSub[i] = [tagString[i] stringByAppendingString:@"／Ugly cute"];
            else if([tagString[i] isEqualToString:@"もふもふ"])
                tagStringSub[i] = [tagString[i] stringByAppendingString:@"／Softly"];
            else if([tagString[i] isEqualToString:@"おもしろ"])
                tagStringSub[i] = [tagString[i] stringByAppendingString:@"／Funny"];
            else    tagStringSub[i]=tagString[i];
            
            NSLog(@"tagString %@", tagString[i]);
            
        }
    }
    
    //のこり２のタグを取得
    //最大登録件数
    NSDictionary *restmp2=[loadingapi getTagCloud];
    
    //タグクラウド上位２つを取得
    for (i=0; i<2; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp2 objectForKey:@"result"] objectAtIndex:i];
        NSLog(@"resCloud %@",result);
        for (NSDictionary *dic in result) 
        {
            //各tagキーの文字列を取り出し配列に入れる
            tagString[i+6] = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]];
            NSLog(@"tagString2 %@", tagString[i+6]);
        }
    }
    
    more1_label.text = tagStringSub[0];
    more2_label.text = tagStringSub[1];
    more3_label.text = tagStringSub[2];
    more4_label.text = tagStringSub[3];
    more5_label.text = tagStringSub[4];
    more6_label.text = tagStringSub[5];
    more7_label.text = tagString[6];
    more8_label.text = tagString[7];
    
    
    //スクロールビューの生成
    [self loadNewScrollView];
}

-(void)loadNextScrollView
{
    nowTagNum--;
    if(nowTagNum<=0)return;
    [self loadNewScrollView];
}

-(void)loadNewScrollView
{
    
    UIScrollView *nowScrollView;
    
    //カウンターごとにスクロールビューポインタを渡す
    int tagNum=0;
    if(nowTagNum==8)     {   nowScrollView=scrollView1;}
    else if(nowTagNum==7){   nowScrollView=scrollView2; tagNum=1;}
    else if(nowTagNum==6){   nowScrollView=scrollView3; tagNum=2;}
    else if(nowTagNum==5){   nowScrollView=scrollView4; tagNum=3;}
    else if(nowTagNum==4){   nowScrollView=scrollView5; tagNum=4;}
    else if(nowTagNum==3){   nowScrollView=scrollView6; tagNum=5;}
    else if(nowTagNum==2){   nowScrollView=scrollView7; tagNum=6;}
    else                 {   nowScrollView=scrollView8; tagNum=7;}
    
    NSDictionary *restmp;
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    restmp=[loadingapi getTagLists:tagString[tagNum]:0:10];
    [loadingapi release];
    
    int imgWidth=100;
    int cnt = [[restmp objectForKey:@"result"] count];
    NSLog(@"cnt %d",cnt);
    
    
    
    [nowScrollView setBackgroundColor:[UIColor whiteColor]];
    [nowScrollView setCanCancelContentTouches:NO];
    nowScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    nowScrollView.clipsToBounds = NO;
    nowScrollView.scrollEnabled = YES;
    nowScrollView.pagingEnabled = NO;
    nowScrollView.bounces = NO;
    
    if(cnt<10 && reloadFlag==1) return;
    for (int i=0; i<cnt; i++)
    {
        
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        NSLog(@"res %@",result);
        for (NSDictionary *dic in result) 
        {
            NSLog(@"ai");
            //非同期画像読み込み
            UIAsyncImageView *ai =[[UIAsyncImageView alloc] init];
            
            int imageID=[[dic objectForKey:@"post_image_id"] integerValue];
            //ai.accessibilityLabel=[NSString stringWithFormat:@"%d",imageID];
            ai.tag=imageID;
            
            [ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            //タップジェスチャー
            UITapGestureRecognizer *tap;
            tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
            [ai addGestureRecognizer:tap];
            
            CGRect rect = ai.frame;
            rect.size.height = kScrollObjHeight2;
            rect.size.width = kScrollObjWidth2;
            ai.frame = rect;
            //ai.tag = i;
            ai.frame = CGRectMake(3, 4, 100, 100);
            [nowScrollView addSubview:ai];
            
            //横スパン106
            //縦スパン108
            //新着ランキングラベル 左上始点
            UILabel *pictRankLabel01 = [[UILabel alloc] init];
            pictRankLabel01.backgroundColor = [UIColor colorWithRed:1.0 green:0.647 blue:0.7 alpha:1.0];
            pictRankLabel01.frame = CGRectMake(3+(i*107), 88, 16, 16);
            pictRankLabel01.textColor = [UIColor whiteColor];
            pictRankLabel01.font = [UIFont boldSystemFontOfSize:12];
            pictRankLabel01.textAlignment = UITextAlignmentCenter;
            pictRankLabel01.text = [NSString stringWithFormat:@"%d",i+1];
            switch (nowTagNum) 
            {
                case 0:
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:1.0 green:0.647 blue:0.7 alpha:1.0];
                    break;
                case 1:            
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.847 green:0.824 blue:0.137 alpha:1.0];
                    break;
                case 2:            
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.553 green:0.831 blue:0.471 alpha:1.0];
                    break;
                case 3:            
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.478 green:0.686 blue:0.925 alpha:1.0];
                    break;
                case 4:            
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:1.0 green:0.647 blue:0.7 alpha:1.0];                    break;
                case 5:          
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.847 green:0.824 blue:0.137 alpha:1.0];                      break;
                case 6:            
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.553 green:0.831 blue:0.471 alpha:1.0];
                    break;
                case 7:            
                    
                    pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.478 green:0.686 blue:0.925 alpha:1.0];
                    break;
                    
                default:
                    break;
            }
            [nowScrollView setContentSize:CGSizeMake(cnt*107 , [nowScrollView bounds].size.height)];
            [nowScrollView addSubview:pictRankLabel01];
            
            [ai release];
        }
    }
    
    //NSLog(@"nowsxr %d",nowScrollView.retainCount);
    
    [self layoutScrollImages2:nowScrollView];
    //NSLog(@"end");
}


- (void)layoutScrollImages2:(UIScrollView *)nowScrollView
{
    
    UIImageView *view = nil;
    NSArray *subviews = [nowScrollView subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;//-107-107;//107
    
    
    int i=0;
    for (view in subviews)
    {
        
        //UIImageViewかどうか
        if ([view isKindOfClass:[UIAsyncImageView class]]) 
            //           ||[view isKindOfClass:[UIImageView class]])//&& view.tag > 0)
        {
            
            CGRect frame = view.frame;
            frame.origin = CGPointMake(curXLoc+3, 4);
            view.frame = frame;
            
            curXLoc += 107;
            //[view release];
        }
    }
    
    // set the content size so it can be scrollable
    //[nowScrollView release];
    
    [self loadNextScrollView];
}


//リロードボタン
-(IBAction) reload_btn_down:(id)sender
{
    /*  [MainScrollView release];
     [nowScrollView release];
     [scrollView1 release];
     [scrollView2 release];
     [scrollView3 release];
     [scrollView4 release];
     [scrollView5 release];
     [scrollView6 release];
     [scrollView7 release];
     [scrollView8 release];*/
    reloadFlag=1;
    // nowTagNum=8;
    // [self layoutScrollImages2:MainScrollView:100];
    //[MainScrollView setContentSize:CGSizeMake(320,2041)];
    //[MainScrollView release];
    
    [self RankinglayoutScroll];    
}


//タップされた画像のIDを元に詳細ページへジャンプ
-(void)buttonTouched:(id)sender
{
    UIAsyncImageView *ai = [(UIAsyncImageView *)sender view];   
    //NSLog(@"buttonTouched %@",ai.accessibilityLabel); 
    
    
    
    NSString *idString=[NSString stringWithFormat:@"%d",ai.tag];
    NSDictionary *dic= [NSDictionary dictionaryWithObject:idString forKey:@"imageID"];
    
    // 通知を作成する
    NSNotification *n = [NSNotification notificationWithName:@"Tuchi" object:self userInfo:dic];
    
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

-(IBAction) more0_btn_down:(id)sender{
    
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    
    tag_value = more1_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    _tagpageViewController.nowTagNum = 0;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more1_label.text;
    
    
    
    
}
-(IBAction) more1_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more2_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    _tagpageViewController.nowTagNum = 3;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more2_label.text;
}
-(IBAction) more2_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more3_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    
    _tagpageViewController.nowTagNum = 2;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more3_label.text;
    
}
-(IBAction) more3_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more4_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    
    _tagpageViewController.nowTagNum = 1;
    _tagpageViewController.title_lbl.text = more4_label.text;
    
}
-(IBAction) more4_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more5_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    
    _tagpageViewController.nowTagNum = 0;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more5_label.text;
    
}
-(IBAction) more5_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more6_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    
    _tagpageViewController.nowTagNum = 3;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more6_label.text;
    
}
-(IBAction) more6_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more7_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    
    _tagpageViewController.nowTagNum = 2;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more7_label.text;
    
}
-(IBAction) more7_btn_down:(id)sender{
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    tag_value = more8_label.text;
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
    
    _tagpageViewController.nowTagNum = 1;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = more8_label.text;
    
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
            
            
            [self RankinglayoutScroll];  
            break;
        case 1:upCategory=@"1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            
            
            [self RankinglayoutScroll];  
            break;  
        case 2 :upCategory=@"0%2c1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            
            
            [self RankinglayoutScroll];  
            break;   
        case 3:
        default:  upCategory=category; 
            break;    
    }
    
    
    _rankingViewController = [[RankingViewController alloc] 
                              initWithNibName:@"RankingViewController" 
                              bundle:nil];
    //[self.view addSubview:_rankingViewController.view];
    [self.navigationController pushViewController:_rankingViewController
										 animated:NO];
}



@end
