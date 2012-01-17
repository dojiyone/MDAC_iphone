//
//  FBTestViewController.m
//  mixitest
//
#import "SBJSon.h"
#import "FBTestViewController.h"
#import "SecondViewController.h"

#define TOKEN_URL   @"https://graph.facebook.com/oauth/access_token"

@implementation FBTestViewController

//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//
//@synthesize login_vc = _login_vc; // ログイン用のLoginWebViewController

@synthesize client_id = _client_id;
@synthesize client_secret = _client_secret;
@synthesize scope = _scope;
@synthesize display = _display;
@synthesize stat = _stat;
@synthesize redirect_uri = _redirect_uri;
@synthesize authorization = _authorization;
@synthesize refresh_token = _refresh_token;
@synthesize expires_in = _expires_in;
@synthesize access_token = _access_token;
@synthesize error_code = _error_code;

@synthesize user_icon = _user_icon;

@synthesize MDAC_UID = _MDAC_UID;
@synthesize MDAC_PASSCODE = _MDAC_PASSCODE;

@synthesize displayName = _displayName;     // ディスプレイ名
@synthesize thumbnailUrl = _thumbnailUrl;    // サムネイルURL
@synthesize sns_id = _sns_id;          // SNSのID


//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (void)dealloc
{
    [_client_id release], _client_id = nil;
    [_client_secret release], _client_secret = nil;
    [_scope release], _scope = nil;
    [_display release], _display = nil;
    [_redirect_uri release], _redirect_uri = nil;
    
    //[_login_vc release], _login_vc = nil;
    
    _stat = @"";
    [_authorization release], _authorization = nil;
    [_refresh_token release], _refresh_token = nil;
    [_expires_in release], _expires_in = nil;
    [_access_token release], _access_token = nil;
    [_error_code release], _error_code = nil;
    [_user_icon release], _user_icon = nil;
    _MDAC_UID = -1;
    
    [_MDAC_PASSCODE release], _MDAC_PASSCODE = nil;
    [_displayName release], _displayName = nil;
    [_thumbnailUrl release], _thumbnailUrl = nil;
    [_sns_id release], _sns_id = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//--------------------------------------------------------------//
#pragma mark -- Private method --
//--------------------------------------------------------------//

// Login画面をクローズ
- (void)close_webview:(NSString *)_code
{
    // ログイン用のWebViewを閉じる
    [self dismissModalViewControllerAnimated:YES];
    
    //[_login_vc release];
    //_login_vc = nil;
}

//--------------------------------------------------------------//
#pragma mark -- LoginWebViewControllerDelegate --
//--------------------------------------------------------------//
// authコードが取れた時に呼ばれる
- (void)parse_authorization_code:(NSString *)authorization_code
{
    NSLog(@"*authcode* = %@", authorization_code);
    _authorization = authorization_code;
    
    // ログイン用のWebViewを閉じる
    [self close_webview:authorization_code];
}

// 承認が取れなかったときに呼ばれる
- (void)parse_access_denied:(NSString *)error_code
{
    NSLog(@"*errorcode* = %@", error_code);
    _error_code = error_code;
    
    // ログイン用のWebViewを閉じる
    [self close_webview:error_code];
}

// stateを設定
- (void)parse_state:(NSString *)state
{
    NSLog(@"*state* = %@", state);
    _stat = state;
}
// リフレッシュトークンを取得。このFaceBook連動では未使用
- (void)parse_refresh_token:(NSString *)refresh_token
{
    NSLog(@"*refresh_token* = %@", refresh_token);
    _refresh_token = refresh_token;
}
// アクセストークンを取得。
- (void)parse_access_token:(NSString *)access_token
{
    NSLog(@"*access_token* = %@", access_token);
    _access_token = access_token;
    // ログイン用のWebViewを閉じる
    
    //トークン保存
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_access_token forKey:@"FBAccessToken"];
    
    
    [self close_webview:_access_token];
}
// 未使用
- (void)parse_expires_in:(NSString *)expires_in
{
    NSLog(@"*expires_in* = %@", expires_in);
    _expires_in = expires_in;
}

