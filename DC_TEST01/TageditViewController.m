//
//  TageditViewController.m
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/02.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "TageditViewController.h"
#import "AlertTableTagViewController.h"
#import "loadingAPI.h"

@implementation TageditViewController
@synthesize tableView,textView;
@synthesize re_value;
@synthesize uid;

- (void)dealloc 
{
    [dataSource_ release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    
    tableView.delegate =self;
    tableView.dataSource = self;
    dataSource_ = [[NSMutableArray alloc] initWithObjects:
                   @"タグの新規追加", nil ];
    
    
    int image_id = [re_value intValue];
    NSLog(@"image_id%d",image_id);
    loadingAPI *loadingapi = [[loadingAPI alloc]init];
    NSMutableArray *restmp = [loadingapi getTags:image_id];
    int tagNum = [[restmp objectForKey:@"result"] count]; 
    NSLog(@"%@",restmp);
    for (int i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            [dataSource_ addObject:[dic objectForKey:@"tag"]];
        }
    }
    
    //[super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [tableView setEditing:YES animated:YES];
}




-(void)viewWillAppear:(BOOL)animated
{
    
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

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {//Try to get rusable cell
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
 if (cell == nil){
 //If not possible create a new cell
 cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:@"CellIdentifier"]
 autorelease];
 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 }
 
 // Get the string to display and set the value in the cell
 if(indexPath.row == 0)
 {
 //The first (or zeroth cell) contains a New Item string and is used to add elements to list
 cell.text  = @"New Item...";
 }
 else
 {
 //Retreive text from datasource, the -1 accounts for the first element being hardcoded to say new Item
 cell.text = [dataSource_ objectInListAtIndex:indexPath.row-1];
 }
 return cell;
 }
 */

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 編集モードの場合の最後のRowだけ挿入モードにする
    if (indexPath.row ==0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


// セルの追加/削除要求
- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NSString *passNo=textView.text;//テキストフィールドからパス番号を取得する
    
    if ( UITableViewCellEditingStyleDelete == editingStyle ) {
        // データソースから実データを削除
        [dataSource_ removeObjectAtIndex:indexPath.row];
        // テーブルからセルを削除
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadData];
    } 
    else if ( UITableViewCellEditingStyleInsert == editingStyle ) 
    {
        if(dataSource_.count ==11)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"登録できるタグは10個までです"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];  
            return;
        }
        [self alertText];
        /*
         [dataSource_ addObject:textView.text];
         // テーブルにセルを追加
         [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
         withRowAnimation:UITableViewRowAnimationBottom];
         [tableView reloadData];
         */
    }
    
    
}

-(void)alertText{
    tagText = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"タグ情報の追加"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"キャンセル",nil];
    
    //オブジェクトを強制的に移動
    //CGAffineTransform trans = CGAffineTransformMakeTranslation(0.0, 100.0);
    //[alert setTransform:trans];
    
    textView =[[UITextField alloc] initWithFrame:CGRectMake(65.0, 40.0, 160.0, 30.0)];
    textView.borderStyle=UITextBorderStyleRoundedRect;
    textView.placeholder = @"";
    textView.text = @"";
    textView.textAlignment = UITextAlignmentLeft;
    textView.font = [UIFont fontWithName:@"Arial" size:20.0f];
    textView.backgroundColor = [UIColor whiteColor];
    //[textView becomeFirstResponder];
    
    AlertTableTagViewController *alertTable = [[AlertTableTagViewController alloc]init];
    alertTable.view.frame = CGRectMake(20, 80, 240, 90);
    NSLog(@"%@",alertTable.select_text);
    textView.text = alertTable.select_text;
    
    alertTable->ted=self;
    //フォーカスがはずれたときの処理
    //[textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [alert addSubview:textView];
    [alert show];
    
    [alert addSubview:alertTable.view];
    
    //NSLog(@"text->%@",textView.text);
    [alert release];
    [textView release];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    {
        CGRect frame = alertView.frame;
        frame.origin.y = 20;
        frame.size.height = 260;
        alertView.frame = frame;
        
        for (UIView* view in alertView.subviews){
            frame = view.frame;
            if (frame.origin.y > 44) {
                frame.origin.y += 120;
                view.frame = frame;
            }
        }
    }
}

