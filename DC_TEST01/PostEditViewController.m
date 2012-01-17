//
//  PostEditViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/11.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "PostEditViewController.h"
#import "loadingAPI.h"
#import "SecondViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "MixiTestViewController.h"
#import "AlertTableTagViewController.h"
#import "DetailsViewController.h"
#import "DetailsShareViewConroller.h"
#import "TopViewController.h"
#import "MypageViewController.h"

@implementation PostEditViewController

@synthesize _img;
@synthesize _imgOl;
@synthesize list;
//@synthesize Tw_post_flag,Fb_post_flag,Mx_post_flag;
//@synthesize inputText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        upCategory=@"";
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
    //  if(_img.image !=nil) _img.image=nil;
    // if(_imgOl.image !=nil) _imgOl.image=nil;
    

    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    /*    _mypageViewController = [[MypageViewController alloc] 
     initWithNibName:@"MypageViewController" 
     bundle:nil];
     
     [self.navigationController pushViewController:_mypageViewController
     animated:YES];
     */  
    //ナビゲーションを破棄してpostViewへ進む
    //[self.navigationController popViewControllerAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:NO];
    //[self release];
}

- (void)viewDidLoad
{
    
    //状態の定義　0写真なし 1写真あり加工なし2写真あり、加工あり
    //[super viewDidLoad];
    //NSLog(@"2 %@",_postViewController._imageView.image);
    //NSLog(@"2 %@",_postViewController._imageView);
    //NSLog(@"3 %@",_img.image);
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getPublicTagList];
    
    //タグ用配列定義
    int tagNum=6;
    int i=0;
    for (i=0; i<tagNum; i++) 
    {
        //restmpから１行ずつデータを取り出す
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        // NSLog(@"%@",[restmp objectForKey:@"result"]);
        for (NSDictionary *dic in result) 
        {
            //各tagキーの文字列を取り出し配列に入れる
            tagString[i] = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]];
            //NSLog(@"tagString %@", tagString[i]);
            
        }
    }
    
    
    
    [MainScrollView setContentSize:CGSizeMake(320,2186)];
    
    TagtableView.delegate =self;
    TagtableView.dataSource = self;
    SwitchTable.tag = 1;
    SwitchTable.delegate = self;
    SwitchTable.dataSource =self;
    
    names=[NSArray arrayWithObjects:@"タグの新規追加",nil];
    dataSource_ = [[NSMutableArray alloc] initWithObjects:
                   @"タグの新規追加",
                   nil ];
    
    dataSource2_ = [[NSMutableArray alloc] initWithObjects:
                    @"Twitter",@"Facebook",@"Mixi",
                    nil ];
    
    
    //TagtableView.frame = CGRectMake(17, 488, 283, 296);
    
    //SNSの有無を確認
    Tw_post_flag=0;
    Fb_post_flag=0;
    Mx_post_flag=0; 
    
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    
    if([svc getSnsLoginStatus:1]==1)Tw_post_flag =1;
    if([svc getSnsLoginStatus:2]==1)Fb_post_flag =1;
    if([svc getSnsLoginStatus:3]==1)Mx_post_flag =1;
    
    if(Tw_post_flag ==0)
    {
        post_Tw.image = [UIImage imageNamed:@"tabicon_next_0.png"];
    }
    else
    {
        post_Tw.image = [UIImage imageNamed:@"tabicon_next_1.png"];
    }
    
    if(Fb_post_flag ==0)
    {
        post_Fb.image = [UIImage imageNamed:@"tabicon_next_0.png"];
    }
    else
    {
        post_Fb.image = [UIImage imageNamed:@"tabicon_next_1.png"];
    }
    
    if(Mx_post_flag ==0)
    {
        post_Mx.image = [UIImage imageNamed:@"tabicon_next_0.png"];
    }
    else
    {
        post_Mx.image = [UIImage imageNamed:@"tabicon_next_1.png"];
    }
    
}


//スイッチ生成
- (UISwitch*)pswitchForCell:(const UITableViewCell*)cell 
{
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    bool twlogin =[svc getSnsLoginStatus:1];
    
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    
    //ログイン済みの場合スイッチオン状態
    if(twlogin == YES)
    {
        theSwitch.on = YES;
    }
    else
    {
        theSwitch.on = NO;
    }
    [theSwitch addTarget:self action:@selector(ppushSwitch1:)
        forControlEvents:UIControlEventValueChanged];
    
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}

- (UISwitch*)pswitchForCell2:(const UITableViewCell*)cell 
{
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    bool fblogin =[svc getSnsLoginStatus:2];
    
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    if(fblogin == YES)
    {
        theSwitch.on = YES;
    }
    else
    {
        theSwitch.on = NO;
    }
    [theSwitch addTarget:self action:@selector(ppushSwitch2:)
        forControlEvents:UIControlEventValueChanged];
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}

