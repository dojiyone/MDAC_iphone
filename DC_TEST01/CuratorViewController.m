//
//  CuratorViewController.m
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "CuratorViewController.h"
#import "dataButton.h"

@implementation CuratorViewController
//@synthesize re_value;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    fid=[[defaults stringForKey:@"FOLLOW_ID"] intValue];
    NSLog(@"fid %d",fid);
    
    if(fid==0)  fid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    // fid=1;//test
    
    
    [scrollView setContentSize:CGSizeMake(320,1486)];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getFanTitleList:fid];
    NSLog(@"deco %@",restmp);
    
    int i=0;
    int imgWidth=100;
    int imageMargin=40;
    int sideCount=3;
    int basex=2;
    int basey=4;
    
    int cnt = [[restmp objectForKey:@"result"] count];
    for (i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            NSString* date = [NSString stringWithFormat:@"%@",[dic objectForKey:@"get_date"]];
            //NSString *get_date = [date substringToIndex:10];
            
            NSString *usrName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];//名前
            
            //通常サイズはimage_urlを取る
            NSString *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_url"]];
            NSString *imageURLmini=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_url_small"]];//ミニアイコン画像
            
            
            NSString *decoName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title_name"]];//称号名
            int decoID=[[dic objectForKey:@"title_id"] integerValue];//称号ID
            int rank=[[dic objectForKey:@"rank"] integerValue];//ランク
            
            
            //ユーザーアイコン（ボタン）
            UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconButton setTitle:@"" forState:UIControlStateNormal];
            
            
            
            NSURL *url= [NSURL URLWithString: imageURL];
            NSData *data = [NSData dataWithContentsOfURL: url];
            UIImage *image = [UIImage imageWithData: data];
            
            
            
            // UIButtonを追加
            dataButton *button = [[dataButton alloc] initWithTitle:@"" data:date];
            
            button.frame = CGRectMake(basex, basey, imgWidth, imgWidth);
            [button setBackgroundImage:[UIImage imageWithData: data] forState:UIControlStateNormal];
            button.tag=decoID;
            [button addTarget:self action:@selector(ShowActivity:) forControlEvents:UIControlEventTouchUpInside];
            
            
            button.data2 = decoName;//title
            button.data3 = usrName;//message
            button.data4 = imageURL;//url
            button.dataint = rank;
            
            
            
            [scrollView addSubview:button];
            
            
            //ユーザー名
            UILabel *uLabel = [[UILabel alloc] init];
            uLabel.backgroundColor = [UIColor clearColor];
            [uLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel setNumberOfLines:0];
            
            uLabel.frame = CGRectMake(basex+5, basey + 100, 95, 50);
            uLabel.textColor = [UIColor grayColor];
            uLabel.font = [UIFont boldSystemFontOfSize:12];
            uLabel.textAlignment = UITextAlignmentLeft;
            uLabel.text = decoName;
            [scrollView addSubview:uLabel];
            
            basex = 2+((i+1)%sideCount *imgWidth)+((i+1)%sideCount+10);
            basey = 4+((i+1)/sideCount *imgWidth)+((i+1)/sideCount *imageMargin);  
            
        }
    }
    //super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}



