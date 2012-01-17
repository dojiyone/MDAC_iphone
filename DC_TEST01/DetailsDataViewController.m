//
//  DetailsDataViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "DetailsShareViewConroller.h"
#import "DetailsViewController.h"
#import "DetailsDataViewController.h"
#import "DetailsCommentsViewController.h"
#import "loadingAPI.h"
#import "FanpageViewController.h"
#import "MypageViewController.h"
#import "TagpageViewController.h"
#import "TageditViewController.h"
#import "dataButton.h"
#import "UIAsyncImageView.h"

@implementation DetailsDataViewController
@synthesize re_value;
@synthesize image_id;
@synthesize uid;
@synthesize deletaLabel;
@synthesize detail_data_scrollView;
@synthesize nabi;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   tableView.delegate =self;
   tableView.dataSource = self;
    
   tableView.contentMode = UIViewContentModeTopLeft;
   tableView.autoresizingMask = UIViewAutoresizingNone;
    dataSource_ = [[NSMutableArray alloc] initWithObjects:
                   @"",@"",@"", nil ];
    
    
    //NSLog(@"tagend %@",uid);
    
    //取得
    int fid = [uid integerValue]; 
    //NSLog(@"uid %d",fid);
    
    //Default例文
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setInteger:fid forKey:@"FOLLOW_ID"];
    [defaults setInteger:1 forKey:@"FROM_ALBUM"];

    [self details_info_load];
    [self tag_load];
}


//詳細の設定情報テーブル表示///////////////////////////////////////////
- (void)details_info_load
{
    [detail_data_scrollView setContentSize:CGSizeMake(320,806)];
    
    //NSLog(@"@%@",image_id);
    
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    long num = [image_id intValue];
    NSDictionary *restmp=[loadingapi detailPostimage:num :NULL];
    
    int tagNum = [[restmp objectForKey:@"result"] count];
    int i=0;
    
    int textmargin = 69;//テキストのマージン
    
    for (i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            Conmment =[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
            Date =[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_date"]];
            post_image_name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_image_name"]];
            name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            access_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_count"]];
            ref_album_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"ref_album_count"]];
            ref_access_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_count"]];
            category = [NSString stringWithFormat:@"%@",[dic objectForKey:@"category_id"]];
            
            uid =[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
            //NSLog(@"uid %@",uid);
            str = [NSString stringWithFormat:@"アルバム登録数（%@）",ref_album_count];
            accessCount = [NSString stringWithFormat:@"アクセス数（%@）",ref_access_count];
            if([category isEqualToString:@"0"]){
                category_text = [NSString stringWithFormat:@"カテゴリ :（犬）"];
            }
            else if([category isEqualToString:@"1"]){
                category_text = [NSString stringWithFormat:@"カテゴリ :（猫）"];
            }
            
            
            
        }
    }
    int Fid = [uid integerValue]; 

    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:Fid forKey:@"FOLLOW_ID"];
    
    NSDictionary *restmp3 =[loadingapi getUserInfo:Fid];
    //NSLog(@"1 %@",restmp3);
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp3 objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            /*
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
            */
            
            //ユーザーアイコン
            NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"icon_path"]];
            //NSLog(@"uri = %@",uri);
            NSData *dt = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:uri]];
            icon_image = [[UIImage alloc] initWithData:dt];
            
            
            
        }
        //[detail_data_scrollViewfanpage setContentSize:CGSizeMake(320,230 + (1*108))];
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
}


