//
//  MysettingViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/12/01.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "MysettingViewController.h"
#import "loadingAPI.h"
#import "UIAsyncImageView.h"
#import "ModalDatePickerViewController.h"
#import "MypageViewController.h"

@implementation MysettingViewController

@synthesize dateForDate1,dateForDate2;

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    if (textField.tag==0) {
        return YES;
        
    }
    else if(textField.tag==1){
        // Show UIPickerView
        [inputComment resignFirstResponder];
        [inputName resignFirstResponder];
        datePickerController = [[ModalDatePickerViewController alloc]init];
        datePickerController.pickerName_ = @"pickerOfDate1";
        datePickerController.dispDate_ = (self.dateForDate1 != nil)?self.dateForDate1:[NSDate date];
        datePickerController.delegate = self;
        [self showModal:datePickerController.view];
        return NO;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getUserInfo:Uid];
    NSLog(@"aaa %@",restmp);
    int cnt = [[restmp objectForKey:@"result"] count];
    
    inputName.text =[defaults stringForKey:@"MAIN_NAME"];
    inputBirth.text =[defaults stringForKey:@"BIRTH_DAY"];
    inputComment.text =[defaults stringForKey:@"USER_PROFILE"];
    
    inputName.tag =0;
    inputBirth.tag=1;
    
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    
    int margin = 89;//配置時の高さマージン
    int i=0;
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog("res%@",result);
        for (NSDictionary *dic in result) 
        {
            
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
            
            [ai changeImageStyle:[dic objectForKey:@"icon_path"] :60:60 :0:0 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            
            CGRect rect = ai.frame;
            rect.size.height = 60;
            rect.size.width = 60;
            ai.frame = rect;
            ai.tag = i;
            //plz set Frame size this erea
            ai.frame = CGRectMake(0, 0, 60, 60);
            //[icon_image addSubview:ai];
            [ai release];
            
            NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"icon_path"]];
            NSLog(@"uri = %@",uri);
            NSData *dt = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:uri]];
            UIImage *image = [[UIImage alloc] initWithData:dt];
            
            //ユーザーアイコン（ボタン）
            iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconButton setTitle:@"" forState:UIControlStateNormal];
            [iconButton setBackgroundImage:image forState:UIControlStateNormal];
            //[iconButton sizeToFit];
            iconButton.frame = CGRectMake(6, 51 + margin * i, 77, 77);//画像サイズがいかなる場合でも77×77にする
            iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            iconButton.tag = [[dic objectForKey:@"uid"] integerValue];
            [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:iconButton];
            
            //ユーザー名
            UILabel *userNameLabel = [[UILabel alloc] init];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.frame = CGRectMake(91, 51 + margin * i, 200, 20);
            userNameLabel.textColor = [UIColor grayColor];
            userNameLabel.font = [UIFont boldSystemFontOfSize:14];
            userNameLabel.textAlignment = UITextAlignmentLeft;
            userNameLabel.text = [dic objectForKey:@"name"];
            [scrollView addSubview:userNameLabel];
            
            
            //削除ボタン（リムーブボタン）（フォローリストのみ表示）
            UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deletaButton setTitle:@"" forState:UIControlStateNormal];
            [deletaButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
            deletaButton.frame = CGRectMake(91, 96 + margin * i, 0, 0);
            [deletaButton sizeToFit];
            
            //位置調整など
            deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [deletaButton addTarget:self action:@selector(showPhotoSheet) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:deletaButton];
            
            //削除（固定文言）
            UILabel *deletaLabel = [[UILabel alloc] init];
            deletaLabel.frame = CGRectMake(100, 101 + margin * i, 200, 20);
            deletaLabel.backgroundColor = [UIColor clearColor];
            deletaLabel.textColor = [UIColor lightGrayColor];
            deletaLabel.font = [UIFont boldSystemFontOfSize:11];
            deletaLabel.textAlignment = UITextAlignmentLeft;
            deletaLabel.text = @"画像変更";
            [scrollView addSubview:deletaLabel];
            
            //横線
            UIView *uv = [[UIView alloc] init];
            uv.frame = CGRectMake(0, 133 + margin * i, 320, 1);
            uv.backgroundColor = [UIColor lightGrayColor];
            [scrollView addSubview:uv];
            
            [scrollView setContentSize:CGSizeMake(320,886)];
            
        }
	}
}


