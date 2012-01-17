//
//  InfoViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//
#import "InfoViewController.h"
#import "loadingAPI.h"
#import "dataButton.h"
#import "FanpageViewController.h"
#import "DetailsViewController.h"
#import "BadgViewController.h"
#import "CuratorViewController.h"

@implementation InfoViewController

@synthesize _webview;
-(void) viewDidLoad{
    
    NSLog(@"@%@",[self nibName]);
    [self badge_num];
    [self getActivity];
    
    
}

//ロード完了読み込み
- (void)viewDidAppear:(BOOL)animated
{
    //[self nextDataLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[self netAccessStart];
}




-(void) setUIWebView:(NSString *)htmltext
{
    
    
    _webview=[[UIWebView alloc]init];
    _webview.frame=self.view.bounds;
    _webview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webview.dataDetectorTypes=UIDataDetectorTypeAll;
    _webview.delegate=self;
    [scrollView addSubview:_webview];
    
    NSLog(@"html %@",htmltext);
    htmltext=[NSString stringWithFormat:@"<br>%@<br><br><br><br><br><br>",htmltext];
    
    [_webview loadHTMLString:htmltext baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* URLString = [[[request URL] standardizedURL] absoluteString];
    NSLog(@"shouldStartLoadWithRequest= %@", URLString );
    
    //ファンページ
    NSRange searchResult = [URLString rangeOfString:@"uid:"];
    if(searchResult.location!= NSNotFound)
    {
        NSString *idstr =[URLString substringWithRange:NSMakeRange(4,[URLString length]-4)];
        NSLog(@"uid %@", idstr );        
        
        int fid = [idstr intValue];
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
    
    
    //画像詳細ページ
    searchResult = [URLString rangeOfString:@"iid:"];
    if(searchResult.location!= NSNotFound)
    {
        NSString *idstr =[URLString substringWithRange:NSMakeRange(4,[URLString length]-4)];
        NSLog(@"iid %@", idstr );
        
        
        int num = [idstr intValue];
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
            return NO;
        }    
        NSLog(@"count %d",count);
        for (int i=0; i<count; i++) 
        {
            //restmpから１行ずつデータを取り出す
            NSArray *result = [[restmp2 objectForKey:@"result"] objectAtIndex:i];
            
            
            
            for (NSDictionary *dic in result) 
            {
                fid = [[dic objectForKey:@"uid"]integerValue];
            }
        }
        NSLog(@"fid %d",fid);
        
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
            return NO;
        }
        
        _detailsViewController = [[DetailsViewController alloc] 
                                  initWithNibName:@"DetailsViewController" 
                                  bundle:nil];
        
        _detailsViewController.re_value = idstr;
        [self.navigationController pushViewController:_detailsViewController animated:NO];
        
        return NO;
    }
    
    
    
    //キュレーターページ
    searchResult = [URLString rangeOfString:@"cu"];
    if(searchResult.location!= NSNotFound)
    {
        _curatorViewController = [[CuratorViewController alloc] 
                                  initWithNibName:@"CuratorViewController" 
                                  bundle:nil];
        [self.navigationController pushViewController:_curatorViewController 
                                             animated:YES];
    }
    
    
    //バッジページ
    searchResult = [URLString rangeOfString:@"bad"];
    if(searchResult.location!= NSNotFound)
    {
        _badgViewController = [[BadgViewController alloc] 
                               initWithNibName:@"BadgViewController" 
                               bundle:nil];
        _badgViewController.re_num = [[defaults stringForKey:@"MDAC_UID"] intValue];
        [self.navigationController pushViewController:_badgViewController 
                                             animated:YES];
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    //NSLog(@"webエラーtest");
} 




-(void) getActivity
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    
    //公式タグ一覧のデータを受信
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getActivity:0:99];//0:5ノーマルアクティビティ
    //NSDictionary *restmp=[loadingapi getNewActivity];//未読アクティビティ最終的に採用する
    
    
    
    NSString *htmltext=@"";
    
    NSLog(@"aaa %@",restmp);
    
    int tagNum = [[restmp objectForKey:@"result"] count];
    //NSString *tagString;
    /*  int nowWidth=0;
     
     int margin = 85;//配置時の高さマージン
     int textmargin = 65;//テキストのマージン
     int strScale=14;*/
    //リンクテキスト
    int TAGSCount=0;
    for (int i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            int linkMsgFlag1=-1;
            int linkMsgFlag2=-1;
            NSString *linkMsg1=@"";
            NSString *linkMsg2=@"";
            
            NSString *actMsg=@"";
            NSString *actMsg2=@"";
            
            NSString *activity_type=[dic objectForKey:@"activity_type"];
            NSString *activity_id=[dic objectForKey:@"activity_id"];
            
            
            if([activity_type isEqualToString:@"0000"])//お知らせ
            {
                actMsg=[NSString stringWithFormat:@"<font color='#cc0000'>【お知らせ】</font>%@",[dic objectForKey:@"param1"]];
            }
            //バッジお知らせ/////////////////////////////////////////////////////////
            else if ([activity_type isEqualToString:@"EV00"])
            {
                //_path=[dic objectForKey:@"param1"];
                actMsg=@"スタートアップ参加！／<a href='bad'>スタートアップバッジ</a>を入手！";
            }
            else if ([activity_type isEqualToString:@"EV01"])
            {
                actMsg=@"お誕生日おめでとう！／<a href='bad'>ハッピーバスデーバッジ</a>を入手！";
            }
            else if([activity_type isEqualToString:@"SN00"])
            {
                actMsg=@"初めてのSNS投稿！／<a href='bad'>SNS投稿デビューバッジ</a>を入手！";
                //_path=@"badge02_01.png";        
            }
            else if([activity_type isEqualToString:@"SN01"])
            {
                actMsg=@"SNS投稿×10回達成！／「<a href='bad'>Thanks share!ブロンズ</a>」バッジを入手！";
                //_path=@"badge02_02.png";        
            }
            else if([activity_type isEqualToString:@"SN02"])
            {
                actMsg=@"SNS投稿×50回達成！／「<a href='bad'>Thanks share!シルバー</a>」バッジを入手！";
                //_path=@"badge02_03.png";        
            }
            else if([activity_type isEqualToString:@"SN03"])
            {
                actMsg=@"SNS投稿×100回達成！／「<a href='bad'>Thanks share!ゴールド</a>」バッジを入手！";
                //_path=@"badge02_04.png";        
            }
            else if([activity_type isEqualToString:@"SN04"])
            {
                actMsg=@"SNS投稿×300回達成！／「<a href='bad'>Thanks share!ダイヤ</a>」バッジを入手！";
                //_path=@"badge02_05.png";        
            }
            //
            else if([activity_type isEqualToString:@"II00"])
            {
                actMsg=@"初めてのイイネ！／<a href='bad'>イイネデビューバッジ</a>を入手！";
                //_path=@"badge01_01.png";        
            }
            else if([activity_type isEqualToString:@"II01"])
            {
                actMsg=@"イイネ×5回達成！／「<a href='bad'>ドッグリスト</a>」バッジを入手！";
                //_path=@"badge01_02.png"; 
            }
            else if([activity_type isEqualToString:@"II02"])
            {
                actMsg=@"おめでとうございます！／<a href='bad'>隠れネコ派バッジ</a>を入手！";
                ////_path=@"badge01_03.png";
            }
            else if([activity_type isEqualToString:@"II03"])
            {
                actMsg=@"イイネ×10回達成！／「<a href='bad'>ブロンズドッグリスト</a>」バッジを入手！";
                //_path=@"badge01_04.png";
            }
            else if([activity_type isEqualToString:@"II04"])
            {
                actMsg=@"イイネ×50回達成！／「<a href='bad'>シルバードッグリスト</a>」バッジを入手！";
                // _path=@"badge01_05.png";
            }
            else if([activity_type isEqualToString:@"II05"])
            {
                actMsg=@"イイネ×100回達成！／「<a href='bad'>ゴールデンドッグリスト</a>」バッジを入手！";
                //_path=@"badge01_06.png";
            }
            else if([activity_type isEqualToString:@"II06"])
            {
                actMsg=@"イイネ×5回達成！／「<a href='bad'>キャットリスト</a>」バッジを入手！";
                // _path=@"badge01_07.png";
            }
            else if([activity_type isEqualToString:@"II07"])
            {
                actMsg= @"おめでとうございます！／<a href='bad'>隠れ犬派バッジ</a>を入手！";
                // _path=@"badge01_08.png";
            }
            else if([activity_type isEqualToString:@"II08"])
            {
                actMsg=@"イイネ×10回達成！／「<a href='bad'>ブロンズ・キャットリスト</a>」バッジを入手！";
                //_path=@"badge01_09.png";
            }
            else if([activity_type isEqualToString:@"II09"])
            {
                actMsg=@"イイネ×50回達成！／｢<a href='bad'>シルバー・キャットリスト</a>｣バッジを入手！";
                // _path=@"badge01_10.png";
            }
            else if([activity_type isEqualToString:@"II10"])
            {
                actMsg=@"イイネ×100回達成！／「<a href='bad'>ゴールド・キャットリスト</a>」バッジを入手！";
                //_path=@"badge01_11.png";
            }
            else if([activity_type isEqualToString:@"PO00"])
            {
                actMsg=@"おめでとうございます！あなたの投稿した写真に5人のｆａｎが「イイネ!」をつけましたので「<a href='bad'>よくできました</a>」バッジを入手!";
                // _path=@"badge04_01.png";
            }
            else if([activity_type isEqualToString:@"PO01"])
            {
                actMsg=@"おめでとうございます！あなたの投稿した写真に50人のｆａｎが「イイネ!」をつけましたので「<a href='bad'>よくできました</a>」バッジを入手!";
                //_path=@"badge04_02.png";
            }
            //キュレーターおしらせ//////////////////////////////////////////////
            else if([activity_type isEqualToString:@"CU00"])
            {
                //actMsg=@"<a href='cu'>キュレーター称号</a>を入手！";
                actMsg=@"おめでとうございます！　あなたも<a href='cu'>キュレーター</a>の仲間入り！さらに上位ランクのキュレーターを目指そう！";
            }
            else if([activity_type isEqualToString:@"CU01"])
            {
                actMsg=@"おめでとうございます！／キュレーター称号が「<a href='cu'>ブロンズ</a>」にランクアップ！";
            }
            else if([activity_type isEqualToString:@"CU02"])
            {
                //リンク先＝マイページ内キュレーター称号詳細
                //_path=[dic objectForKey:@"param1"];
                //actMsg=[NSString stringWithFormat:@"\nキュレーター称号が「シルバー」にランクアップ！  ？%@ %@",_path,[dic objectForKey:@"param2"]];
                actMsg=@"おめでとうございます！／キュレーター称号が「<a href='cu'>シルバー</a>」にランクアップ！";
            }
            else if([activity_type isEqualToString:@"CU03"])
            {
                actMsg=@"おめでとうございます！／キュレーター称号が「<a href='cu'>ゴールド</a>」にランクアップ！";
            }
            else if([activity_type isEqualToString:@"CU04"])
            {
                actMsg=@"おめでとうございます！／キュレーター称号が「<a href='cu'>プラチナ</a>」にランクアップ！";
            }
            //複雑なリンク//////////////////////////////////////
            else if([activity_type isEqualToString:@"CU10"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんがキュレーター称号を入手！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"CU11"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんがブロンズキュレーター称号を入手！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"CU12"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんがシルバーキュレーター称号を入手！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"CU13"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんがゴールドキュレーター称号を入手！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"CU14"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんがプラチナキュレーター称号を入手！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            //ユーザー更新情報/////////////////////////////////////
            else if([activity_type isEqualToString:@"TAGS"])
            {
                linkMsg1=[dic objectForKey:@"param2"];//画像タイトル
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//画像ID
                //linkMsgFlag2=[[dic objectForKey:@"param3"]integerValue];//相手ID
                actMsg=[NSString stringWithFormat:@"<a href='iid:%d'>%@</a>にタグがつけられました！",linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"POST"])
            {
                
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param4"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                
                linkMsgFlag1=[[dic objectForKey:@"param3"]integerValue];//ユーザーページID
                linkMsg2=[dic objectForKey:@"param2"];//タイトル
                linkMsgFlag2=[[dic objectForKey:@"param1"]integerValue];//投稿ページID
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:10px;'><a href='uid:%d'>%@</a>さんが新着画像<a href='iid:%d'>%@</a>を投稿しました！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1,linkMsgFlag2,linkMsg2];//32 32
            }
            else if([activity_type isEqualToString:@"FOLL"])
            {
                linkMsg1 = [NSMutableString stringWithString:[dic objectForKey:@"param2"]];//ユーザー名
                [linkMsg1 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg1 length])];//改行除去
                
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//ユーザーID
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんからフォローされました。<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag1,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"COMM"])
            {
                linkMsg1=[dic objectForKey:@"param2"];//画像タイトル
                linkMsgFlag1=[[dic objectForKey:@"param1"] integerValue];//画像ID
                linkMsgFlag2=[[dic objectForKey:@"param3"] integerValue];//ファンページ
                
                linkMsg2 = [NSMutableString stringWithString:[dic objectForKey:@"param4"]];//コメントユーザー名
                [linkMsg2 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg2 length])];//改行除去
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんが<a href='iid:%d'>%@</a>にコメントしました！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag2,linkMsgFlag2,linkMsg2,linkMsgFlag1,linkMsg1];
            }
            else if([activity_type isEqualToString:@"IINE"])
            {
                linkMsg1=[dic objectForKey:@"param2"];//画像タイトル
                linkMsgFlag1=[[dic objectForKey:@"param1"]integerValue];//画像ID
                linkMsgFlag2=[[dic objectForKey:@"param3"]integerValue];//相手ID
                linkMsg2 = [NSMutableString stringWithString:[dic objectForKey:@"param4"]];//コメントユーザー名
                [linkMsg2 replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [linkMsg2 length])];//改行除去
                
                
                actMsg=[NSString stringWithFormat:@"<img src='%@/user_t/%d.jpg' width='48' height='48' style='float:left; margin-right:0px;'><a href='uid:%d'>%@</a>さんが<a href='iid:%d'>%@</a>にイイネ！をつけました！<div style='margin-bottom:35px;'></div>",USER_SERVER_URL,linkMsgFlag2,linkMsgFlag2,linkMsg2,linkMsgFlag1,linkMsg1];
            }
            
            
            actMsg=[NSString stringWithFormat:@"<div style='width:300px; margin-bottom: 9px; font:13px serif; font-weight:500;'>%@</div><div style='width:300px; margin-bottom: 9px; border: thin lightgrey dashed;'></div>",actMsg];
            htmltext=[NSString stringWithFormat:@"<head><style type='text/css'><!-- a{ text-decoration:none;} --></style><head><body link='brown' alink='brown' vlink='brown'>%@%@</body>",htmltext,actMsg];
        }
    }
    
    [loadingapi release];
    
    //ウェブスタイルに流す
    [self setUIWebView:htmltext];
}