-(void)setTextViewText:(NSString *)text
{
    tagText=text;
    
    
    NSString *addTag=text;
    if([addTag isEqualToString:@"かわいい／Cutie"])          addTag=@"かわいい";
    else if([addTag isEqualToString:@"ブサカワ／Ugly cute"]) addTag=@"ブサカワ";
    else if([addTag isEqualToString:@"もふもふ／Softly"])    addTag=@"もふもふ";
    else if([addTag isEqualToString:@"おもしろ／Funny"])     addTag=@"おもしろ";
    
    
    //クリップボードに文字列コピー
    UIPasteboard* board = [UIPasteboard generalPasteboard];
    [board setString:addTag];
    
    // UITextField上ペースト
    [textView becomeFirstResponder];
    textView.text=nil;
    [textView paste:board];
}


// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSLog(@"tagalert %d",buttonIndex);
    NSLog(@"txt %@",textView.text);
    switch (buttonIndex) 
    {
        case 0:
            if(textView.text==nil)
            {
                NSLog(@"text2->%@",tagText);
            }
            else
            {
                tagText = [[NSString alloc] initWithFormat:@"%@",textView.text];
                NSLog(@"text->%@",textView.text);        
            }    
            [self setTag:tagText];
            //１番目のボタンが押されたときの処理を記述する
            
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            
            break;
    }
    //  [textView removeFromSuperview]; //念のため
    //  [textView resignFirstResponder];
    
}

- (void) setTag:(NSString *)stringName;
{
    //NSLog(@"text->%@",stringName);
    
    NSString *addTag=stringName;
    if([addTag isEqualToString:@"かわいい／Cutie"])          addTag=@"かわいい";
    else if([addTag isEqualToString:@"ブサカワ／Ugly cute"]) addTag=@"ブサカワ";
    else if([addTag isEqualToString:@"もふもふ／Softly"])    addTag=@"もふもふ";
    else if([addTag isEqualToString:@"おもしろ／Funny"])     addTag=@"おもしろ";
    
    
    
    
    for (int i =0 ; i<dataSource_.count; i++)
    {
        
        
        if([[dataSource_ objectAtIndex:i] isEqualToString:addTag])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"タグが重複しています"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];  
            return;
        }
    }
    if([addTag length]>20)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"入力できる文字数は20文字までです"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];  
        return;
    }
    
    if([addTag isEqualToString:@""] || addTag ==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"タグを入力してください"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];  
        return;
    }
    
    [dataSource_ addObject:addTag];
    [tableView reloadData];
}


-(void)hoge2:(UIButton*)button{
    
}

-(IBAction)post_tag_btn:(id)sender
{
    
    loadingAPI *loadingapi = [[loadingAPI alloc]init];
    
    NSString *post_image_id=re_value;
    
    NSString *addTag=@"";
    NSString *tagStringAll=@"";
    for (int i =0 ; i<dataSource_.count; i++) {
        if([[dataSource_ objectAtIndex:i] isEqualToString:@"タグの新規追加"]
           ||[[dataSource_ objectAtIndex:i] isEqualToString:@""]
           ||[[dataSource_ objectAtIndex:i] isEqualToString:nil])
        {
        }
        else{
            addTag= [dataSource_ objectAtIndex:i];
            
            
            if([addTag isEqualToString:@"かわいい／Cutie"])          addTag=@"かわいい";
            else if([addTag isEqualToString:@"ブサカワ／Ugly cute"]) addTag=@"ブサカワ";
            else if([addTag isEqualToString:@"もふもふ／Softly"])    addTag=@"もふもふ";
            else if([addTag isEqualToString:@"おもしろ／Funny"])     addTag=@"おもしろ";
            
            tagStringAll = [NSString stringWithFormat:@"%@,%@",tagStringAll,addTag];//タグリストに投下
        }
        
    }
    
    NSString *encodeString=@"";
    if(![tagStringAll isEqualToString:@""])
    {
        int taglen=[tagStringAll length];
        tagStringAll = [tagStringAll substringWithRange:NSMakeRange(1,taglen-1)];//頭のカンマを除外
        
        NSLog(@"tagStringAll %@",tagStringAll);
        // 引数エンコード
        encodeString = [tagStringAll encodeString:NSUTF8StringEncoding];
        
    }
    
    //タグの設置
    [loadingapi saveTags:post_image_id:encodeString];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