/*
 //--------------------------------------------------------------//
 #pragma mark -- AccessTokenResponseParserDelegate --
 //--------------------------------------------------------------//
 
 - (void)parser:(AccessTokenResponseParser*)parser didReceiveResponse:(NSURLResponse*)response
 {
 NSLog(@"parser::didReceiveResponse");
 }
 
 - (void)parser:(AccessTokenResponseParser*)parser didReceiveData:(NSData*)data
 {
 NSLog(@"parser::didReceiveData");
 }
 
 - (void)parserDidFinishLoading:(AccessTokenResponseParser*)parser
 {
 NSLog(@"parser::parserDidFinishLoading");
 
 //   NSLog(@"%@", [parser.tokens description]);
 
 }
 
 - (void)parser:(AccessTokenResponseParser*)parser didFailWithError:(NSError*)error
 {
 NSLog(@"parser::didFailWithError");    
 }
 
 - (void)parserDidCancel:(AccessTokenResponseParser*)parser
 {
 NSLog(@"parser::parserDidCancel");    
 }
 */

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//
// ブラウザにアクセスさせる
- (void)modalButtonDidPush
{
    
    // Consumer Key
    _client_id = FACEBOOK_APP_ID;
    // Consumer secret
    _client_secret = FACEBOOK_APP_SECRET;
    // 認可したいスコープ
    _scope = @"offline_access,read_stream,publish_stream";
    // デバイス
    _display = @"touch";
    // リダイレクト先
    _redirect_uri = FACEBOOK_TOKEN_CALLBACK_URL;
    // ステート（本アプリではSNS名を設定）
    _stat = @"fb";
    _refresh_token =@"";// nil;
    
    
    
    NSString *login_uri = FACEBOOK_AUTH_URL;
    
    NSString *tmp = [NSString stringWithFormat:
                     @"client_id=%@&redirect_uri=%@&scope=%@&display=touch&response_type=token",
                     _client_id,_redirect_uri,_scope];
    NSString *prm = [tmp stringByURLEncoding:NSUTF8StringEncoding];
    NSString *uri = [NSString stringWithFormat:@"%@?%@",login_uri, prm];
    
    
    
    
    //   [_login_vc release], _login_vc = nil;
    //_login_vc = [[LoginWebViewController alloc] init];
    //_login_vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _secondview.authorize_uri = uri;
    _secondview.response_uri = _redirect_uri;
    _secondview.params = prm;
    _secondview.caller = self;
    //_login_vc.webview_delegate = _login_vc;
    
    [_secondview viewURLPage];
    //[self presentModalViewController:_login_vc animated:YES];
}

// アクセストークンの取得
// 同期通信
// ダミー
-(BOOL) accessTokenGet
{
    BOOL result = YES;
    
    NSLog(@"accessTokenGet");
    
    return result;
}

//--------------------------------------------------------------//
#pragma mark -- API --
//--------------------------------------------------------------//

// SNS(FaceBook)にログインして、ユーザIDと画像を取ってきます。
// そして本システムに登録します。 

// ログインを行います。
- (void) login 
{    //_authorization;
#if DEBUG    
    NSLog(@"FB Login");
#endif
    
    // ログイン
    NSString *login_uri = FACEBOOK_AUTH_URL;
    NSString *tmp = [NSString stringWithFormat:
                     @"client_id=%@&redirect_uri=%@&scope=%@&display=touch&response_type=token",
                     _client_id,_redirect_uri,_scope];
    NSString *prm = [tmp stringByURLEncoding:NSUTF8StringEncoding];
    NSString *uri = [NSString stringWithFormat:@"%@?%@",login_uri, prm];
    
    NSLog(@"uri = %@", uri);
    NSURL *url = [NSURL URLWithString:uri];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    //    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSLog(@"FBのデータ解析");
    
    // 通信し、リザルトを受け取る
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    
    tmp = [NSString stringWithFormat: FACEBOOK_API_URL "me?access_token=%@", _access_token];
    url = [NSURL URLWithString: tmp];
    request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@", url);
    // 同期通信
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response error:&error];
    
 	NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
                             autorelease];
    NSLog(@"%@", http_result);
    
    // テータ解析
	NSDictionary *entry = [http_result JSONValue];
    
    NSLog(@"displayName=%@", [entry objectForKey:@"name"]);
    NSLog(@"id=%@", [entry objectForKey:@"id"]);
    
    // 結果をしまっておく
    _displayName = [entry objectForKey:@"name"];
    _sns_id = [entry objectForKey:@"id"];
    
    //   [[NSString alloc]initWithFormat: FACEBOOK_API_URL "me?access_token=%@", _access_token];
    _thumbnailUrl = [[NSString alloc]initWithFormat: FACEBOOK_API_URL "me/picture?access_token=%@", _access_token];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_displayName forKey:@"FBName"];//FB専用名を保存
    
    NSLog(@"thumbnailUrl=%@", _thumbnailUrl);
    
    // 画像アイコンDL
	NSURL *url_img = [NSURL URLWithString:_thumbnailUrl];
	NSData *data = [NSData dataWithContentsOfURL:url_img];
    if (data == nil) {
        // エラー処理
        NSLog(@"facebook:ユーザーアイコン読み込みエラー");
        
    }
	_user_icon = [[UIImage alloc] initWithData:data];
    
    // 
    NSLog(@"user_icon読み込み完了");
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:_user_icon] autorelease];
    imageView.center = [self view].center;  // メインのウインドウの中心に置く
    [_user_icon release];
    
    [self.view addSubview:imageView]; // 画面に付け加える
    
    // ユーザ登録
    [self createUser: _displayName];
    
    // 仮UDで進める
    //_MDAC_UID = 329;
    //_MDAC_PASSCODE = @"qhz421S2hE7yvHyO6y35";
    
    // 取得したデータを本システムへ登録
    // マルチパートでのアップロード
    // 画像アイコンDL
	url_img = [NSURL URLWithString:_thumbnailUrl];
	NSData *photo = [NSData dataWithContentsOfURL:url_img];
    if (photo == nil) {
        // エラー処理
        NSLog(@"mixi:ユーザーアイコン読み込みエラー");
    }
    //	user_icon2 = [[UIImage alloc] initWithData:photo];
    
    // 
    NSLog(@"user_icon読み込み完了(2)");
    
    // コンテンツの作成
    // マルチパートアップロード
    NSLog(@"画像アップロード");
    
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
    url = [NSURL URLWithString:DATA_SERVER_URL "gw/userImage"];
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
    response = nil;
    error    = nil;
    oauth_response = [NSURLConnection sendSynchronousRequest:request_ 
                                           returningResponse:&response error:&error];
    NSLog(@"%@", url);
    
    NSLog(@"error='%@'", error);
    
    // エラー表示
    NSHTTPURLResponse *urlresponse = (NSHTTPURLResponse *)response;
    NSLog(@"レスポンスコード表示 %d",[urlresponse statusCode]);
    
    // リザルト表示
    http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
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
    
    
    
    
    //ここで完了。戻る
    [self.navigationController popViewControllerAnimated:YES];    
}