- (UISwitch*)pswitchForCell3:(const UITableViewCell*)cell 
{
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    bool milogin =[svc getSnsLoginStatus:3];
    
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    if(milogin == YES)
    {
        theSwitch.on = YES;
    }
    else
    {
        theSwitch.on = NO;
    }
    [theSwitch addTarget:self action:@selector(ppushSwitch3:)
        forControlEvents:UIControlEventValueChanged];
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}


-(void)ppushSwitch1:(UISwitch*)theswitch
{
    
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    if(theswitch.on==NO)    
    {
        Tw_post_flag =0;
        return;
    }
    
    if(theswitch.on==YES && [svc getSnsLoginStatus:1]==1)
    {
        Tw_post_flag =1;//オフからオンへ
        return;
    }
    else
    {
        theswitch.on=NO;
    }
}

-(void)ppushSwitch2:(UISwitch*)theswitch
{
    NSLog(@"fb on");
    
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    if(theswitch.on==NO)    
    {
        Fb_post_flag =0;
        return;
    }
    
    if(theswitch.on==YES && [svc getSnsLoginStatus:2]==1)
    {
        Fb_post_flag =1;//オフからオンへ
        return;
    }
    else
    {
        theswitch.on=NO;
    }
}

-(void)ppushSwitch3:(UISwitch*)theswitch
{
    
    SecondViewController *svc = [[SecondViewController alloc]init]; 
    if(theswitch.on==NO)    
    {
        //NSLog(@"mipos off");
        Mx_post_flag =0;
        return;
    }
    
    if(theswitch.on==YES && [svc getSnsLoginStatus:3]==1)
    {
        Mx_post_flag =1;//オフからオンへ
        //NSLog(@"mipos on %d",Mx_post_flag);
        return;
    }
    else
    {
        theswitch.on=NO;
    }
}

/*
 if(button.tag==1)
 {
 [button setBackgroundImage:img_mixi_off forState:UIControlStateNormal];
 button.tag=0;
 miflag=0;
 }
 
 if(button.tag==0 && miAccessToken!=nil)
 {
 [button setBackgroundImage:img_mixi_on forState:UIControlStateNormal];
 button.tag=1;
 miflag=1;
 }
 */





//未使用
/* - (void)post_Tw:(int)switchType
 {
 
 SecondViewController *svc = [[SecondViewController alloc]init]; 
 if(Tw_post_flag ==0 && [svc getSnsLoginStatus:1]==1)
 {
 post_Tw.image = [UIImage imageNamed:@"tabicon_next_1.png"];
 return;
 }
 
 if(Tw_post_flag ==1)
 {
 Tw_post_flag =0;
 post_Tw.image = [UIImage imageNamed:@"tabicon_next_0.png"];
 return;
 }
 
 NSLog(@"Tw_post_flag %d",Tw_post_flag);
 }
 - (void)post_Fb:(int)switchType
 {     
 NSLog(@"fb");
 SecondViewController *svc = [[SecondViewController alloc]init]; 
 if(Fb_post_flag ==0 && [svc getSnsLoginStatus:2]==1)
 {
 Fb_post_flag =1;
 post_Fb.image = [UIImage imageNamed:@"tabicon_next_1.png"];
 }
 
 if(Fb_post_flag ==1)
 {
 Fb_post_flag =0;
 post_Fb.image = [UIImage imageNamed:@"tabicon_next_0.png"];
 }
 
 
 }
 - (void)post_Mx:(int)switchType
 {
 
 NSLog(@"mi %d",switchType);
 
 SecondViewController *svc = [[SecondViewController alloc]init]; 
 if(Mx_post_flag ==0 && [svc getSnsLoginStatus:3]==1)
 {
 Mx_post_flag =1;
 post_Mx.image = [UIImage imageNamed:@"tabicon_next_1.png"];
 }
 
 if(Mx_post_flag ==1)
 {
 Mx_post_flag =0;
 post_Mx.image = [UIImage imageNamed:@"tabicon_next_0.png"];
 }
 }*/








