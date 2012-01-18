//
//  DetailsViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/13.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "DetailsViewController.h"
#import "loadingAPI.h"
#import "UIAsyncImageView.h"
#import "DetailsShareViewConroller.h"
#import "DetailsDataViewController.h"
#import "DetailsCommentsViewController.h"
#import "RankingViewController.h"
#import "DetailsPictureViewController.h"
#import "PostEditViewController.h"


@implementation DetailsViewController

@synthesize re_value;
@synthesize detail_post_btn;
@synthesize main_window;
@synthesize main_scrollView;//@synthesize Tw_post_flag,Fb_post_flag,Mx_post_flag;
//@synthesize inputText,uptext;

- (void)viewDidLoad
{
    //uploadFlag=0;
    PostEditViewController *pvc = [[PostEditViewController alloc]init];
    //NSLog(@"inputText.text%@",uptext);
    //  if(pvc.inputText.text!=nil)uploadFlag=1;
    
    [self details_info_load];
    UIImage *top_img = [UIImage imageNamed:@"common_commonnavi_0.png"];
    [top_image setImage:top_img];
    NSLog(@"ssss");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
    main_window.frame = CGRectMake(0, 0, 320, 480);
    [main_scrollView addSubview:main_window];
    [self ShowActivity];
    
}
-(void)viewWillAppear:(BOOL)animated{}



- (void)details_info_load
{
    
    NSLog(@"@%@",re_value);
    more1_label.text = re_value;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    int image_id = [re_value intValue];
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp= [loadingapi detailPostimage:image_id:nil];
    NSLog(@"aaa %@",restmp);
    
    int evaluationCount= 0;
    int imgWidth=180;//262
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            evaluationCount=[[dic objectForKey:@"evaluation"] integerValue];//iine数
            canReport = [[dic objectForKey:@"can_report"] integerValue];//iine数
            // UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
            
            
            UIImageView *ai= [[UIImageView alloc] init];            
            NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"real_path"]];
            NSLog(@"uri = %@",uri);
            NSData *dt = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:uri]];
            UIImage *image = [[UIImage alloc] initWithData:dt];
            ai.image=[self imageByCropping:image];
            
            
            // [ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            
            //  CGRect rect = ai.frame;
            //  rect.size.height = 100;
            //  rect.size.width = 100;
            //  ai.frame = rect;
            ai.tag = i;
            //plz set Frame size this erea
            ai.frame = CGRectMake(0, 0, 262, 262);
            [detail_iamgeView addSubview:ai];
            [ai release];
            
            fid = [[dic objectForKey:@"uid"]intValue];
            iine_flag =[[dic objectForKey:@"can_evaluation"]intValue];
        }
        
        
        //iineCount
        iine_label.text = [NSString stringWithFormat:@"%d",evaluationCount];
        if(Uid == fid || iine_flag ==0){
            iine_button.hidden =YES;
            iine_text.hidden =YES;
        }
        NSLog(@"evaluationCount %d",evaluationCount);
        NSLog(@"canRreport %d",canReport);
    }
    
}


//画像のクロッピング
- (UIImage*)imageByCropping:(UIImage *)imageToCrop// toRect:(CGRect)rect
{
    
    int startX=0;
    int startY=0;
    int newWidth= imageToCrop.size.width;
    int newHeight=imageToCrop.size.height;
    // NSLog(@"oldx %d",newWidth);
    // NSLog(@"oldy %d",newHeight);
    
    //クロップ
    if(newWidth>newHeight)
    {
        int clopSize=newWidth-newHeight;
        startX=clopSize/2;
        newWidth-=clopSize;//これはこれで
        // NSLog(@"width sx%d nw%d nh%d cs%d",startX,newWidth,newHeight,clopSize);
    }
    else if(newHeight>newWidth) 
    {
        int clopSize=newHeight-newWidth;
        startY=clopSize/2;
        newHeight-=clopSize;
        //NSLog(@"height sy%d nw%d nh%d cs%d",startY,newWidth,newHeight,clopSize);
    }
    // NSLog(@"newx %d",newWidth);
    // NSLog(@"newy %d",newHeight);
    
    CGRect rect= CGRectMake(startX, startY, newWidth,newHeight);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(
                                                       [imageToCrop CGImage], rect);
    UIImage *cropped =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}



-(IBAction) iine_down:(id)sender;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック  
    }

    int image_id = [re_value intValue];
    NSLog(@"%d",image_id);
    
    NSLog(@"%d",fid);


    [self ShowActivity];
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //block arg
    NSDictionary *restmp2= [loadingapi isBlockUser:image_id];
    NSDictionary *dic2 = [restmp2 objectForKey:@"result"];
    if([[dic2 objectForKey:@"blocked"]intValue] == 0){
        [loadingapi saveEvaluation:image_id];
    }
    NSLog(@"ISbloac %@",[dic2 objectForKey:@"blocked"]);
    
    NSDictionary *restmp= [loadingapi detailPostimage:image_id:nil];
    
    int evaluationCount;
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            evaluationCount=[[dic objectForKey:@"evaluation"] integerValue];//iine数
        }
    }
    
    iine_label.text = [NSString stringWithFormat:@"%d",evaluationCount];
    
    
    //   if(uploadFlag==1)
    //   {
    //       [self uploadSNS];
    //  }
}


-(IBAction) back_btn_down:(id)sender;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int pass_ranking = [[defaults stringForKey:@"PASS_RANKING"] intValue];
    if(pass_ranking != -1){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.navigationController popViewControllerAnimated:NO];
    }
}