- (void)printButtonData:(dataButton*)button {
    NSLog(@"%@", button.data);
    //}
    
    //タグボタン
    //-(UIButton *)tagStringPressed:(UIButton *)button//:(int)test
    //{
    /*
     _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
     bundle:nil];
     
     NSString *tag_value = button.data;    
     
     _tagpageViewController.re_value = tag_value;
     [self.navigationController pushViewController:_tagpageViewController 
     animated:YES];
     _tagpageViewController.title_lbl.text = tag_value;
     */
}

//文字列取り出し
//            NSString *infoString =@"\n";
//            NSString *nextString =@"";
//            NSString *paramName=@"";
//            for(int j=1;j<11;j++){
//                paramName= [NSString stringWithFormat:@"param%d",j];
//                nextString=[NSString stringWithFormat:@"%@%@",nextString,[dic objectForKey:paramName]];
//                if(![nextString isEqualToString:@"<null>"])
//                infoString=[NSString stringWithFormat:@"%@%@",infoString,nextString];}

//画像情報が必要なタイプを精査
/*  if([activity_type isEqualToString:@"TAGS"])
 {
 //画像情報取得
 int imageID=[[dic objectForKey:@"param1"] integerValue];
 NSDictionary *restmp2=[loadingapi detailPostimage:imageID :NULL];
 for (int j=0; j<1; j++) 
 {
 NSArray *result2 = [[restmp2 objectForKey:@"result"] objectAtIndex:j];
 for (NSDictionary *dic2 in result2) 
 {
 //NSString *Conmment =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"comment"]];
 //NSString *Date =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"post_date"]];
 //NSString *post_image_name =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"post_image_name"]];
 _path =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"name"]];
 //NSString *access_count =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"access_count"]];
 //NSString *ref_album_count =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"ref_album_count"]];
 //NSString *ref_access_count =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"access_count"]];
 //NSString *category = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"category_id"]];
 //int uid =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"uid"]];
 }
 }
 }*/

