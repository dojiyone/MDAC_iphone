//
//  AlubumIconViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "AlubumIconViewController.h"
#import "loadingAPI.h"
#import "UIAsyncImageView.h"

@implementation AlubumIconViewController

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
    [self showAlbumList];
}


-(void)showAlbumList
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getAlbumList:Uid];
    //NSLog(@"aaa %@",restmp);
    int cnt = [[restmp objectForKey:@"result"] count];
    
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    
    int margin = 89;//配置時の高さマージン
    //int linebreakMargin = 30;//アルバム名改行発生時の改行高さ
    int scrollViewHight = 0;//スクロールビューの高さ容れ物
    //NSString *userName = @"";//ユーザー名容れ物
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog("res%@",result);
        for (NSDictionary *dic in result) 
        {
            
            UIImage *image=[loadingapi changeImageStyle:[dic objectForKey:@"real_path"] :100:100 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            if(image == nil) image =[UIImage imageNamed:@"common_dummy.png"];
            
            
            
            //アルバムアイコン（ボタン）
            UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconButton setTitle:@"" forState:UIControlStateNormal];
            [iconButton setBackgroundImage:image forState:UIControlStateNormal];
            //[iconButton sizeToFit];
            iconButton.frame = CGRectMake(6, 6 + scrollViewHight, 77, 77);//画像サイズがいかなる場合でも77×77にする
            iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
            //iconButton.center = CGPointMake(6, 51);
            //iconButton.contentMode = UIViewContentModeScaleToFill;
            [scrollView addSubview:iconButton];
            
            //アルバム名1行目
            UILabel *userNameLabel = [[UILabel alloc] init];
            userNameLabel.text = [dic objectForKey:@"album_name"];
            int strLen=[userNameLabel.text length];
            NSLog(@"strlen %d",strLen);
            int gyouCount=1;//最大行数
            int addMargin = 0;//２行目以降の追加マージン
            int addMargin2 = -20;
            if(strLen<8)
            {
            }
            else if(strLen<14)
            {
                addMargin =30;
                addMargin2 =-20;
            }
            else if(strLen<30)
            {
                gyouCount = 2;
                addMargin =40;
                addMargin2 =-10;
            }
            else if(strLen<45)
            {
                gyouCount = 3;
                addMargin =60;
                addMargin2 =0;
            }
            else
            {
                gyouCount = 4;
                addMargin =80;
                addMargin2 =5;
            }
            
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.frame = CGRectMake(96,scrollViewHight+addMargin2, 220, 80);//-20 +
            userNameLabel.numberOfLines = gyouCount;
            userNameLabel.textColor = [UIColor grayColor];
            userNameLabel.font = [UIFont boldSystemFontOfSize:14];
            //userNameLabel.minimumFontSize = 5;
            //userNameLabel.adjustsFontSizeToFitWidth = YES;
            userNameLabel.textAlignment = UITextAlignmentLeft;
            
            //userNameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            //userNameLabel.numberOfLines = 5;
            userNameLabel.tag = i;
            userNameLabel.backgroundColor = [UIColor clearColor];
            //効かない　userNameLabel.contentMode = UIViewContentModeTop;
            //1行止まり [userNameLabel sizeToFit];
            //ユーザー名改行判定(名前が長すぎた時、"…"を出さないための処理)
            [scrollView addSubview:userNameLabel];
            
            
            /*
             if([[dic objectForKey:@"album_name"] length] > lineBreakCounts ){
             userNameLabel.text = [[dic objectForKey:@"album_name"] substringToIndex:lineBreakCounts];
             }else{
             }
             */
            /*
             //アルバム名文字数が改行文字数を超えた場合、２行目以降の名前を表示
             if([[dic objectForKey:@"album_name"] length] > lineBreakCounts ){
             for (int j=0; j<([[dic objectForKey:@"album_name"] length] / lineBreakCounts); j++) 
             {
             NSlog(@"%d",j);
             scrollViewHight += linebreakMargin;
             //アルバム名2行目以降
             UILabel *userNameLabel = [[UILabel alloc] init];
             userNameLabel.backgroundColor = [UIColor clearColor];
             userNameLabel.frame = CGRectMake(96, 16 + scrollViewHight, 220, 20);
             userNameLabel.textColor = [UIColor grayColor];
             userNameLabel.font = [UIFont boldSystemFontOfSize:14];
             userNameLabel.textAlignment = UITextAlignmentLeft;
             userNameLabel.tag = i;
             //改行条件でぴったり割り切れているか判定(名前が長すぎた時、"…"を出さないための処理)
             
             if([[dic objectForKey:@"album_name"] length] > lineBreakCounts ){
             userNameLabel.text = [[dic objectForKey:@"album_name"] substringWithRange:NSMakeRange(lineBreakCounts* (j + 1),lineBreakCounts)];
             
             }else{
             userNameLabel.text = [dic objectForKey:@"album_name"];
             }
             
             userNameLabel.text = [[dic objectForKey:@"album_name"]  substringFromIndex:lineBreakCounts];
             
             [scrollView addSubview:userNameLabel];
             }
             }
             
             */
            //画像変更ボタン（リムーブボタン）（フォローリストのみ表示）
            UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deletaButton setTitle:@"" forState:UIControlStateNormal];
            [deletaButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
            deletaButton.frame = CGRectMake(91, 51 + scrollViewHight+addMargin, 0, 0);
            [deletaButton sizeToFit];
            //位置調整など
            deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            deletaButton.tag = [[dic objectForKey:@"album_id"]integerValue];//= i;
            [deletaButton addTarget:self action:@selector(image_change_btn:) forControlEvents:UIControlEventTouchUpInside];
            //deletaButton.center = CGPointMake(6, 51);
            //deletaButton.contentMode = UIViewContentModeScaleToFill;
            [scrollView addSubview:deletaButton];
            
            
            //画像変更（固定文言）
            UILabel *deletaLabel = [[UILabel alloc] init];
            deletaLabel.frame = CGRectMake(100, 56 + scrollViewHight+addMargin, 200, 20);
            deletaLabel.backgroundColor = [UIColor clearColor];
            deletaLabel.textColor = [UIColor lightGrayColor];
            deletaLabel.font = [UIFont boldSystemFontOfSize:12];
            deletaLabel.textAlignment = UITextAlignmentLeft;
            deletaLabel.text = @"画像変更";
            [scrollView addSubview:deletaLabel];
            
            
            
            
            if(i >=1){
                //名前変更ボタン（リムーブボタン）（フォローリストのみ表示）
                UIButton *deletaButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [deletaButton2 setTitle:@"" forState:UIControlStateNormal];
                [deletaButton2 setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
                deletaButton2.frame = CGRectMake(211, 51 + scrollViewHight+addMargin, 0, 0);
                [deletaButton2 sizeToFit];
                //位置調整など
                deletaButton2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                deletaButton2.tag = [[dic objectForKey:@"album_id"]integerValue];
                [deletaButton2 addTarget:self action:@selector(name_change_btn:) forControlEvents:UIControlEventTouchUpInside];
                //deletaButton.center = CGPointMake(6, 51);
                //deletaButton.contentMode = UIViewContentModeScaleToFill;
                [scrollView addSubview:deletaButton2];
                
                //名前変更（固定文言）
                UILabel *deletaLabel2 = [[UILabel alloc] init];
                deletaLabel2.frame = CGRectMake(220, 56 + scrollViewHight+addMargin, 200, 20);
                deletaLabel2.backgroundColor = [UIColor clearColor];
                deletaLabel2.textColor = [UIColor lightGrayColor];
                deletaLabel2.font = [UIFont boldSystemFontOfSize:12];
                deletaLabel2.textAlignment = UITextAlignmentLeft;
                deletaLabel2.text = @"名前変更";
                [scrollView addSubview:deletaLabel2];
                
                //削除ボタン本物（リムーブボタン）（フォローリストのみ表示）
                UIButton *deletaButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [deletaButton3 setTitle:@"" forState:UIControlStateNormal];
                [deletaButton3 setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
                deletaButton3.frame = CGRectMake(211, 11 + scrollViewHight+addMargin, 0, 0);
                [deletaButton3 sizeToFit];
                //位置調整など
                deletaButton3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                deletaButton3.tag = [[dic objectForKey:@"album_id"]integerValue];
                [deletaButton3 addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
                //deletaButton.center = CGPointMake(6, 51);
                //deletaButton.contentMode = UIViewContentModeScaleToFill;
                [scrollView addSubview:deletaButton3];
                
                
                //削除本物（固定文言）
                UILabel *deletaLabel3 = [[UILabel alloc] init];
                deletaLabel3.frame = CGRectMake(220, 16 + scrollViewHight+addMargin, 200, 20);
                deletaLabel3.backgroundColor = [UIColor clearColor];
                deletaLabel3.textColor = [UIColor lightGrayColor];
                deletaLabel3.font = [UIFont boldSystemFontOfSize:12];
                deletaLabel3.textAlignment = UITextAlignmentLeft;
                deletaLabel3.text = @"削除";
                [scrollView addSubview:deletaLabel3];
                
            }
            
            //横線
            UIView *uv = [[UIView alloc] init];
            uv.frame = CGRectMake(0, 88 + scrollViewHight+addMargin, 320, 1);
            uv.backgroundColor = [UIColor lightGrayColor];
            [scrollView addSubview:uv];
            
            //スクロールビューサイズ
            scrollViewHight = scrollViewHight + margin+addMargin;
            
        }
        scrollView.contentSize = CGSizeMake(320,133 + scrollViewHight);
        //元は133＋i×項数でうまくいっていた。
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)deleteAlbum:(UIButton *)sender
{
    NSLog(@"button %d",sender.tag);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"確認"
                          message:@"アルバムを削除しますか？＊この操作は元に戻すことができません、アルバムに入れた写真もすべて削除されます"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:@"キャンセル", nil];
    alert.tag=sender.tag;
    [alert show];
    [alert release];
}

-(IBAction)add_album_btn:(UIButton *)sender{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getAlbumList:Uid];
    NSLog(@"aaa %@",restmp);
    
    int cnt = [[restmp objectForKey:@"result"] count];
    NSString *album_name[4];
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            album_name[i] = [dic objectForKey:@"album_name"];
        }
    }
    if(cnt>3){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"作成できるアルバムは４個までです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    //アルバムの追加
    NSLog(@"button %d",sender.tag);
    
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アルバムの追加"
                                                    message:@"\n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"決定"
                                          otherButtonTitles:@"やめる",nil];
    
    textView =[[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 55.0)];
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
    
    //[textView becomeFirstResponder];
    [textView release];
}