-(void)viewWillAppear:(BOOL)animated
{
}
-(void)tag_load
{
    
    taglabel = [[UILabel alloc] init];
    taglabel.frame = CGRectMake(20, 407, 287, 186);
    taglabel.backgroundColor = [UIColor orangeColor];
    taglabel.textAlignment = UITextAlignmentCenter;
    taglabel.layer.masksToBounds = YES;  
    taglabel.layer.cornerRadius = 10; 
    [detail_data_scrollView addSubview:taglabel];
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    long num = [image_id intValue];
    NSDictionary *restmp=[loadingapi detailPostimage:num :NULL];
    
    
    
    int tagNum = [[restmp objectForKey:@"result"] count];
    int i=0;
    
    
    //タグ表示///////////////////////////////////////////////////////////////
    
    NSDictionary *restmp2=[loadingapi getTags:num];
    //NSLog(@"aaa %@",restmp2);
    int tagNum2 = [[restmp2 objectForKey:@"result"] count];
    
    
    
    //NSString *tagString;
    int strScale=24;
    
    int strlenPx=0;
    int strlenPxMae=0;
    int strlen=0;
    NSString *tagString;
    NSString *tagStringMae;
    NSString *tagStringAmari;
    
    int nowY=414;
    int nowX=26;
    //NSLog(@"tagNum2 %d",tagNum2);
    
    //tag_count >= 10 は2倍
    //tag_count >= 5 は1.5倍
    //tag_count >= 3 は1.2倍
    for (i=0; i<tagNum2; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp2 objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            bool amariflag=false;
            
            //各tagキーの文字列を取り出し配列に入れる
            tagString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]];
            //tagString=[self hankakuZenkakuKana:tagString];
            
            strlen = [tagString length];
            int hanstrlen =[self strLength:tagString:strlen];
            //NSLog(@"tex %@ strlen %d hanren %d",tagString,strlen,hanstrlen);
            float tagCount= [[dic objectForKey:@"tag_count"] integerValue];            
            
            //個別タグ表示では等倍
            /* if(tagCount >=10) tagCount=2;
             else if(tagCount >=5)tagCount=1.5;
             else if(tagCount >=3)tagCount=1.2;
             else*/                tagCount=1;
            
            strScale=14*tagCount;
            strlenPx=strScale*hanstrlen;//半角分を除外して長さを計算する
            
            int amariX=nowX+strlenPx;//現在地Xと今回の文字列距離を足す
            //NSLog(@"amariX1 %d",amariX);
            if(amariX>300)//画面端へ到達
            {
                amariflag=true;
                amariX=amariX-300;
                // NSLog(@"amariX2 %d",amariX);
                
                strlenPxMae=strlenPx-amariX;
                
                //NSLog(@"strlenPxMae %d",strlenPxMae);
                int strlenCenter=strlenPxMae/strScale;
                strlenCenter=[self checkCenterStrCount:tagString:strlenCenter:strlenPxMae:strScale];
                
                if(strlenCenter<0)
                {
                    //NSLog(@"lentest1");
                    strlenCenter=0;
                }
                else if(strlenCenter>strlen)
                {
                    //NSLog(@"lentest2");
                    strlenCenter=strlen-1;
                }
                
                strlen=strlen-strlenCenter;
                //NSLog(@"strlenCenter %d",strlenCenter);
                tagStringAmari = [tagString substringWithRange:NSMakeRange(strlenCenter,strlen)];
                // NSLog(@"tagStringAmari %@",tagStringAmari);
                tagStringMae = [tagString substringWithRange:NSMakeRange(0, strlenCenter)];
                //NSLog(@"tagStringMae %@",tagStringMae);
                //strlenPx=strlenPx-strlenPxMae;
                //NSLog(@"strlenPx %d",strlenPx);
            }
            else
            {
                tagStringMae=tagString;
            }
            
            /* if(nowY>400)
             {
             i=tagNum2;
             continue;
             }*/
            //NSLog(@"end %d",strlenPx);
            if([tagStringMae length]>0)
            {
                dataButton* tagButton = [[dataButton alloc] initWithTitle:@"" data:tagString];
                
                tagButton.frame = CGRectMake(nowX, nowY, 24, 24);
                tagButton.titleLabel.font=[UIFont boldSystemFontOfSize:strScale];
                [tagButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                
                [tagButton addTarget:self action:@selector(printButtonData:) forControlEvents:UIControlEventTouchUpInside];
                [tagButton setTitle:tagStringMae forState:UIControlStateNormal];
                
                [tagButton sizeToFit];
                [detail_data_scrollView addSubview:tagButton];
            }
            
            //NSLog(@"nowX %d",nowX);
            if(amariflag==true)
            {      
                nowY=nowY+30;
                nowX=26;
                dataButton* tagButton2 = [[dataButton alloc] initWithTitle:@"" data:tagString];
                
                tagButton2.frame = CGRectMake(nowX, nowY, 24, 24);
                tagButton2.titleLabel.font=[UIFont boldSystemFontOfSize:strScale];
                [tagButton2 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                [tagButton2 addTarget:self action:@selector(printButtonData:) forControlEvents:UIControlEventTouchUpInside];
                //NSLog(@"amari %@",tagStringAmari);
                //NSLog(@"amari %d",strlenPx);
                [tagButton2 setTitle:tagStringAmari forState:UIControlStateNormal];
                [tagButton2 sizeToFit];
                [detail_data_scrollView addSubview:tagButton2];
                
                if(strlen==hanstrlen)   nowX=nowX+amariX+10;  
                else                    nowX=nowX+amariX+20;  
                
            }
            else
            {
                //半角混ざってるのと混ざってないので次のタグ表示までの幅を変える
                if(strlen==hanstrlen)   nowX=nowX+strlenPx+10;
                else                    nowX=nowX+strlenPx+20;
            }
        }  
        
    }    
    ///////////////////////////////////////////////////////////////////////////////    
}



