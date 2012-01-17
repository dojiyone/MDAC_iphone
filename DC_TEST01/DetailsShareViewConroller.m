//
//  DetailsShareViewConroller.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "DetailsShareViewConroller.h"
#import "DetailsViewController.h"
#import "DetailsDataViewController.h"
#import "DetailsCommentsViewController.h"
#import "MixiTestViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "SecondViewController.h"
#import "loadingAPI.h"
#import "SecondViewController.h"


@implementation DetailsShareViewConroller
@synthesize re_value;
@synthesize image_id;

- (void)viewDidLoad
{ 
    SecondViewController *svc = [[SecondViewController alloc]init];
    
    
    UIImage *img_tw_on = [UIImage imageNamed:@"details_twitter_1.png"];
    UIImage *img_fb_on = [UIImage imageNamed:@"details_facebook_1.png"];
    UIImage *img_mixi_on = [UIImage imageNamed:@"details_mixi_1.png"];
    
    UIImage *img_tw_off = [UIImage imageNamed:@"details_twitter_0.png"];
    UIImage *img_fb_off = [UIImage imageNamed:@"details_facebook_0.png"];
    UIImage *img_mixi_off = [UIImage imageNamed:@"details_mixi_0.png"];
    
    //mixi_share_btn;
    
    //main1.hidden=YES;
    //main2.hidden=YES;
    //main3.hidden=YES;
    
    
    
    
    /*
     //twitter
     if([svc getSnsLoginStatus:1]==0){
     [tw_share_btn setBackgroundImage:img_tw_off forState:UIControlStateNormal];
     }
     if([svc getSnsLoginStatus:1]==1){
     [tw_share_btn setBackgroundImage:img_tw_on forState:UIControlStateNormal];
     }
     //facebook
     if([svc getSnsLoginStatus:2]==0){
     [fb_share_btn setBackgroundImage:img_fb_off forState:UIControlStateNormal];
     }    
     if([svc getSnsLoginStatus:2]==1){
     [fb_share_btn setBackgroundImage:img_fb_on forState:UIControlStateNormal];
     }
     //mixi
     if([svc getSnsLoginStatus:3]==0){
     [mixi_share_btn setBackgroundImage:img_mixi_off forState:UIControlStateNormal];
     }
     if([svc getSnsLoginStatus:3]==1){
     [mixi_share_btn setBackgroundImage:img_mixi_on forState:UIControlStateNormal];
     }
     }*/
    
    
    
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *twAccessToken=[defaults objectForKey:@"TwitterAccessToken"];
    NSString *miAccessToken=[defaults objectForKey:@"MixiAccessToken"];
    NSString *fbAccessToken=[defaults objectForKey:@"FBAccessToken"];
    
    
    //twitter
    if(twAccessToken==nil)
    {
        [tw_share_btn setBackgroundImage:img_tw_off forState:UIControlStateNormal];
        tw_share_btn.tag=0;
        twflag=0;
    }
    else
    {
        [tw_share_btn setBackgroundImage:img_tw_on forState:UIControlStateNormal];
        tw_share_btn.tag=1;
        twflag=1;
    }
    
    //facebook
    if(fbAccessToken==nil)
    {
        [fb_share_btn setBackgroundImage:img_fb_off forState:UIControlStateNormal];
        fb_share_btn.tag=0;
        fbflag=0;
    }
    else
    {
        [fb_share_btn setBackgroundImage:img_fb_on forState:UIControlStateNormal];
        fb_share_btn.tag=1;
        fbflag=1;
    }
    //mixi
    if(miAccessToken==nil)
    {
        [mixi_share_btn setBackgroundImage:img_mixi_off forState:UIControlStateNormal];
        mixi_share_btn.tag=0;
        miflag=0;
    }
    else
    { 
        [mixi_share_btn setBackgroundImage:img_mixi_on forState:UIControlStateNormal];
        mixi_share_btn.tag=1;
        miflag=1;
    }
    
    NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];    
    if ([MainSNS isEqualToString:@"twitter"])
    {
        main1.hidden =YES; 
        main3.hidden =YES;
    }
    else if ([MainSNS isEqualToString:@"facebook"])
    {
        main2.hidden =YES; 
        main3.hidden =YES;
    }
    else if ([MainSNS isEqualToString:@"mixi"])
    {
        main1.hidden =YES; 
        main2.hidden =YES; 
    }
    else
    {
        main1.hidden =YES; 
        main2.hidden =YES; 
        main3.hidden =YES;
    }
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

