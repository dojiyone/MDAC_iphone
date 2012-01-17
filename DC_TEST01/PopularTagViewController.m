//
//  PopularTagViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "PopularTagViewController.h"
#import "TagpageViewController.h"
#import "loadingAPI.h"
#import "dataButton.h"

@implementation PopularTagViewController

-(void) viewDidLoad{
    
    NSLog(@"@%@",[self nibName]);
    bglabel.layer.masksToBounds = YES;  
    bglabel.layer.cornerRadius = 10;  
    [self badge_num];
    
    [self nextDataLoadPopular];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

//タグボタン
- (void)printButtonData:(dataButton*)button 
{
    
    
    _tagpageViewController = [[TagpageViewController alloc]initWithNibName:@"TagpageViewController" 
                                                                    bundle:nil];
    
    NSString *tag_value = button.data;
    
    
    NSLog(@"Value=%@",tag_value);
    _tagpageViewController.re_value = tag_value;
	[self.navigationController pushViewController:_tagpageViewController 
										 animated:YES];
    _tagpageViewController.title_lbl.text = tag_value;
    
}



-(void) nextDataLoadPopular
{
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    NSDictionary *restmp=[loadingapi getTagCloud];
    NSLog(@"aaa %@",restmp);
    
    int tagNum = [[restmp objectForKey:@"result"] count];
    
    
    
    int strScale=24;
    int nowWidth=0;
    int i=0;
    
    int strlenPx=0;
    int strlenPxMae=0;
    int strlen=0;
    NSString *tagString;
    NSString *tagStringMae;
    NSString *tagStringAmari;
    
    int nowY=116;
    int nowX=26;
    
    
    //tag_count >= 10 は2倍
    //tag_count >= 5 は1.5倍
    //tag_count >= 3 は1.2倍
    for (i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            bool amariflag=false;
            
            //各tagキーの文字列を取り出し配列に入れる
            tagString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]];
            strlen = [tagString length];
            int hanstrlen =[self strLength:tagString:strlen];
            NSLog(@"tex %@ strlen %d hanren %d",tagString,strlen,hanstrlen);
            
            //人気ごとにサイズ変更
            float tagCount= [[dic objectForKey:@"tag_count"] integerValue];            
            if(tagCount >=10) tagCount=2;
            else if(tagCount >=5)tagCount=1.5;
            else if(tagCount >=3)tagCount=1.2;
            else                tagCount=1;
            
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
                
                //何文字目で分割するか、文字数をカウントしていく
                int strlenCenter=strlenPxMae/strScale;
                strlenCenter=[self checkCenterStrCount:tagString:strlenCenter:strlenPxMae:strScale];
                
                if(strlenCenter<0)
                {
                    NSLog(@"lentest1");
                    strlenCenter=0;
                }
                else if(strlenCenter>strlen)
                {
                    NSLog(@"lentest2");
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
            
            /* if(nowY>346)
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
                [self.view addSubview:tagButton];
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
                [self.view addSubview:tagButton2];
                
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
        
        NSRange match = [oneStr rangeOfString:@"[\x20-\x7E\xA1-\xDF\｡-ﾟ]" options:NSRegularExpressionSearch];
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
    
    return strCount;
}


- (void)viewDidAppear:(BOOL)animated
{
}

@end