//決定ボタン
- (IBAction)sendUserData:(UIButton *)sender
{
    
    NSLog(@"sender %@",sender);
    
    NSLog(@"text %@",inputName.text);
    NSLog(@"text %@",inputComment.text);
    NSLog(@"birth %@",inputBirth.text);
    
    if(inputBirth.text==nil)
    {
        inputBirth.text=@"";//@"1980/01/01";
    }
    //  NSString *birthText = [inputBirth.text substringWithRange:NSMakeRange(0, 9)];
    
    
    //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    // [dateFormatter setDateFormat:@"yyyy/MM/dd"];//
    //NSDate *birthDay= [dateFormatter dateFromString:inputBirth];
    
    
    // NSDate *birthDay= [dateFormatter dateFromString:birthText];
    loadingapi = [[loadingAPI alloc] init];
    [loadingapi changeProfile :inputName.text:inputComment.text:inputBirth.text];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:inputName.text forKey:@"MAIN_NAME"];
    [defaults setObject:inputBirth.text forKey:@"BIRTH_DAY"];
    [defaults setObject:inputComment.text forKey:@"USER_PROFILE"];
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:NO];
}

//名前
-(IBAction) setUserName:(UITextField *)sender
{
    NSLog(@"name %@",sender);
    inputName=sender.text;
    
}

//誕生日
-(IBAction) setUserBirth:(UITextField *)sender
{
    
    NSLog(@"name %@",sender);
    inputBirth=sender.text;   
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"textField %@",textField);
    
    [textField resignFirstResponder];
    return YES;
}


/*
 //テキストフォーカス終わり
 -(void)hoge3:(UITextField*)textfield
 {
 
 
 //  [dataSource_ removeLastObject]; 
 // [dataSource_ addObject:textField.text];
 // NSLog(@"text %@",textfield.text);
 
 
 //[dataSource_ addObject:textView.text];
 
 //NSLog(@"textfield%@",textView.text);
 }
 
 //フォーカスがはずれたときの処理
 //[textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
 
 
 
 -(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
 //NSLog(@"button %@",searchBar.text);
 [self getSearchData:searchBar.text];
 [searchBar resignFirstResponder];//検索入力エリア閉じる
 }*/

- (void)showPhotoSheet
{
    // ソースタイプを決定する
    UIImagePickerControllerSourceType   sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    // 使用可能かどうかチェックする
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    // イメージピッカーを作る
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker autorelease];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsImageEditing = YES;
    imagePicker.delegate = self;
    
    // イメージピッカーを表示する
    [self presentModalViewController:imagePicker animated:YES];
    
}

//画像が選択された時に呼ばれるデリゲートメソッド
-(void)imagePickerController:(UIImagePickerController*)picker
       didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo{
    
    [self dismissModalViewControllerAnimated:YES];  // モーダルビューを閉じる
    
    //画像アップロード関数
    [self uploadImage:image];
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:NO];
    
    
    //loadingAPI* loadingapi=[[loadingAPI alloc] init];
    //iconButton.imageView.image = image;NSdataだたかで渡さないとだめ
    
}