/*
 -(IBAction) back_btn_down:(id)sender;
 {    
 //詳細はどこをを経由したか？YES
 //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
 
 int pass_ranking;
 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
 pass_ranking = [[defaults stringForKey:@"PASS_RANKING"] intValue];
 NSLog(@"deteails back%d",pass_ranking);
 
 if(pass_ranking==4){
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _tagpageViewController = [[TagpageViewController alloc] 
 initWithNibName:@"TagpageViewController" 
 bundle:nil];
 [self.navigationController pushViewController:_tagpageViewController 
 animated:YES];
 }
 else if(pass_ranking==3){
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _searchViewController = [[SearchViewController alloc] 
 initWithNibName:@"SearchViewController" 
 bundle:nil];
 [self.navigationController pushViewController:_searchViewController 
 animated:YES];
 }
 
 else if(pass_ranking==2){
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _mypageViewController = [[MypageViewController alloc] 
 initWithNibName:@"MypageViewController" 
 bundle:nil];
 [self.navigationController pushViewController:_mypageViewController 
 animated:YES];
 }
 else if(pass_ranking==1){
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _rankingViewController = [[RankingViewController alloc] 
 initWithNibName:@"RankingViewController" 
 bundle:nil];
 [self.navigationController pushViewController:_rankingViewController 
 animated:YES];
 }
 else{
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 [self.navigationController popToRootViewControllerAnimated:YES];
 }
 }
 */

-(IBAction) details_btn_down:(id)sender;
{
    UIImage *top_img = [UIImage imageNamed:@"common_commonnavi_0.png"];
    [top_image setImage:top_img];
    NSLog(@"ssss");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
    main_window.frame = CGRectMake(0, 0, 320, 480);
    [main_scrollView addSubview:main_window];
}


-(IBAction) detailsData_btn_down:(id)sender;
{
    UIImage *top_img = [UIImage imageNamed:@"common_commonnavi_1.png"];
    [top_image setImage:top_img];
    _detailsDataViewController = [[DetailsDataViewController alloc] 
                                  initWithNibName:@"DetailsDataViewController" 
                                  bundle:nil];
    _detailsDataViewController.image_id = re_value;
    
    NSLog(@"self._nav%@",self.navigationController);
    UINavigationController *_nabi = [[UINavigationController alloc]init];
    _nabi = self.navigationController;
    _detailsDataViewController.nabi = _nabi;
    [main_scrollView addSubview:_detailsDataViewController.view];
    /*
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsDataViewController = [[DetailsDataViewController alloc] 
                                  initWithNibName:@"DetailsDataViewController" 
                                  bundle:nil];
    _detailsDataViewController.image_id = re_value;
	[self.navigationController pushViewController:_detailsDataViewController 
										 animated:NO];
     */
     
}

-(IBAction) detailsComments_btn_down:(id)sender;
{
    UIImage *top_img = [UIImage imageNamed:@"common_commonnavi_2.png"];
    [top_image setImage:top_img];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsCommentsViewController = [[DetailsCommentsViewController alloc] 
                                      initWithNibName:@"DetailsCommentsViewController" 
                                      bundle:nil];
    UINavigationController *_nabi = [[UINavigationController alloc]init];
    _nabi = self.navigationController;
    _detailsCommentsViewController.nabi = _nabi;
    _detailsCommentsViewController.image_id = re_value;
	[main_scrollView addSubview:_detailsCommentsViewController.view];
    //[self.navigationController pushViewController:_detailsCommentsViewController 
	//									 animated:NO];
    
}

-(IBAction) detailsShare_btn_down:(id)sender;
{
    UIImage *top_img = [UIImage imageNamed:@"common_commonnavi_3.png"];
    [top_image setImage:top_img];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsShareViewConroller = [[DetailsShareViewConroller alloc] 
                                  initWithNibName:@"DetailsShareViewConroller" 
                                  bundle:nil];
    _detailsShareViewConroller.image_id = re_value;
    [main_scrollView addSubview:_detailsShareViewConroller.view];
    //[self.navigationController pushViewController:_detailsShareViewConroller 
    //                                     animated:NO];
     
}

-(IBAction) favorite_btn_down:(id)sender;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        [self loginAlert];//ユーザーチェック
        return;
    }
}

-(IBAction) img_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsPictureViewController = [[DetailsPictureViewController alloc] 
                                     initWithNibName:@"DetailsPictureViewController" 
                                     bundle:nil];
    _detailsPictureViewController.re_value = re_value;
    [self.navigationController pushViewController:_detailsPictureViewController 
                                         animated:YES];
    
}
/*
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
 
 // アラートのボタンが押された時に呼ばれるデリゲート例文
 -(void)alertView:(UIAlertView*)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex {
 
 switch (buttonIndex) {
 case 0:
 //１番目のボタンが押されたときの処理を記述する
 break;
 case 1:
 //２番目のボタンが押されたときの処理を記述する
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _detailsViewController = [[DetailsViewController alloc] 
 initWithNibName:@"DetailsViewController" 
 bundle:nil];
 [self.navigationController pushViewController:_detailsViewController 
 animated:YES];
 break;
 }
 
 }
 */
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
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    //このへん後で直す、一旦これで
    int image_id = [re_value intValue];
    NSDictionary *restmp= [loadingapi detailPostimage:image_id:nil];
    
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
    int num = [re_value intValue];
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
@end