-(IBAction)image_change_btn:(UIButton *)sender
{
    NSLog(@"button %d",sender.tag);
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アルバムアイコン画像を選択"
                                                    message:@" \n\n\n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"選択"
                                          otherButtonTitles:@"やめる",nil];
    alert.tag=sender.tag;
    
    //該当アルバムから画像リストを取得
    NSDictionary *restmp = [loadingapi getAlbumimageList:sender.tag :0 :30];
    NSLog(@"aaa %@",restmp);
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt == 0)
    {    
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"アルバムに画像が有りません"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            NSString *post_image_id  = [dic objectForKey:@"post_image_id"];
            UIImage *image=[loadingapi changeImageStyle:[dic objectForKey:@"real_path"] :100:100 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            //if(image == nil) image =[UIImage imageNamed:@"common_dummy.png"];
            
            iconImg[i]=image;
            img_id[i]=[post_image_id integerValue];
            
        }
    }
    
    
    count = cnt;
    tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(20, 40, 242, 110);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.rowHeight = 100;
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
    [alert addSubview:tableView];
    //[alert addSubview:textView];
    [alert show];
    [alert release];
    [loadingapi release];
}

#pragma mark - UITableViewDataSource

/**
 * テーブルのセクション数を取得します。
 *
 * @param tableView テーブル。
 *
 * @return セクション数。
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/**
 * セクションにおける行数を取得します。
 *
 * @param tableView テーブル。
 * @param section   セクション。
 *
 * @return 行数。
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

/**
 * セルを取得します。
 *
 * @param tableView テーブル。
 * @param indexPath 位置。
 *
 * @return セル。
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"Cell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if( cell == nil )
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
    //LoadingAPIで分岐
    for (int i =0; i<count; i++) 
    {
        if(indexPath.row == i)
        {
            cell.imageView.image = iconImg[i];
        }
    }
    
	return cell;
}

-(void)modalButtonDidPush
{
    
}



#pragma mark - UITableViewDelegate

/**
 * セルが選択された時に発生します。
 *
 * @param tableView テーブル。
 * @param indexPath 位置。
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog( @"selected row: %d", img_id[indexPath.row] );
    select_id = img_id[indexPath.row];
    
}


//タグボタン
-(IBAction)name_change_btn:(UIButton *)sender
{
    NSLog(@"button %d",sender.tag);
    
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
    
    
    int nameCount=0;
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getAlbumList:Uid];
    int cnt = [[restmp objectForKey:@"result"] count];
    NSString *album_name[8];
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            album_name[i] = [dic objectForKey:@"album_name"];
            if([[dic objectForKey:@"album_id"]integerValue]==sender.tag)
                nameCount=i;
        }
    }
    
    //アルバムの追加
    NSLog(@"button %d",sender.tag);
    //NSLog(@"button %@",album_name[sender.tag]);
    
    NSInteger intager_c;
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"名前変更"
                                                    message:@" \n\n\n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"変更"
                                          otherButtonTitles:@"やめる",nil];
    alert.tag=sender.tag;
    textView =[[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 95.0)];
    textView.borderStyle=UITextBorderStyleRoundedRect;
    
    
    
    textView.text = album_name[nameCount];
    textView.textAlignment = UITextAlignmentLeft;
    textView.font = [UIFont fontWithName:@"Arial" size:20.0f];
    textView.backgroundColor = [UIColor whiteColor];
    
    
    //フォーカスがはずれたときの処理
    [textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [alert addSubview:textView];
    [alert show];
    [alert release];
    
    //[textView becomeFirstResponder];
    [textView release];
    
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    if([alertView.title isEqualToString:@"アルバムの追加"])
    {
        switch (buttonIndex)
        {
            case 1:
                NSLog(@"iie");
                
                break;
            case 0:
                NSLog(@"hai %d",alertView.tag);
                if([textView.text length] >50)
                {    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"アルバムの文字数は50文字までです"
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    [alert release];
                    return;
                    
                }
                
                if([textView.text length] ==0)
                {    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"アルバム名を入力してください"
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    [alert release];
                    return;
                    
                }
                
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"アルバムの追加"
                                           message:@"アルバムを追加しました"
                                          delegate:nil 
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
                
                loadingAPI* loadingapi=[[loadingAPI alloc] init];
                [loadingapi createAlbum:textView.text];
                NSLog(@"アルバムを追加");
                [self reload_view];
                [alert show];
                [alert release];
                break;
        }
    }
    else if([alertView.title isEqualToString:@"確認"])
    {
        switch (buttonIndex)
        {
            case 1:
                NSLog(@"iie");
                
                break;
            case 0:
                NSLog(@"hai %d",alertView.tag);
                
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"削除完了"
                                           message:@"アルバムを削除しました"
                                          delegate:nil 
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
                
                loadingAPI* loadingapi=[[loadingAPI alloc] init];
                NSLog(@"削除");
                [loadingapi deleteAlbum:alertView.tag];
                [self reload_view];
                [alert show];
                [alert release];
                break;
        }
    }
    else if([alertView.title isEqualToString:@"名前変更"])
    {
        switch (buttonIndex)
        {
            case 1:
                NSLog(@"iie");
                break;
            case 0:
                NSLog(@"hai %@",textView.text);
                
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"変更完了"
                                           message:@"アルバム名を変更しました"
                                          delegate:nil 
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
                NSLog(@"名前の変更");
                
                if([textView.text length] >50)
                {    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"アルバムの文字数は50文字までです"
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    [alert release];
                    return;
                    
                }
                
                if([textView.text length] ==0)
                {    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"アルバム名を入力してください"
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    [alert release];
                    return;
                    
                }
                
                [loadingapi saveAlbumName:alertView.tag :textView.text];
                [self reload_view];
                [alert show];
                [alert release];
                break;
        }
        
    }
    else
    {        
        int imageID = select_id;
        select_id=0;//取得したら捨てる
        switch (buttonIndex)
        {
            case 1:
                NSLog(@"iie");               
                break;
            case 0:
                // NSLog(@"hai %d",alertView.tag);
                
                if(imageID==0)
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"画像を選択して下さい"
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    [alert release];
                }
                else
                {
                    loadingAPI* loadingapi=[[loadingAPI alloc] init];                    
                    [loadingapi saveAlbumIcon:alertView.tag :imageID];
                }
                [self reload_view];
                break;
        }
    }
}


-(void)reload_view
{
    UIView *uv = [[UIView alloc] init];
    uv.frame = CGRectMake(0, 0, 320, 2000);//self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    
    [self showAlbumList];
    /*
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
     
     //APIの呼び出し
     loadingAPI* loadingapi=[[loadingAPI alloc] init];
     NSDictionary *restmp=[loadingapi getAlbumList:Uid];
     NSLog(@"aaa %@",restmp);
     int cnt = [[restmp objectForKey:@"result"] count];
     
     UIViewController *viewController1;
     viewController1 = [[UIViewController alloc] init];
     
     int margin = 89;//配置時の高さマージン
     
     for (int i=0; i<cnt; i++) 
     {
     NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
     //NSLog("res%@",result);
     for (NSDictionary *dic in result) 
     {
     
     UIImage *image=[loadingapi changeImageStyle:[dic objectForKey:@"real_path"] :100:100 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
     if(image == nil) image =[UIImage imageNamed:@"common_dummy.png"];
     
     
     
     //ユーザーアイコン（ボタン）
     UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [iconButton setTitle:@"" forState:UIControlStateNormal];
     [iconButton setBackgroundImage:image forState:UIControlStateNormal];
     //[iconButton sizeToFit];
     iconButton.frame = CGRectMake(6, 6 + margin * i, 77, 77);//画像サイズがいかなる場合でも77×77にする
     iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
     [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
     //iconButton.center = CGPointMake(6, 51);
     //iconButton.contentMode = UIViewContentModeScaleToFill;
     [scrollView addSubview:iconButton];
     
     //ユーザー名
     UILabel *userNameLabel = [[UILabel alloc] init];
     userNameLabel.backgroundColor = [UIColor clearColor];
     userNameLabel.frame = CGRectMake(96, 16 + margin * i, 200, 20);
     userNameLabel.textColor = [UIColor grayColor];
     userNameLabel.font = [UIFont boldSystemFontOfSize:14];
     userNameLabel.textAlignment = UITextAlignmentLeft;
     userNameLabel.text = [dic objectForKey:@"album_name"];
     [scrollView addSubview:userNameLabel];
     
     //削除ボタン（リムーブボタン）（フォローリストのみ表示）
     UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [deletaButton setTitle:@"" forState:UIControlStateNormal];
     [deletaButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
     deletaButton.frame = CGRectMake(91, 51 + margin * i, 0, 0);
     [deletaButton sizeToFit];
     //位置調整など
     deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
     deletaButton.tag = i;
     [deletaButton addTarget:self action:@selector(image_change_btn:) forControlEvents:UIControlEventTouchUpInside];
     //deletaButton.center = CGPointMake(6, 51);
     //deletaButton.contentMode = UIViewContentModeScaleToFill;
     [scrollView addSubview:deletaButton];
     
     //削除（固定文言）
     UILabel *deletaLabel = [[UILabel alloc] init];
     deletaLabel.frame = CGRectMake(100, 56 + margin * i, 200, 20);
     deletaLabel.backgroundColor = [UIColor clearColor];
     deletaLabel.textColor = [UIColor lightGrayColor];
     deletaLabel.font = [UIFont boldSystemFontOfSize:12];
     deletaLabel.textAlignment = UITextAlignmentLeft;
     deletaLabel.text = @"画像変更";
     [scrollView addSubview:deletaLabel];
     
     
     if(i >=1){
     //削除ボタン（リムーブボタン）（フォローリストのみ表示）
     UIButton *deletaButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
     [deletaButton2 setTitle:@"" forState:UIControlStateNormal];
     [deletaButton2 setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
     deletaButton2.frame = CGRectMake(211, 51 + margin * i, 0, 0);
     [deletaButton2 sizeToFit];
     //位置調整など
     deletaButton2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
     deletaButton2.tag = [[dic objectForKey:@"album_id"]integerValue];
     [deletaButton2 addTarget:self action:@selector(name_change_btn:) forControlEvents:UIControlEventTouchUpInside];
     //deletaButton.center = CGPointMake(6, 51);
     //deletaButton.contentMode = UIViewContentModeScaleToFill;
     [scrollView addSubview:deletaButton2];
     
     //削除（固定文言）
     UILabel *deletaLabel2 = [[UILabel alloc] init];
     deletaLabel2.frame = CGRectMake(220, 56 + margin * i, 200, 20);
     deletaLabel2.backgroundColor = [UIColor clearColor];
     deletaLabel2.textColor = [UIColor lightGrayColor];
     deletaLabel2.font = [UIFont boldSystemFontOfSize:12];
     deletaLabel2.textAlignment = UITextAlignmentLeft;
     deletaLabel2.text = @"名前変更";
     [scrollView addSubview:deletaLabel2];
     
     //削除ボタン（リムーブボタン）（フォローリストのみ表示）
     UIButton *deletaButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
     [deletaButton3 setTitle:@"" forState:UIControlStateNormal];
     [deletaButton3 setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
     deletaButton3.frame = CGRectMake(211, 11 + margin * i, 0, 0);
     [deletaButton3 sizeToFit];
     //位置調整など
     deletaButton3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
     deletaButton3.tag = [[dic objectForKey:@"album_id"]integerValue];
     [deletaButton3 addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
     //deletaButton.center = CGPointMake(6, 51);
     //deletaButton.contentMode = UIViewContentModeScaleToFill;
     [scrollView addSubview:deletaButton3];
     
     
     //削除（固定文言）
     UILabel *deletaLabel3 = [[UILabel alloc] init];
     deletaLabel3.frame = CGRectMake(220, 16 + margin * i, 200, 20);
     deletaLabel3.backgroundColor = [UIColor clearColor];
     deletaLabel3.textColor = [UIColor lightGrayColor];
     deletaLabel3.font = [UIFont boldSystemFontOfSize:12];
     deletaLabel3.textAlignment = UITextAlignmentLeft;
     deletaLabel3.text = @"削除";
     [scrollView addSubview:deletaLabel3];
     
     }
     
     //横線
     UIView *uv = [[UIView alloc] init];
     uv.frame = CGRectMake(0, 88 + margin * i, 320, 1);
     uv.backgroundColor = [UIColor lightGrayColor];
     [scrollView addSubview:uv];
     
     scrollView.contentSize = CGSizeMake(320,133 + margin * i);
     }
     }*/
}
//テキストフォーカス終わり
-(void)hoge3:(UITextField*)textfield
{
    // [textfield resignFirstResponder];
    //  [dataSource_ removeLastObject]; 
    // [dataSource_ addObject:textField.text];
    // NSLog(@"text %@",textfield.text);
    //[dataSource_ addObject:textView.text];
    //NSLog(@"textfield%@",textView.text);
}




@end