// 半角文字列がある場合の判定（半角カナを含む）
// [\x20-\x7E\xA1-\xDF]
/*- (BOOL) hasHalfChar :(NSString *) aValue 
 {
 
 NSRange match = [aValue rangeOfString:@"[\x20-\x7E\xA1-\xDF]" options:NSRegularExpressionSearch];
 if (match.location != NSNotFound) 
 {
 return YES;
 }
 return NO;
 }*/
-(NSString *)hankakuZenkakuKana:(NSString *)tagstring
{
    return tagstring;
}

//文字の長さを正しく判定　文字列　仮の中央位置　前半分のピクセル幅　フォントのピクセルサイズ
-(int) checkCenterStrCount:(NSString *)tagString:(int)nowCenterCount:(int)strlenPxMae:(int)strScale
{
    int truthCount=0;
    int truthCenterPx=0;
    for(int i=0;i<nowCenterCount;i++)
    {
        
        NSString *oneStr = [tagString substringWithRange:NSMakeRange(i,1)];
        // 文字は存在しているので１をカウント
        truthCount++;
        // 全角だった場合はもう一つカウント
        
        NSRange match = [oneStr rangeOfString:@"[\x20-\x7E\xA1-\xDF]" options:NSRegularExpressionSearch];
        if (match.location != NSNotFound) {}
        else        truthCount++;
        
        //実際の長さ分確保できたところで終了
        truthCenterPx=truthCenterPx+strScale;
        if(strlenPxMae<truthCenterPx)   i=nowCenterCount;
        
    }
    
    //実態が小さい場合の微調整
    truthCount-=1;
    
    return truthCount;
}

// 文字の数を戻す（半角は１，全角は２としてカウント）
- (int) strLength :(NSString *) aValue :(int)strlen
{
    
    NSData *utf8Data = [aValue dataUsingEncoding:NSUTF8StringEncoding];
    int strCount = ([utf8Data length]+1)/2;
    if(strCount>strlen)strCount=strlen;//全角のみの場合は元値をいれる
    
    /* int strCount = [aValue length];
     int strCount2 = [sjisData length];
     NSLog(@"strcount2 %d",strCount2);
     if(strCount2>0)  strCount =strCount-(strCount2/2)+1;
     */
    
    
    /* for (int i = 0; i < [aValue length]; i++) 
     {
     NSString *oneStr = [aValue substringWithRange:NSMakeRange(i,1)];
     // 文字は存在しているので１をカウント
     strCount++;
     // 全角だった場合はもう一つカウント
     if (![self hasHalfChar:oneStr]) 
     {
     strCount++;
     }
     }*/
    //NSLog(@"strcount %d",strCount);
    return strCount;
}