//param2＝フォロワーユーザー名。uid＝ファンページ ユーザーID
//int uid=[[dic objectForKey:@"param1"] integerValue];
//NSDictionary *restmp2=[loadingapi getUserInfo:uid];
//for (int j=0; j<1; j++) {
//    NSArray *result2 = [[restmp2 objectForKey:@"result"] objectAtIndex:j];
//    for (NSDictionary *dic2 in result2) _name=[dic objectForKey:@"icon_path"];}


/*
 if(linkMsgFlag1>=0)
 {
 dataButton* tagButton1 = [[dataButton alloc] initWithTitle:@"" data:activity_type];
 
 tagButton1.frame = CGRectMake(22, -8+ margin * (i-TAGSCount), 282, 76);
 tagButton1.titleLabel.font=[UIFont boldSystemFontOfSize:strScale];
 [tagButton1 setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
 
 [tagButton1 addTarget:self action:@selector(printButtonData:) forControlEvents:UIControlEventTouchUpInside];
 [tagButton1 setTitle:linkMsg1 forState:UIControlStateNormal];
 
 [tagButton1 sizeToFit];
 [scrollView addSubview:tagButton1];
 }
 if(linkMsgFlag2>=0)
 {
 dataButton* tagButton2 = [[dataButton alloc] initWithTitle:@"" data:activity_type];
 
 tagButton2.frame = CGRectMake(22, -8+ margin * (i-TAGSCount), 282, 76);
 tagButton2.titleLabel.font=[UIFont boldSystemFontOfSize:strScale];
 [tagButton2 setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
 
 [tagButton2 addTarget:self action:@selector(printButtonData:) forControlEvents:UIControlEventTouchUpInside];
 [tagButton2 setTitle:linkMsg2 forState:UIControlStateNormal];
 
 [tagButton2 sizeToFit];
 [scrollView addSubview:tagButton2];
 }
 
 //背景
 UIImage *image = [UIImage imageNamed:@"info_back.png"];
 UIImageView *iv = [[UIImageView alloc] initWithImage:image];
 iv.frame = CGRectMake(9, 10 + margin * (i-TAGSCount), 302, 66);
 [scrollView addSubview:iv];
 
 //osirase（固定文言）
 UILabel *deletaLabel = [[UILabel alloc] init];
 deletaLabel.frame = CGRectMake(22, -8+ margin * (i-TAGSCount), 282, 76);
 deletaLabel.numberOfLines = 4;//最大4行に指定
 deletaLabel.backgroundColor = [UIColor clearColor];
 deletaLabel.textColor = [UIColor grayColor];
 deletaLabel.font = [UIFont boldSystemFontOfSize:strScale];
 deletaLabel.textAlignment = UITextAlignmentLeft;
 deletaLabel.text = actMsg;
 [scrollView addSubview:deletaLabel];
 
 [scrollView setContentSize:CGSizeMake(320,66+105*(i-TAGSCount))];
 */   

//リロードボタン
-(IBAction) reload_btn_down:(id)sender
{
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    
    [self badge_num];
    [self getActivity];
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
            
            break;
        case 1:upCategory=@"1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            break;  
        case 2 :upCategory=@"0%2c1"; 
            [defaults setObject:upCategory forKey:@"MDAC_CATEGORY"]; 
            
            break;   
        case 3:
        default:  upCategory=category; 
            break;    
    }
    
}

@end