- (void)viewDidUnload
{
    //[super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//投稿処理
- (IBAction)post
{   
    int category=[upCategory intValue];
    int tagCount=0;
    
    // タイトル未入力はエラー。
    if([inputText.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"タイトルが未入力です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    if([inputText.text length] >50){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"タイトル文字数は50文字までです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //コメント未入力はエラー
    if([inputComment.text isEqualToString:@""]){
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
    
    if([inputComment.text length] > 1000){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"本文は1000文字までですです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //カテゴリ未選択はエラー。
    if([upCategory isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"カテゴリが未入力です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    if(tagCount > 10){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"付けられるタグは10個までです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    //NSLog(@"post %@ %@",inputText.text ,inputComment.text);
    //return;
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    
    //画像の保存
    if(_imgOl.image==nil) 
    {
        NSLog(@"画像が無い");
        return;
    }
    NSDictionary *restmp=[loadingapi saveImage:_imgOl.image];
    
    int imageID=0;
    //int size=0;
    
    NSDictionary *entry = [restmp objectForKey:@"result"];
    imageID = [[entry objectForKey:@"image_id"] integerValue];
    
    
    if(imageID==0)
    {
        NSLog(@"UP失敗");
        return;
    }
    
    //その他コメント情報などの投稿
    restmp=[loadingapi savePostimage:imageID  :category :inputText.text :inputComment.text];
    
    int resId = [[restmp objectForKey:@"result"] integerValue];
    NSLog(@"savepostimage %@",restmp);
    if(resId>0)
    {
        NSLog(@"UP成功！");
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"エラー"
                              message:@"投稿に失敗しました"
                              delegate:self
                              cancelButtonTitle:@"とじる"
                              otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        return;
    }
    
    
    NSString *post_image_id=[ NSString stringWithFormat : @"%d", resId];
    // NSLog(@"[dataSource_ objectAtIndex:0] %@",[dataSource_ objectAtIndex:0]);
    
    
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
    
    if(![tagStringAll isEqualToString:@""])
    {
        int taglen=[tagStringAll length];
        tagStringAll = [tagStringAll substringWithRange:NSMakeRange(1,taglen-1)];//頭のカンマを除外
        
        //NSLog(@"tagStringAll %@",tagStringAll);
        // 引数エンコード
        NSString *encodeString = [tagStringAll encodeString:NSUTF8StringEncoding];
        
        //タグの設置
        restmp=[loadingapi saveTags:post_image_id:encodeString];
    }
    //[loadingapi saveTags:resId :dataSource_];
    NSString *idstring =[NSString stringWithFormat:@"%d",resId];
    NSDictionary *dic= [NSDictionary dictionaryWithObject:idstring forKey:@"imageID"];
    
    DetailsShareViewConroller *dts = [[DetailsShareViewConroller alloc]init];
    [dts inputShare:inputComment.text:post_image_id:Tw_post_flag:Fb_post_flag:Mx_post_flag];
    [dts release];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int pass_ranking=-1;
    [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
    
    // 通知を作成する
    NSNotification *n = [NSNotification notificationWithName:@"Tuchi" object:self userInfo:dic];
    
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
}




- (IBAction)inputTitleField
{
    NSLog(@"inputText%@",inputText.text);
    NSLog(@"inputComment%@",inputComment.text);
}


- (IBAction)inputCommentField
{
    
}

- (void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    //[self.tableView setEditing:YES animated:YES];
    [TagtableView setEditing:YES animated:YES];
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList
{
    if (list != newList)
    {
        [list release];
        list = [newList mutableCopy];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 1){
        return dataSource2_.count;
    }
    else{
        return dataSource_.count;
    }
}


- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"basis-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(tableView.tag == 1){
        if(indexPath.section == 0){
            switch(indexPath.row){
                case 0:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self pswitchForCell:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
                case 1:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self pswitchForCell2:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
                case 2:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self pswitchForCell3:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
            }
        }
        
        cell.textLabel.text = [dataSource2_ objectAtIndex:indexPath.row];
        return cell;
    }
    
    
    
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        [cell autorelease];
    }
    cell.textLabel.text = [dataSource_ objectAtIndex:indexPath.row];
    return cell;
    
}



- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(tableView.tag ==0){
        // 編集モードの場合の最後のRowだけ挿入モードにする
        if (indexPath.row ==0) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    }
    else{
        return UITableViewCellEditingStyleInsert;
        
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
        [self alertText];
        
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
    // NSLog(@"%@",alertTable.select_text);
    textView.text = alertTable.select_text;
    
    alertTable->ped=self;
    //フォーカスがはずれたときの処理
    //[textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [alert addSubview:textView];
    [alert show];
    
    [alert addSubview:alertTable.view];
    
    //NSLog(@"text->%@",textView.text);
    [alert release];
    [textView release];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    {
        CGRect frame = alertView.frame;
        frame.origin.y = 5;
        frame.size.height = 260;
        alertView.frame = frame;
        
        for (UIView* view in alertView.subviews){
            frame = view.frame;
            if (frame.origin.y > 44) {
                frame.origin.y += 115;
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
    // NSLog(@"tagalert %d",buttonIndex);
    // NSLog(@"txt %@",textView.text);
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
    
    [dataSource_ addObject:addTag];
    [TagtableView reloadData];
    
    TagtableView.frame = CGRectMake(17, 488, 283, (59+dataSource_.count*40));
    SwitchTable.frame = CGRectMake(17, 571+(dataSource_.count * 40), 283, 273);
    [MainScrollView setContentSize:CGSizeMake(320,2186+(dataSource_.count * 45))];
    //NSLog(@"dataSource_.count@%d",dataSource_.count);
}


-(void)hoge2:(UIButton*)button{
}


- (IBAction)buttonDownCategorySelect:(id)sender//:(UIButton*)button
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"dogs",
                                  @"cats",
                                  nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:sender];
    [actionSheet release];    
}
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //番号別変更
    //NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:upCategory=@"0"; 
            [ct_button setTitle:@"dogs" forState:UIControlStateNormal];
            break;
        case 1:upCategory=@"1"; 
            [ct_button setTitle:@"cats" forState:UIControlStateNormal];
            break;    
        default:  break;
    }
    
    
}



@end