/*
 
 -(void) setUIWebView:(NSString *)htmltext
 {
 
 _webview=[[UIWebView alloc]init];
 _webview.frame=self.view.bounds;
 _webview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
 _webview.dataDetectorTypes=UIDataDetectorTypeAll;
 _webview.delegate=self;
 [detail_data_scrollView addSubview:_webview];
 
 NSLog(@"html %@",htmltext);
 htmltext=[NSString stringWithFormat:@"<br>%@<br><br><br><br><br><br>",htmltext];
 
 [_webview loadHTMLString:htmltext baseURL:nil];
 }
 //リンククリック
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
 {
 NSString* URLString = [[[request URL] standardizedURL] absoluteString];
 NSLog(@"shouldStartLoadWithRequest= %@", URLString );
 
 //ファンページ
 NSRange searchResult = [URLString rangeOfString:@"uid:"];
 if(searchResult.location!= NSNotFound)
 {
 NSString *idstr =[URLString substringWithRange:NSMakeRange(4,[URLString length]-4)];
 NSLog(@"uid %@", idstr );        
 
 int fid = [idstr intValue];
 //Default例文
 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
 [defaults setInteger:fid forKey:@"FOLLOW_ID"];
 
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 _fanpageViewController = [[FanpageViewController alloc]
 initWithNibName:@"FanpageViewController" 
 bundle:nil];
 _fanpageViewController.re_value =URLString;
 [self.navigationController pushViewController:_fanpageViewController 
 animated:NO];
 
 
 return NO;
 }
 
 
 
 return YES;
 }
 //リンクエラー
 - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
 {
 NSLog(@"webエラーtest");
 } 
 */



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)printButtonData:(dataButton*)button 
{
    //NSLog(@"%@", button.data);
    
    //NSLog(@"%@", nabi);
    //}
    
    
    //タグボタン
    //-(UIButton *)tagStringPressed:(UIButton *)button//:(int)test
    //{
    _detailsViewController = [[DetailsViewController alloc] 
                                  initWithNibName:@"DetailsViewController" 
                                  bundle:nil];
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    
    NSString *tag_value = button.data;   
    
    _tagpageViewController.re_value = tag_value;
	[nabi pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = tag_value;
    _tagpageViewController._nav=self.navigationController;
}

- (void)tagButtonPressed:(id)sender;
{
    
    //NSLog(@"ボタン押下時のタグテキスト %@",sender);    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) detailsData_btn_down:(id)sender;
{
    
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


-(IBAction) fanpage_btn_down:(id)sender
{
    
    
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
    _tageditViewController.re_value = image_id;
	[nabi pushViewController:_tageditViewController 
										 animated:YES];
}

-(IBAction) add_album_btn_down:(id)sender
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
    [self ShowActivity];
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp = [loadingapi getAlbumList:Uid];
    //NSLog(@"アルバム一覧 %@",restmp);
    
    int cnt = [[restmp objectForKey:@"result"] count];
    
    
    //UIactionSheet を表示
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"アルバムに追加";
    albumSheetCount=cnt;
    for (int i=1; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog("res%@",result);
        for (NSDictionary *dic in result) 
        {
            
            [as addButtonWithTitle:[dic objectForKey:@"album_name"]];
        }
	}
    
    [as addButtonWithTitle:@"キャンセル"];
    _detailsViewController = [[DetailsViewController alloc] 
                              initWithNibName:@"DetailsViewController" 
                              bundle:nil];
    
    //as.cancelButtonIndex = nil;
    //as.destructiveButtonIndex = nil;
    [as showInView:self.view];  
    
    //int num = [image_id integerValue];
    //[loadingapi saveAlbumimage:1:num :0 :num];
    
}

// アクションシートのボタンが押された時に呼ばれるデリゲート例文
-(void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex 
{    
    if(actionSheet.tag ==3){
        int reason_id;
        switch (buttonIndex) 
        {
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
    else
    {
        //loadingAPI* loadingapi=[[loadingAPI alloc] init];
        int num = [image_id integerValue];
        //From_album ==ON;
        from_album =0;
        bool saveAlbumFlag=false;
        //NSLog(@"sheetcount %d",albumSheetCount);
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        from_album = [defaults integerForKey:@"FROM_ALBUM_FLAG"];
        NSLog(@"from_album%d",from_album);
        if(from_album >1)
        {
            loadingAPI* loadingapi=[[loadingAPI alloc] init];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
            int Fid=[defaults integerForKey:@"FROM_ALBUM_FLAG"];
           // NSLog(@"@@@@@@@ %d test",buttonIndex);
           // NSLog(@"@@@@@@@%d",Fid);
           // NSLog(@"@@@@@@@%d",Uid);
            
            switch (buttonIndex) 
            {
                case 0:
                    // １番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>1)
                    {
                        [loadingapi saveAlbumimage:1:num:@"true":Fid];
                        saveAlbumFlag=true;
                    }
                    break;
                case 1:
                    // ２番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>2){
                        [loadingapi saveAlbumimage:2:num:@"true":Fid];
                        saveAlbumFlag=true;
                    }
                    break;
                case 2:
                    // ３番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>3){
                        [loadingapi saveAlbumimage:3:num:@"true":Fid];
                        saveAlbumFlag=true;
                    }
                    break;
                default:
                    return;
                    break;
            }
        }
        else
        {
            switch (buttonIndex) 
            {
                case 0:
                    // １番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>1){
                        [loadingapi saveAlbumimage:1:num:0:num];
                        saveAlbumFlag=true;
                    }
                    break;
                case 1:
                    // ２番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>2){
                        [loadingapi saveAlbumimage:2:num:0:num];
                        saveAlbumFlag=true;
                    }
                    break;
                case 2:
                    // ３番目のボタンが押されたときの処理を記述する
                    if(albumSheetCount>3){
                        [loadingapi saveAlbumimage:3:num:0:num];
                        saveAlbumFlag=true;
                    }
                    break;
                default:
                    return;
                    break;
            }
        }
        
        if(saveAlbumFlag==true)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"アルバムに写真を追加しました"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
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


///////////////table/////////////////


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource_.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    int line = 20;
    int title_mar= 10;    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    long num = [image_id intValue];
    NSDictionary *restmp=[loadingapi detailPostimage:num :NULL];
    
    int tagNum = [[restmp objectForKey:@"result"] count];
    int i=0;
    
    int textmargin = 69;//テキストのマージン
    
    for (i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            Conmment =[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
            Date =[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_date"]];
            post_image_name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"post_image_name"]];
            name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            access_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_count"]];
            ref_album_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"ref_album_count"]];
            ref_access_count =[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_count"]];
            category = [NSString stringWithFormat:@"%@",[dic objectForKey:@"category_id"]];
            
            uid =[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
            //NSLog(@"uid %@",uid);
            str = [NSString stringWithFormat:@"アルバム登録数（%@）",ref_album_count];
            accessCount = [NSString stringWithFormat:@"アクセス数（%@）",ref_access_count];
            if([category isEqualToString:@"0"]){
                category_text = [NSString stringWithFormat:@"カテゴリ :（犬）"];
            }
            else if([category isEqualToString:@"1"]){
                category_text = [NSString stringWithFormat:@"カテゴリ :（猫）"];
            }
            
        }
    }
    
    static NSString* identifier = @"basis-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( nil == cell ) 
    {
        switch(indexPath.row)
        {
            case 0:                   
                cell = [[[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleValue1 
                         reuseIdentifier:identifier] 
                        autorelease]; 
                //[cell.contentView addSubview:[self pswitchForCell:cell]];
                
                cell.textLabel.textColor = [UIColor grayColor];
                
                cell.detailTextLabel.textColor = [UIColor grayColor];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //osirase（固定文言）
                deletaLabel = [[UILabel alloc] init];
                if([post_image_name length] <25)
                {
                    line =0;
                    title_mar=0;
                    titletable_height =50;
                }
                 
                
                deletaLabel.frame = CGRectMake(5,-20+title_mar, 294, 66);
                deletaLabel.numberOfLines = 0;//最大３行に指定
                deletaLabel.backgroundColor = [UIColor clearColor];
                //deletaLabel.font = [UIFont boldSystemFontOfSize:15];
                deletaLabel.textColor = [UIColor  grayColor];
                deletaLabel.textAlignment = UITextAlignmentLeft;
                deletaLabel.text = post_image_name;
                [cell.contentView addSubview:deletaLabel];
                titletable_height = 66;
                
                
                //osirase（固定文言）
                UILabel *deletaLabel2 = [[UILabel alloc] init];
                deletaLabel2.frame = CGRectMake(5, 5+line, 294, 66);
                deletaLabel2.numberOfLines = 3;//最大３行に指定
                deletaLabel2.backgroundColor = [UIColor clearColor];
                deletaLabel2.textAlignment = UITextAlignmentLeft;
                deletaLabel2.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                deletaLabel2.textColor = [UIColor  grayColor];
                deletaLabel2.text = str;
                [cell.contentView addSubview:deletaLabel2];
                
                //osirase（固定文言）
                UILabel *deletaLabel6 = [[UILabel alloc] init];
                deletaLabel6.frame = CGRectMake(150, 5+line, 294, 66);
                deletaLabel6.numberOfLines = 3;//最大３行に指定
                deletaLabel6.backgroundColor = [UIColor clearColor];
                deletaLabel6.textAlignment = UITextAlignmentLeft;
                deletaLabel6.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                deletaLabel6.textColor = [UIColor  grayColor];
                //deletaLabel6.text = accessCount;
                [cell.contentView addSubview:deletaLabel6];
                //osirase（固定文言）
                UILabel *deletaLabel3 = [[UILabel alloc] init];
                deletaLabel3.frame = CGRectMake(5, 25+line, 294, 66);
                deletaLabel3.numberOfLines = 3;//最大３行に指定
                deletaLabel3.backgroundColor = [UIColor clearColor];
                deletaLabel3.textAlignment = UITextAlignmentLeft;
                deletaLabel3.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                deletaLabel3.textColor = [UIColor  grayColor];
                deletaLabel3.text = [Date  substringToIndex:10];
                [cell.contentView addSubview:deletaLabel3];  
                
                //osirase（固定文言）
                UILabel *deletaLabel7 = [[UILabel alloc] init];
                deletaLabel7.frame = CGRectMake(150, 25+line, 294, 66);
                deletaLabel7.numberOfLines = 3;//最大３行に指定
                deletaLabel7.backgroundColor = [UIColor clearColor];
                deletaLabel7.textAlignment = UITextAlignmentLeft;
                deletaLabel7.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                deletaLabel7.textColor = [UIColor  grayColor];
                deletaLabel7.text = category_text;
                [cell.contentView addSubview:deletaLabel7];
                
                
                break;
            case 1:                   
                cell = [[[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleValue1 
                         reuseIdentifier:identifier] 
                        autorelease];       
                //[cell.contentView addSubview:[self pswitchForCell2:cell]];
                cell.textLabel.textColor = [UIColor grayColor];
                
                cell.detailTextLabel.textColor = [UIColor grayColor];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //osirase（固定文言）
                UITextView *deletaLabel4 = [[UITextView alloc] init];
                deletaLabel4.frame = CGRectMake(5, 0, 294, 80);
                deletaLabel4.backgroundColor = [UIColor clearColor];
                deletaLabel4.textAlignment = UITextAlignmentLeft;
                deletaLabel4.textColor = [UIColor  grayColor];
                
                deletaLabel4.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                deletaLabel4.editable =NO;
                deletaLabel4.text =Conmment;
                [cell.contentView addSubview:deletaLabel4];
                

                
                break;
            case 2:                   
                cell = [[[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleValue1 
                         reuseIdentifier:identifier] 
                        autorelease];       
                //[cell.contentView addSubview:[self pswitchForCell3:cell]];
                cell.textLabel.textColor = [UIColor grayColor];
                
                cell.detailTextLabel.textColor = [UIColor grayColor];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                //osirase（固定文言）
                UILabel *deletaLabel5 = [[UILabel alloc] init];
                deletaLabel5.frame = CGRectMake(66, -5, 200, 66);
                deletaLabel5.numberOfLines = 3;//最大３行に指定
                deletaLabel5.backgroundColor = [UIColor clearColor];
                deletaLabel5.textAlignment = UITextAlignmentLeft;
                
                deletaLabel5.textColor = [UIColor  grayColor];
                deletaLabel5.text =name;
                
                [cell.contentView addSubview:deletaLabel5];
                
                UIImageView *iv = [[UIImageView alloc] initWithImage:icon_image];
                iv.frame = CGRectMake(10, 10, 45, 45);
                [cell.contentView addSubview:iv];
                
                //NSLog(@"%f",deletaLabel5.bounds.size.height);
                 
                break;
        }
        
    }
     
    cell.textLabel.text = [dataSource_ objectAtIndex:indexPath.row];
    return cell;
     
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:CellIdentifier] 
                autorelease];
    }
    
    NSString *cellValue = [dataSource_ objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.row == 0){
        return 90;
    }
    if(indexPath.row == 1){
        return 80;
    }
    if(indexPath.row == 2){
        //NSLog(@"%f",deletaLabel.bounds.size.height) ;
        return 66;
    }   
     
    return 66;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if( indexPath.section == 0 ) {
        if( indexPath.row == 0 ) {
            //NSLog(@"tagend");
        }
        else if( indexPath.row == 2 )
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            //ログインID＝fanpageIDならmypageへ移動
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
            
            int Fid=[[defaults stringForKey:@"FOLLOW_ID"]intValue];
            //NSLog(@"move");
            if(Uid == Fid)
            {
                _mypageViewController = [[MypageViewController alloc] 
                                         initWithNibName:@"MypageViewController" 
                                         bundle:nil];
                [nabi pushViewController:_mypageViewController animated:YES];
                
            }
            else//各ユーザーページへジャンプ
            {
                _fanpageViewController = [[FanpageViewController alloc]
                                          initWithNibName:@"FanpageViewController" 
                                          bundle:nil];
                [nabi pushViewController:_fanpageViewController animated:YES];
            }
        }
    }
}
 

-(IBAction) back_btn_down:(id)sender;
{    
    //詳細はどこをを経由したか？YES
    //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
    
    int pass_ranking;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    pass_ranking = [[defaults stringForKey:@"PASS_RANKING"] intValue];
    //NSLog(@"deteails back%d",pass_ranking);
    
      if(pass_ranking==4)
     {
     _tagpageViewController = [[TagpageViewController alloc] 
     initWithNibName:@"TagpageViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_tagpageViewController 
     animated:YES];
     
     }
     else if(pass_ranking==3)
     {
     _searchViewController = [[SearchViewController alloc] 
     initWithNibName:@"SearchViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_searchViewController 
     animated:YES];
     }
     
     else if(pass_ranking==2)
     {
     _mypageViewController = [[MypageViewController alloc] 
     initWithNibName:@"MypageViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_mypageViewController 
     animated:YES];
     }
     else if(pass_ranking==1)
     {
     _rankingViewController = [[RankingViewController alloc] 
     initWithNibName:@"RankingViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_rankingViewController 
     animated:YES];
     }
    
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
    
    
    //NSLog(@"navigation %@",self.navigationController.viewControllers);
    //[self release];
}

 
@end



