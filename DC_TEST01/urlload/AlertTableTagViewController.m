//
//  AlertTableTagViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/26.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "AlertTableTagViewController.h"
#import "loadingAPI.h"
#import "TageditViewController.h"
#import "PostEditViewController.h"

@implementation AlertTableTagViewController
@synthesize select_text;

- (void)didReceiveMemoryWarning
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    tagTable.dataSource =self;
    tagTable.delegate =self;
    dataSource_ = [[NSMutableArray array]retain];
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    NSDictionary *restmp;
    //ロード改善実験失敗
    //if(restmp !=nil)return;
    restmp = [loadingapi getPublicTagList];
    
    NSLog(@"%@",[restmp objectForKey:@"result"]);
    //タグ用配列定義
    int tagNum=8;
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
                tagString[i] = [tagString[i] stringByAppendingString:@"／Cutie"];
            else if([tagString[i] isEqualToString:@"ブサカワ"])
                tagString[i] = [tagString[i] stringByAppendingString:@"／Ugly cute"];
            else if([tagString[i] isEqualToString:@"もふもふ"])
                tagString[i] = [tagString[i] stringByAppendingString:@"／Softly"];
            else if([tagString[i] isEqualToString:@"おもしろ"])
                tagString[i] = [tagString[i] stringByAppendingString:@"／Funny"];
            
            NSLog(@"tagString %@", tagString[i]);
            [dataSource_ addObject:tagString[i]];
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
            [dataSource_ addObject:tagString[i+6]];
        }
    }
    
    
}

- (void)viewDidUnload
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource_.count;
}


- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"basis-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        [cell autorelease];
    }
    
    cell.textLabel.text = [dataSource_ objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog( @"selected row: %d", indexPath.row );
    select_text = tagString[indexPath.row];
    NSLog( @"selected text: %@", select_text );
    //TageditViewController *tagedit = [[TageditViewController alloc]init];
    
    [ted setTextViewText:select_text];
    [ped setTextViewText:select_text];
    
    // tagedit.textView.text = select_text;
    NSLog(@"tagedit.textView %@",ted.textView.text);
}

@end