-(void)modalButtonDidPush:(UIButton *)sender
{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated
{
}




-(void)buttonTouched:(UIButton*)button
{
    NSLog(@"decobutton %d",button.tag);
    /*
     _detalisViewController = [[DetalisViewController alloc]initWithNibName:@"DetalisViewController" bundle:nil];
     [self.navigationController pushViewController:_detalisViewController animated:YES];
     */
}

- (void)ShowActivity:(dataButton *)sender;
{
    
    NSString *date = [sender.data substringToIndex:10];
    
    /*
     キュレーター称号を入手！
     キュレーター称号が「ブロンズ」にランクアップ！
     キュレーター称号が「シルバー」にランクアップ！
     キュレーター称号が「ゴールド」にランクアップ！
     キュレーター称号が「プラチナ」にランクアップ！
     ○○○○についてイイネ！をもらいました。
     ○○○○バッジを入手！
     ○○○○さんからフォローされました。
     ○○○○について□□□□さんからコメントをもらいました。
     おめでとうございます！／あなたもキュレーターの仲間入り！さらに上位ランクのキュレーターを目指そう！
     おめでとうございます！／キュレーター称号が「ブロンズ」にランクアップ！
     おめでとうございます！／キュレーター称号が「シルバー」にランクアップ！
     おめでとうございます！／キュレーター称号が「ゴールド」にランクアップ！
     おめでとうございます！／キュレーター称号「プラチナ」にランクアップ！遂にキュレーター殿堂入りです！
     */
    
    
    
    NSString *actTitle=sender.data2;//sender.accessibilityLanguage;
    NSString *actMsg;//=sender.data3;
    NSString *imageURL=sender.data4;
    NSLog(@"%d",sender.dataint);
    NSURL *url= [NSURL URLWithString: imageURL];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    int cu_rank =sender.dataint;
    //メッセージの分岐
    switch (cu_rank) {
        case 1:
            actMsg =@"おめでとうございます！／あなたもキュレーターの仲間入り！さらに上位ランクのキュレーターを目指そう！";
            break;
        case 10:
            actMsg =@"おめでとうございます！／キュレーター称号が「ブロンズ」にランクアップ！";
            break;
        case 50:
            actMsg =@"おめでとうございます！／キュレーター称号が「シルバー」にランクアップ！";
            break;        
        case 100:
            actMsg =@"おめでとうございます！／キュレーター称号が「ゴールド」にランクアップ！";
            break;
        case 500:
            actMsg =@"おめでとうございます！／キュレーター称号「プラチナ」にランクアップ！遂にキュレーター殿堂入りです！";
            break;
        default:
            actMsg =@"";
            break;
    }
    
    //半透明の黒背景背景
    curView = [[UIView alloc] initWithFrame:[[self view] bounds]];
    [curView setBackgroundColor:[UIColor blackColor]];
    [curView setAlpha:0.5];
    [[self view] addSubview:curView];
    
    //スクロールビューを定義
    curSv = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 60, 240, 340)];
    curSv.backgroundColor = [UIColor whiteColor];
    curSv.layer.masksToBounds = YES;  
    curSv.layer.cornerRadius = 10; 
    [curSv setAlpha:0.0];
    
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
    [curSv setAlpha:1.0];
    // アニメーション開始
    [UIView commitAnimations];	
    
    
    //画像を追加
    iv = [[UIImageView alloc] initWithImage:image];
    iv.center = CGPointMake(120, 110);
    
    curSv.contentSize = iv.bounds.size;
    
    
    //ユーザー名
    UILabel *uLabel = [[UILabel alloc] init];
    uLabel.backgroundColor = [UIColor clearColor];
    [uLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
    [uLabel setNumberOfLines:0];
    
    uLabel.frame = CGRectMake(20, 240 , 200, 70);
    //uLabel.textColor = [UIColor Color];
    uLabel.font = [UIFont boldSystemFontOfSize:14];
    uLabel.textAlignment = UITextAlignmentLeft;
    uLabel.text = actMsg;
    
    UILabel *uLabel2 = [[UILabel alloc] init];
    uLabel2.backgroundColor = [UIColor clearColor];
    [uLabel2 setLineBreakMode:UILineBreakModeWordWrap];//改行モード
    [uLabel2 setNumberOfLines:0];
    
    uLabel2.frame = CGRectMake(20, 190 , 200, 70);
    //uLabel.textColor = [UIColor Color];
    uLabel2.font = [UIFont boldSystemFontOfSize:17];
    uLabel2.textAlignment = UITextAlignmentLeft;
    uLabel2.text = actTitle;
    
    UILabel *uLabel3 = [[UILabel alloc] init];
    uLabel3.backgroundColor = [UIColor clearColor];
    [uLabel3 setLineBreakMode:UILineBreakModeWordWrap];//改行モード
    [uLabel3 setNumberOfLines:0];
    
    uLabel3.frame = CGRectMake(20, 285 , 200, 70);
    //uLabel.textColor = [UIColor Color];
    uLabel3.font = [UIFont boldSystemFontOfSize:14];
    uLabel3.textAlignment = UITextAlignmentLeft;
    uLabel3.text = date;
    
    [curSv addSubview:uLabel];
    [curSv addSubview:uLabel2];
    [curSv addSubview:uLabel3];
    
    //スクロールを描画
    [self.view addSubview:curSv];
    //描画
    [curSv addSubview:iv];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.hidden =NO;
    btn.tag=0;
    btn.frame = CGRectMake(0, 0, 240, 280);
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal]; 
    [btn addTarget:self action:@selector(hoge2:)forControlEvents:UIControlEventTouchDown];
    
    [curSv addSubview:btn];
    
}

-(void)hoge2:(UIButton*)button
{
    button.hidden =YES;
    [curView removeFromSuperview];
    [curSv removeFromSuperview];
}
@end