-(IBAction)Twittershare:(UIButton *)button
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *twAccessToken=[defaults objectForKey:@"TwitterAccessToken"];
    
    UIImage *img_tw_on = [UIImage imageNamed:@"details_twitter_1.png"];
    UIImage *img_tw_off = [UIImage imageNamed:@"details_twitter_0.png"];
    
    
    
    //twitter
    if(button.tag==1)
    {
        NSLog(@"ここまできた");
        [button setBackgroundImage:img_tw_off forState:UIControlStateNormal];
        button.tag=0;
        twflag=0;
    }
    else if(button.tag==0 && twAccessToken!=nil)
    {
        NSLog(@"ここまできた?");
        [button setBackgroundImage:img_tw_on forState:UIControlStateNormal];
        button.tag=1;
        twflag=1;
    }
}

-(IBAction)Facebookshare:(UIButton *)button
{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *fbAccessToken=[defaults objectForKey:@"FBAccessToken"];
    
    UIImage *img_fb_on = [UIImage imageNamed:@"details_facebook_1.png"];
    UIImage *img_fb_off = [UIImage imageNamed:@"details_facebook_0.png"];
    if(button.tag==1)
    {
        [button setBackgroundImage:img_fb_off forState:UIControlStateNormal];
        button.tag=0;
        fbflag=0;
    }
    
    else if(button.tag==0 && fbAccessToken!=nil)
    {
        [button setBackgroundImage:img_fb_on forState:UIControlStateNormal];
        button.tag=1;
        fbflag=1;
    }
}

-(IBAction)Mixishare:(UIButton *)button
{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *miAccessToken=[defaults objectForKey:@"MixiAccessToken"];
    
    UIImage *img_mixi_on = [UIImage imageNamed:@"details_mixi_1.png"];
    UIImage *img_mixi_off = [UIImage imageNamed:@"details_mixi_0.png"];
    if(button.tag==1)
    {
        [button setBackgroundImage:img_mixi_off forState:UIControlStateNormal];
        button.tag=0;
        miflag=0;
    }
    
    else if(button.tag==0 && miAccessToken!=nil)
    {
        [button setBackgroundImage:img_mixi_on forState:UIControlStateNormal];
        button.tag=1;
        miflag=1;
    }
}


//外部からのシェア
-(void)inputShare:(NSString *)updateText:(NSString *)post_image_id:(int)Tw_post_flag:(int)Fb_post_flag:(int)Mx_post_flag
{
    NSLog(@"input");
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0||Uid==nil){
        return;
    }
    
    NSString *meetTitle;
    NSDictionary *restmp;
    
    
    meetTitle=@"Meet！Dogs’nCats http://meet-dogsncats.com/";
    
    
    NSString *encUrl=@"";
    if(post_image_id!=nil)
    {            
        //短縮URL生成
        encUrl=[self encodeShorten:post_image_id];
        encUrl=[NSMutableString stringWithFormat:@"%@%@",DATA_SERVER_URL,encUrl];
    }
    
    int snsFlag=0;
    int snsType=0;
    NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];    
    if ([MainSNS isEqualToString:@"twitter"])
    {
        snsType=1;
    }
    else if ([MainSNS isEqualToString:@"facebook"])
    {
        snsType=2;
    }
    else if ([MainSNS isEqualToString:@"mixi"])
    {
        snsType=3;
    }
    
    
    
    NSString *twAccessToken=[defaults objectForKey:@"TwitterAccessToken"];
    NSString *fbAccessToken=[defaults objectForKey:@"FBAccessToken"];
    NSString *miAccessToken=[defaults objectForKey:@"MixiAccessToken"];
    
    NSString *baseString=@"";
    NSLog(@"token%@ flag%d",twAccessToken,Tw_post_flag);
    if( twAccessToken!=nil && Tw_post_flag==1)
    {
        NSLog(@"twitter post");
        if(snsType==1)  snsFlag=1;
        [self TwittershareUpdate:Uid:updateText:encUrl:meetTitle];
        baseString= [NSString stringWithFormat:@"%@twitterに投稿しました。\n",baseString];
    }
    
    if(fbAccessToken!=nil && Fb_post_flag==1)
    {
        if(snsType==2)  snsFlag=1;
        [self FacebookshareUpdate:Uid:updateText:encUrl:meetTitle];
        baseString= [NSString stringWithFormat:@"%@Facebookに投稿しました。\n",baseString];
    }
    
    NSLog(@"mitoken%@ flag%d",miAccessToken,Tw_post_flag);
    if(miAccessToken!=nil && Mx_post_flag==1)
    {
        if(snsType==3)  snsFlag=1;
        [self MixishareUpdate:Uid:updateText:encUrl:meetTitle];
        baseString= [NSString stringWithFormat:@"%@mixiに投稿しました。\n",baseString];
    }
    
    
    //SNS履歴の保存
    if(snsFlag==1)  
    {
        loadingAPI* loadingapi=[[loadingAPI alloc] init];
        [loadingapi saveSnsHistory:post_image_id];
        [loadingapi release];
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"投稿完了"
                               message:baseString
                              delegate:nil cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alert show];
    [alert release];
}


