//
//  DetailsCommentsViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "DetailsShareViewConroller.h"
#import "DetailsViewController.h"
#import "DetailsDataViewController.h"
#import "DetailsCommentsViewController.h"
#import "MypageViewController.h"
#import "FanpageViewController.h"
#import "loadingAPI.h"

@implementation DetailsCommentsViewController

@synthesize re_value;
@synthesize image_id;
@synthesize nabi;

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


-(IBAction) back_btn_down:(id)sender;
{
    int pass_ranking;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    pass_ranking = [[defaults stringForKey:@"PASS_RANKING"] intValue];
    NSLog(@"deteails back%d",pass_ranking);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if(pass_ranking==-1)//強制的にTOPへ戻る
    {
        pass_ranking=0;
        [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    NSLog(@"navigation %@",self.navigationController.viewControllers);
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{ NSLog(@"@%@",image_id);
    
    [self getComment];
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

- (void)getComment{
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    long num = [image_id intValue];
    NSDictionary *restmp=[loadingapi getComment:num:0 :3];
    NSLog(@"aaa %@",restmp);
    int tagNum = [[restmp objectForKey:@"result"] count];
    int i=0;
    
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    
    int margin = 27;//配置時の高さマージン
    int prePos=0;
    int strGyou=1;
    for (i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            NSString *Conmment =[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
            NSString *Name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];            
            NSString *Date =[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_date"]];
            int uid =[[dic objectForKey:@"uid"]integerValue];
            // 背景
            
            strGyou = [self strLength:Conmment : 0]/17;
            //if(strGyou<=2) strGyou=3;
            //else if(strGyou%2==0) 
            strGyou +=1;//奇数を維持
            
            NSLog(@"str %d",strGyou);
            int nowPos=strGyou*margin;
            /* 
             UIImage *image = [UIImage imageNamed:@"comment_bg.png"];
             UIImageView *iv = [[UIImageView alloc] initWithImage:image];
             iv.frame = CGRectMake(0, 15 + (preGyou*margin)*i, 320, 69);
             [scrollView addSubview:iv];
             */ 
            //コメント表示
            UITextView *ComentText = [[UITextView alloc]init];
            ComentText.frame = CGRectMake(9, prePos, 294,nowPos);
            ComentText.backgroundColor = [UIColor clearColor];
            ComentText.font = [UIFont boldSystemFontOfSize:15];
            ComentText.textAlignment = UITextAlignmentLeft;
            ComentText.text = Conmment;
            ComentText.editable =NO;
            [scrollView addSubview:ComentText];
            
            /*
             //osirase（固定文言）
             UILabel *deletaLabel = [[UILabel alloc] init];
             deletaLabel.frame = CGRectMake(9, 0 + textmargin * i, 294, 66);
             deletaLabel.numberOfLines = 3;//最大３行に指定
             deletaLabel.backgroundColor = [UIColor clearColor];
             //deletaLabel.font = [UIFont boldSystemFontOfSize:15];
             deletaLabel.textAlignment = UITextAlignmentLeft;
             deletaLabel.text = Conmment;
             [scrollView addSubview:deletaLabel];
             */
            
            //投稿者
            UILabel *deletaLabel2 = [[UILabel alloc] init];
            deletaLabel2.frame = CGRectMake(14,10+prePos+nowPos-margin+10, 294, 46);
            deletaLabel2.numberOfLines = 3;//最大３行に指定
            deletaLabel2.backgroundColor = [UIColor clearColor];
            deletaLabel2.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            deletaLabel2.textAlignment = UITextAlignmentLeft;
            deletaLabel2.text = Name;
            [scrollView addSubview:deletaLabel2];
            
            //日時
            UILabel *deletaLabel3 = [[UILabel alloc] init];
            deletaLabel3.frame = CGRectMake(244, 10+prePos+nowPos-margin+10, 294, 46);
            deletaLabel3.numberOfLines = 3;//最大３行に指定
            deletaLabel3.backgroundColor = [UIColor clearColor];
            deletaLabel3.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            deletaLabel3.textAlignment = UITextAlignmentLeft;
            deletaLabel3.text = Date;
            [scrollView addSubview:deletaLabel3];
            
            //投稿者の名前をクリックするとFanpageへと移動
            UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deletaButton setTitle:@"" forState:UIControlStateNormal];
            [deletaButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            deletaButton.frame = CGRectMake(12,10+prePos+nowPos-margin+10, 194, 46);
            deletaButton.tag = uid;
            //位置調整など
            [deletaButton addTarget:self action:@selector(fanpage_btn_down:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:deletaButton];
            /*
            //コメントをクリックすると投稿者のFanpageへと移動
            UIButton *deletaButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
            [deletaButton4 setTitle:@"" forState:UIControlStateNormal];
            [deletaButton4 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            deletaButton4.frame = CGRectMake(9, prePos, 294,nowPos);
            deletaButton4.tag = uid;
            //位置調整など
            [deletaButton4 addTarget:self action:@selector(fanpage_btn_down:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:deletaButton4];
            */
            
            //前の位置を保持
            prePos +=(nowPos+42);
        }
        scrollView.contentSize = CGSizeMake(320,prePos);
        
        
    }
}


// 文字の数を戻す（半角は１，全角は２としてカウント）
- (int) strLength :(NSString *) aValue :(int)strlen
{
    int nowCount=[aValue length];
    
    int truthCount=0;
    int truthCenterPx=0;
    for(int i=0;i<nowCount;i++)
    {
        
        NSString *oneStr = [aValue substringWithRange:NSMakeRange(i,1)];
        // 文字は存在しているので１をカウント
        truthCount++;
        // 全角だった場合はもう一つカウント
        
        NSRange match = [oneStr rangeOfString:@"[\x20-\x7E\xA1-\xDF\｡-ﾟ]" options:NSRegularExpressionSearch];
        if (match.location == NSNotFound) {}
        else        truthCount++;
        
        
    }
    
    //実態が小さい場合の微調整
    //truthCount-=1;
    
    truthCount=truthCount/2;
    return truthCount;
    
}


-(IBAction) detailsData_btn_down:(id)sender;
{
    NSLog(@"@%@",re_value);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsDataViewController = [[DetailsDataViewController alloc] 
                                  initWithNibName:@"DetailsDataViewController" 
                                  bundle:nil];
    _detailsDataViewController.image_id = image_id;
	[self.navigationController pushViewController:_detailsDataViewController 
										 animated:NO];
    
    
}

-(void)fanpage_btn_down:(UIButton *)sender{
    
    NSLog(@"@%d",sender.tag);
    //ログインID＝fanpageIDならmypageへ移動
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    [defaults setInteger:sender.tag forKey:@"FOLLOW_ID"];
    
    int Fid=sender.tag;
    if(Uid == Fid){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _mypageViewController = [[MypageViewController alloc] 
                                 initWithNibName:@"MypageViewController" 
                                 bundle:nil];
        
        [nabi pushViewController:_mypageViewController
                                             animated:YES];
        
    }
    else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _fanpageViewController = [[FanpageViewController alloc]
                                  initWithNibName:@"FanpageViewController" 
                                  bundle:nil];
        [nabi pushViewController:_fanpageViewController 
                                             animated:YES];
    }
    
}

-(IBAction) detailsComments_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsCommentsViewController = [[DetailsCommentsViewController alloc] 
                                      initWithNibName:@"DetailsCommentsViewController" 
                                      bundle:nil];
    _detailsCommentsViewController.image_id = image_id;
	[self.navigationController pushViewController:_detailsCommentsViewController 
										 animated:NO];
}

-(IBAction) detailsShare_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsShareViewConroller = [[DetailsShareViewConroller alloc] 
                                  initWithNibName:@"DetailsShareViewConroller" 
                                  bundle:nil];
    _detailsShareViewConroller.image_id = image_id;
    [self.navigationController pushViewController:_detailsShareViewConroller 
                                         animated:NO];
}
-(IBAction) details_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
    _detailsViewController.re_value = image_id;
    [self.navigationController pushViewController:_detailsViewController 
                                         animated:NO];
}
-(IBAction) postComment_btn_down:(id)sender
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
    
    
    NSArray *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor = [[aOsVersions objectAtIndex:0] intValue];
    NSLog(@"major %d minot",iOsVersionMajor);
    
    if(iOsVersionMajor<5)
    {
        post_textView.frame = CGRectMake(11, 20, 298, 56);
        
    }
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    //公式タグ一覧のデータを受信
    int num = [image_id intValue];
    NSLog(@"%@",post_textView.text);
    
    //コメント未入力はエラー
    if([post_textView.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"コメントが未入力です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    [loadingapi saveComment:num :post_textView.text];
    [post_textView resignFirstResponder];
    post_textView.text = @"";
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    [self getComment];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:@"コメントを投稿しました"
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
    
    int pass_ranking=-1;
    [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsCommentsViewController = [[DetailsCommentsViewController alloc] 
                                      initWithNibName:@"DetailsCommentsViewController" 
                                      bundle:nil];
    _detailsCommentsViewController.image_id = image_id;
    
	//[self.navigationController pushViewController:_detailsCommentsViewController 
	//									 animated:YES];
    
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
    
    //このへん後で直す、一旦これで
    int num = [image_id intValue];
    int canReport;
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp= [loadingapi detailPostimage:num:nil];
    
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            canReport=[[dic objectForKey:@"can_report"] integerValue];//iine数
        }
    }
    if(canReport ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"すでに通報済みの画像です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"やめる"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"カテゴリが違う",
                                  @"著作権・肖像権を侵害している",
                                  @"規約違反",
                                  @"その他",
                                  nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:sender];
    [actionSheet release];
    
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *reason;
    int reason_id;
    switch (buttonIndex) {
        case 0:
            reason_id = 0;
            break;        
        case 1:
            reason_id = 1;
            break;        
        case 2:
            reason_id = 2;
            break;        
        case 3:
            reason_id = 3;
            break;        
        default:
            return;
            break;
    }
    int num = [image_id intValue];
    loadingAPI *loadingapi = [[loadingAPI alloc]init];
    [loadingapi saveReport:num:reason_id];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"通報しました"
                          message:@"ご報告ありがとうございます"
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
    
}

- (void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillAppear:(BOOL)animated{}
@end