-(void) uploadImage:(UIImage *)newImage
{
    
    // UIImagePNGRepresentation関数によりUIImageが保持する画像データをPNG形式で抽出可能
    NSData* photo = [[[NSData alloc] initWithData:UIImageJPEGRepresentation(newImage, 1.0)] autorelease];
    
	//NSData *photo = [NSData dataWithContentsOfURL:newImage];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int _MDAC_UID=[[defaults stringForKey:@"MDAC_UID"] intValue];
    NSString *_MDAC_PASSCODE=[defaults stringForKey:@"MDAC_PASSCODE"];      
    
    // バウンダリ設定
    NSString *boundary = [NSString stringWithString:@"--meets-dogs-and-cats--"];
    NSMutableData* result_ = [[NSMutableData alloc] init];
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"post_image\"; filename=\"%d.jpg\"\r\n\r\n", _MDAC_UID] dataUsingEncoding:NSASCIIStringEncoding]];
    //    [result_ appendData:[[NSString stringWithFormat:@"Photo"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:photo];
    
    [result_ appendData:[[NSString stringWithFormat:@"%@", @"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uid\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", _MDAC_UID]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pass_code\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%@\r\n", _MDAC_PASSCODE]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"size\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", [photo length] ]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    // バウンダリの終端
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    // リクエストの作成
    NSURL *url = [NSURL URLWithString:DATA_SERVER_URL "gw/userImage"];
    NSMutableURLRequest *request_ = [NSMutableURLRequest requestWithURL:url];
    
    // ログの表示
    NSString *_str= [[NSString alloc] initWithData:result_ encoding:NSUTF8StringEncoding];
    NSLog(@"log='\r\n%@", _str);
    
    
    // ヘッダ情報を設定
    [request_ addValue:[NSString stringWithFormat:
                        @"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField: @"Content-Type"];
    
    [request_ setHTTPMethod:@"POST"];
    [request_ setHTTPBody:result_];
    
    // 通信し、リザルトを受け取る
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request_ 
                                                   returningResponse:&response error:&error];
    NSLog(@"%@", url);
    
    NSLog(@"error='%@'", error);
    
    // エラー表示
    NSHTTPURLResponse *urlresponse = (NSHTTPURLResponse *)response;
    NSLog(@"レスポンスコード表示 %d",[urlresponse statusCode]);
    
    // リザルト表示
    NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
                             autorelease];
    NSLog(@"result='%@'", http_result);
    
    // リザルト解放
    [result_ release], result_ = nil;
    
    // json分解(デバッグ用）
    // http_result は、(NSString *)型
    NSDictionary *dic = [[http_result JSONValue] objectForKey:@"result"];
    NSLog(@"json分解");
    
    for (NSString *str in dic) {
        NSLog(@"%@=%@", str, [dic objectForKey:str]);
    }
    
}






//画像の選択がキャンセルされた時に呼ばれる
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];  // モーダルビューを閉じる
	// 何かの処理
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)viewWillAppear:(BOOL)animated{
    
}



// Use this to show the modal view (pops-up from the bottom)
- (void) showModal:(UIView*) modalView {
    //UIWindow* mainWindow = (((ModalDatePickerDemoAppDelegate*) [UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    modalView.center = offScreenCenter; // we start off-screen
    [self.view addSubview:modalView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5]; // animation duration in seconds
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

// Use this to slide the semi-modal view back down.
- (void) hideModal:(UIView*) modalView {
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    [UIView beginAnimations:nil context:modalView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
}

- (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIView* modalView = (UIView *)context;
    [modalView removeFromSuperview];
}

- (IBAction) buttonForDate1Clicked:(id)sender {
    
    
}

- (IBAction) buttonForDate2Clicked:(id)sender {
    datePickerController = [[ModalDatePickerViewController alloc] init];
    datePickerController.pickerName_ = @"pickerOfDate2";
    datePickerController.dispDate_ = (self.dateForDate2 != nil)?self.dateForDate2:[NSDate date];
    datePickerController.delegate = self;
    [self showModal:datePickerController.view];
}

#pragma mark -
#pragma mark ModalDatePickerViewController delegate

- (void)didCommitButtonClicked:(ModalDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    [datePickerController release];
    datePickerController = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    if ([pickerName isEqualToString:@"pickerOfDate1"]) {
        self.dateForDate1 = selectedDate;
        labelForDate1.text = [formatter stringFromDate:self.dateForDate1];
    }
    
    NSString *time_format;
    time_format=[formatter stringFromDate:self.dateForDate1];
    inputBirth.text = time_format;//[NSString stringWithFormat:@"%@", self.dateForDate1];
    NSLog(@"time_format%@",time_format);
    NSLog(@"self.dateForDate1%@",self.dateForDate1);
    NSLog(@"formatter%@",formatter);
    
    
    [formatter release];
}

- (void)didCancelButtonClicked:(ModalDatePickerViewController *)controller pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    [datePickerController release];
    datePickerController = nil;
}

- (void)didClearButtonClicked:(ModalDatePickerViewController *)controller pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    [datePickerController release];
    datePickerController = nil;
    
    if ([pickerName isEqualToString:@"pickerOfDate1"]) {
        self.dateForDate1 = nil;
        labelForDate1.text = @"";
    } else if ([pickerName isEqualToString:@"pickerOfDate2"]) {
        self.dateForDate2 = nil;
        labelForDate2.text = @"";
    }
}

- (void)modalButtonDidPush{
    
}
/*
 
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 
 - (void)viewDidUnload {
 [dateForDate1 release];
 dateForDate1 = nil;
 [dateForDate2 release];
 dateForDate2 = nil;
 }
 
 - (void)dealloc {
 [dateForDate1 release];
 [dateForDate2 release];
 [super dealloc];
 }
 
 */

@end