//短縮URL変換
-(NSString *)encodeShorten:(NSString *)imageString
{
	NSString *KEY =@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    int imageID=[imageString intValue];
    NSLog(@"imageID %d",imageID);
    int keyLen=[KEY length];
    
    NSString *sb=@"";
    NSString *sb2=@"";
    while (imageID > 0) 
        //for(int i=0;i<imageID;)
    {
        int amari = (int) (imageID % keyLen);
        NSLog(@"amari %d",amari);
        
        sb2 =[KEY substringWithRange:NSMakeRange(amari,1)];//開始位置、切り出し数（終了位置ではない
        sb =[NSString stringWithFormat:@"%@%@",sb2,sb];
        //sb =[sb stringByAppendingString:sb2];
        NSLog(@"sb %@",sb);
        imageID -= amari;
        //NSLog(@"imageIDa %d",imageID);
        imageID /= keyLen;
        //NSLog(@"imageIDb %d",imageID);
    }
    
    NSLog(@"sb end %@",sb);
    return sb;
}
/*
 StringBuffer sb = new StringBuffer();
 while (l > 0) {
 int amari = (int) (l % KEY.length());
 sb.insert(0, KEY.substring(amari, amari + 1));
 l -= amari;
 l /= KEY.length();
 }
 return sb.toString();
 */





//テキストフォーカス終わり
-(void)hoge3:(UITextField*)textfield
{
    [textfield resignFirstResponder];
    
    //  [dataSource_ removeLastObject]; 
    // [dataSource_ addObject:textField.text];
    // NSLog(@"text %@",textfield.text);
    
    
    //[dataSource_ addObject:textView.text];
    
    //NSLog(@"textfield%@",textView.text);
}

//-(void)tagButtonPressed:(UIButton *)button//:(int)test