// ユーザ登録を行います
- (void) createUser : (NSString *) name
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //NSString *snsName=[defaults objectForKey:@"SNS_NAME"];
    //if(snsName==@""||snsName==nil)
    if([defaults objectForKey:@"MDAC_UID"]==nil)
    {
        
        // 引数エンコード
        NSString *encodeString = [name encodeString:NSUTF8StringEncoding];
        NSString *strtmp = [NSString stringWithFormat:DATA_SERVER_URL "gw/createUser?name=%@",encodeString];
        NSLog(@"%@", strtmp);
        
        // サーバアクセス
        NSURL *url = [NSURL URLWithString:strtmp];
        NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];//m
        // 生データ表示
        NSLog(@"%@", jsonString);
        NSDictionary * restmp = [jsonString JSONValue];
        
        // SBJsonを使った解析
        NSDictionary *entry = [restmp objectForKey:@"result"];
        //NSLog(@"items=%d", [entry count]);       
        //NSLog(@"%@", [entry objectForKey:@"uid"]);
        //NSLog(@"%@", [entry objectForKey:@"pass_code"]);
        
        // IDとパスコードを取得
        _MDAC_UID = [[entry objectForKey:@"uid"] integerValue];
        _MDAC_PASSCODE =[entry objectForKey:@"pass_code"];
        

        [defaults setInteger:_MDAC_UID forKey:@"MDAC_UID"];
        [defaults setObject:_MDAC_PASSCODE forKey:@"MDAC_PASSCODE"];
    }
    
    
    if([defaults objectForKey:@"SNS_NAME"]==nil)
    {
        snsName=@"facebook";
        [defaults setObject:snsName forKey:@"SNS_NAME"];   
    }
    if([defaults objectForKey:@"MAIN_NAME"]==nil)
    {
        [defaults setObject:_displayName forKey:@"MAIN_NAME"];
    }
    
    /*    
     // SBJSONを使ったJSONデータのパース処理
     for (NSDictionary *dic in result) {
     //        NSArray *tmpArray = [[dic count ]inde objectForKey:@"result"];
     NSLog(@"---");
     //        NSLog(@"items=%d", [dic count]);        
     
     //        NSLog(@"%@", [dic objectForKey:@"post_image_id"]);
     //        NSLog(@"%@", [dic objectForKey:@"image_id"]);
     NSLog(@"%@", [dic objectForKey:@"real_path"]);
     
     */
}




//facebookにメッセージ投稿
-(void)postMessage:(NSString *)message
{
    //テスト用
    /*   NSDateFormatter *formatter = [[[NSDateFormatter alloc] 
     initWithDateFormat:@"%Y/%m/%d %H:%M:%S" 
     allowNaturalLanguage:FALSE] autorelease];
     NSDate* date = [NSDate date];
     message = [formatter stringFromDate:date];
     */ 
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *FBAccessToken=[defaults objectForKey:@"FBAccessToken"];
    
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    NSString *header = @"OAuth ";//[[NSString alloc] initWithFormat:@"OAuth %@", FBAccessToken];
    
    
    NSString *encodeMessage= [message encodeString:NSUTF8StringEncoding];
    NSString *bodydic= [NSMutableString stringWithFormat:@"access_token=%@&message=%@",FBAccessToken,encodeMessage];
    /*
     NSDictionary *privacy = [[[NSDictionary alloc] initWithObjectsAndKeys:
     @"CUSTOM",@"value",
     @"SELF",@"friends",
     nil]autorelease];
     
     */
    
    NSLog(@"bodydic %@",bodydic);
    
    
    NSData *body = [bodydic dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *body = [NSKeyedArchiver archivedDataWithRootObject:bodydic];
    //NSString *string = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    
    
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"res %@",http_result);
    
    
    /*
     //NSLog(@"request %@",request.HTTPBody);
     
     [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     
     // エラーコード取得
     //    NSLog(@"response=%@",response);
     //    NSLog(@"error=%@",error);
     NSLog(@"response %@",response);
     NSLog(@"error %@",error);*/
}










@end