//タグボタン
-(IBAction)sns_share_btn_down:(id)sender
{
    // NSLog(@"button %@",sender);
    
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
    
    if(twflag==0&&fbflag==0&&miflag==0)
    {    
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"シェアするSNSを1つ以上選択して下さい。"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    [self ShowActivity];
    
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"シェア"
                                                    message:@" \n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"投稿する"
                                          otherButtonTitles:@"やめる",nil];
    alert.tag=2;
    //オブジェクトを強制的に移動
    //CGAffineTransform trans = CGAffineTransformMakeTranslation(0.0, 100.0); 
    //[alert setTransform:trans];
    
    
    textView =[[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 70.0)];
    textView.borderStyle=UITextBorderStyleRoundedRect;
    
    textView.text = @"";
    textView.textAlignment = UITextAlignmentLeft;
    textView.font = [UIFont fontWithName:@"Arial" size:20.0f];
    textView.backgroundColor = [UIColor whiteColor];
    
    
    //フォーカスがはずれたときの処理
    [textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    [alert addSubview:textView];
    [alert show];
    [alert release];
    
    [textView becomeFirstResponder];
    [textView release];
    
}

//アラーと出現直前にサイズを調整
/*- (void)willPresentAlertView:(UIAlertView *)alertView
 {
 if(loadTextView==1) return;
 loadTextView=1;
 
 if (alertView.tag == 2) 
 {
 CGRect frame = alertView.frame;
 frame.origin.y = 10;//中身の高さ
 frame.size.height = 250;//外枠のサイズ
 alertView.frame = frame;
 
 for (UIView* view in alertView.subviews)
 {
 frame.origin.y += 10;
 view.frame = frame;
 }
 }
 }
 
 */



-(bool)TwittershareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle
{
    //１４０字
    int totalLen=140;
    
    NSString *updateText2= [NSString stringWithFormat:@"%@ %@",encUrl,meetTitle];
    int textlen = totalLen-[updateText2 length];
    
    if ([updateText length]>textlen) 
        updateText =[updateText substringToIndex:textlen];
    //結合
    updateText2= [NSString stringWithFormat:@"%@ %@",updateText,updateText2];
    
    NSLog(@"test %@",updateText2);
    TwTestViewController *_tw = [[TwTestViewController alloc]init];
    [_tw postMessage:updateText2];
    return true;
    
    
    /*
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
     if(Uid==0)  [self loginAlert];//ユーザーチェック    
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"postToTwitter"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     DC_TEST01AppDelegate *myApp = (DC_TEST01AppDelegate *)[UIApplication sharedApplication].delegate;
     [myApp twitterAccountLogin];
     */
}

-(bool)FacebookshareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle
{       
    //420文字制限
    int totalLen=420;
    
    NSString *updateText2= [NSString stringWithFormat:@"%@ %@",encUrl,meetTitle];
    int textlen = totalLen-[updateText2 length];
    
    if ([updateText length]>textlen) 
        updateText =[updateText substringToIndex:textlen];
    //結合
    updateText2= [NSString stringWithFormat:@"%@ %@",updateText,updateText2];
    
    FBTestViewController *_fb = [[FBTestViewController alloc]init];
    
    [_fb postMessage:updateText2];
    return true;
    
}

-(bool)MixishareUpdate:(int)Uid:(NSString *)updateText:(NSString *)encUrl:(NSString *)meetTitle
{    
    //150字
    int totalLen=150;
    
    NSString *updateText2= [NSString stringWithFormat:@"%@ %@",encUrl,meetTitle];
    int textlen = totalLen-[updateText2 length];
    
    if ([updateText length]>textlen) 
        updateText =[updateText substringToIndex:textlen];
    //結合
    updateText2= [NSString stringWithFormat:@"%@ %@",updateText,updateText2];
    
    
    //if([svc getSnsLoginStatus:3]==1)
    //{
    MixiTestViewController *_mx = [[MixiTestViewController alloc]init];
    NSLog(@"mmixii");
    [_mx postMessage:updateText2];
    return true;
    //}
    
    //return false;
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


// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    if(Uid==0){
        return;
    }
    
    if([textView.text isEqualToString:@""]){
        switch (buttonIndex)
        {
            case 1:
                NSLog(@"iie");
                return;
                break;
            case 0:
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"コメントが未入力です"
                              message:@"コメントを入力してください"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSString *meetTitle;
    NSDictionary *restmp;
    NSString *post_image_id;
    switch (buttonIndex)
    {
        case 1:
            NSLog(@"iie");
            
            break;
        case 0:
            
            NSLog(@"hai %@",textView.text);
            NSString* updateText=textView.text;
            
            
            /* loadingAPI* loadingapi=[[loadingAPI alloc] init];
             restmp= [loadingapi getEncodeURL:image_id];
             
             NSLog(@"res %@",restmp);
             int cnt = [[restmp objectForKey:@"result"] count];
             for (int i=0; i<cnt; i++) 
             {
             NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
             for (NSDictionary *dic in result) 
             {
             post_image_id=[dic objectForKey:@"post_image_id"];
             }
             }*/
            
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
            
            NSString *twAccessToken=[defaults objectForKey:@"TwitterAccessToken"];
            NSString *miAccessToken=[defaults objectForKey:@"MixiAccessToken"];
            NSString *fbAccessToken=[defaults objectForKey:@"FBAccessToken"];
            
            int Tw_post_flag=0;
            int Fb_post_flag=0;
            int Mx_post_flag=0;
            if( twAccessToken!=nil &&twflag==1)
            {
                Tw_post_flag=1;
            }
            if(fbAccessToken!=nil &&fbflag==1)
            {
                Fb_post_flag=1;
            }
            if(miAccessToken!=nil &&miflag==1)
            {
                Mx_post_flag=1;
            }
            
            //投稿処理
            [self inputShare:updateText:image_id:Tw_post_flag:Fb_post_flag:Mx_post_flag];
            
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{}

- (void)viewDidAppear:(BOOL)animated
{
}
@end
