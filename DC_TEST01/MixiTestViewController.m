//
//  MixiTestViewController.m
//  mixitest
//
#import "SBJSon.h"
#import "SecondViewController.h"
#import "MixiTestViewController.h"

// mixi api
#define kMixiApiUri                 @"http://api.mixi-platform.com/2/people/@me/@self"
#define kMixiUpgradeUri             @"https://secure.mixi-platform.com/2/token"
#define kMixiUpgradeParamsFormat    @"grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@"

@implementation MixiTestViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
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
    //login_vc = nil;
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
/*
 - (void)parse_state:(NSString *)state
 {
 NSLog(@"*state* = %@", state);
 _state = state;
 }
 */

- (void)parse_refresh_token:(NSString *)refresh_token
{
    NSLog(@"*refresh_token* = %@", refresh_token);
    _refresh_token = refresh_token;
}
- (void)parse_access_token:(NSString *)access_token
{
    NSLog(@"*access_token* = %@", access_token);
    _access_token = access_token;
}
- (void)parse_expires_in:(NSString *)expires_in
{
    NSLog(@"*expires_in* = %@", expires_in);
    _expires_in = expires_in;
}

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//
// ブラウザにアクセスさせる
- (void)modalButtonDidPush
{
    
    // Consumer Key
    _client_id = MIXI_CONSUMER_KEY;
    // Consumer secret
    _client_secret = MIXI_CONSUMER_SECRET;
    // 認可したいスコープ
    _scope = @"r_profile w_voice";
    // デバイス
    _display = @"touch";
    // リダイレクト先
    _redirect_uri = MIXI_CALLBACK_URL;
    // ステート（本アプリではSNS名を設定）
    _stat = @"mixi";
    _refresh_token =@"";// nil;
    
    
    
    NSString *login_uri = MIXI_LOGIN_URI;
    NSLog(@"client_id=%@", _client_id);
    NSLog(@"scope=%@", _scope);
    NSLog(@"display=%@", _display);
    NSLog(@"state=%@", _stat);
    
    
    
    
    
    NSString *tmp = [[NSString alloc]initWithFormat:@"client_id=%@&response_type=code&scope=%@&display=%@&state=%@",_client_id, _scope, _display, _stat];
    
    NSString *prm = [tmp stringByURLEncoding:NSUTF8StringEncoding];
    NSString *uri = [NSString stringWithFormat:@"%@?%@",login_uri, prm];
    
    NSLog(@"uri = %@", uri);
    
    // Login用のWebViewを出す
    //    [_login_vc release], _login_vc = nil;
    //_login_vc = [[LoginWebViewController alloc] init];
    //_login_vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _secondview.authorize_uri = uri;
    _secondview.response_uri = _redirect_uri;
    _secondview.params = prm;
    _secondview.caller = self;
    //_login_vc.webview_delegate = _login_vc;
    
    [tmp release], tmp = nil;
    [_secondview viewURLPage];    
    //  [self presentModalViewController:_login_vc animated:YES];
}

// アクセストークン・リフレッシュトークンの取得
// 同期通信
// *ToDo* 通信エラーチェック
-(BOOL) accessTokenGet
{
    BOOL result = YES;
    
    NSLog(@"accessTokenGet");
    NSURL *url = [NSURL URLWithString: MIXI_TOKEN_URI];
    
    NSString *enc = [_redirect_uri stringByURLEncoding:NSUTF8StringEncoding];
	NSString *bodyString = [NSString stringWithFormat:@"grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",_client_id, _client_secret, _authorization, enc];
    
    NSData *myRequestData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"body='%@'", bodyString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:myRequestData];
    
	// レスポンスを得る（ここで呼び出すと思われる）
	NSURLResponse *response = nil;
    NSError       *error    = nil;
	
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response error:&error];
	NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
                             autorelease];
    NSLog(@"%@", http_result);
    
	NSDictionary *dic = [http_result JSONValue];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([dic valueForKey:@"refresh_token"])
    {
        // リフレッシュトークンを取得
        if ([self respondsToSelector:@selector(parse_refresh_token:)]) 
        {
            //トークン保存
            [defaults setObject:[dic valueForKey:@"refresh_token"] forKey:@"MixiRefreshToken"];
            [self parse_refresh_token:[dic valueForKey:@"refresh_token"]];
        }
    }
    if ([dic valueForKey:@"access_token"]) 
    {
        // アクセストークンを取得
        if ([self respondsToSelector:@selector(parse_access_token:)])
        {
            //トークン保存
            [defaults setObject:[dic valueForKey:@"access_token"] forKey:@"MixiAccessToken"];
            [self parse_access_token:[dic valueForKey:@"access_token"]];
        }
    }
    if ([dic valueForKey:@"expires_in"]) {
        // 有効時間を取得
        if ([self respondsToSelector:@selector(parse_expires_in:)]) 
        {
            [self parse_expires_in:[dic valueForKey:@"expires_in"]];
        }
    }
    /*
     // json分解(デバッグ用）
     NSLog(@"json分解");
     
     for (NSString *str in dic) {
     NSLog(@"%@=%@", str, [dic objectForKey:str]);
     }
     */
    return result;
}

//--------------------------------------------------------------//
#pragma mark -- API --
//--------------------------------------------------------------//

// SNS(mixi)にログインして、ユーザIDと画像を取ってきます。
// そして本システムに登録します。 

// ログインを行います。
- (void) login 
{    //_authorization;
#if DEBUG    
    NSLog(@"mixi Login");
#endif    
    // mixiから自分の情報を取ってくる
    NSString *code = [NSString stringWithString:kMixiUpgradeUri];
    
    NSURL *url = [NSURL URLWithString:MIXI_API_URI "token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    //request.HTTPBody = [[NSString stringWithFormat:kMixiUpgradeParamsFormat, MIXI_CONSUMER_KEY, MIXI_CONSUMER_SECRET, code, MIXI_CALLBACK_URL] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    NSString *accessToken = _access_token;
    
    url = [NSURL URLWithString:kMixiApiUri];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"OAuth %@", accessToken] forHTTPHeaderField:@"Authorization"];
    result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    json = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", json);
    
    // SBJsonを使った解析
    NSDictionary * restmp = [json JSONValue];
    
    NSLog(@"mixiのデータ解析");
    NSDictionary *entry = [restmp objectForKey:@"entry"];
    NSLog(@"items=%d", [entry count]);        
    
    NSLog(@"displayName=%@", [entry objectForKey:@"displayName"]);
    NSLog(@"thumbnailUrl=%@", [entry objectForKey:@"thumbnailUrl"]);
    NSLog(@"id=%@", [entry objectForKey:@"id"]);
    
    // 結果をしまっておく
    _displayName = [entry objectForKey:@"displayName"];
    _thumbnailUrl = [entry objectForKey:@"thumbnailUrl"];
    _sns_id = [entry objectForKey:@"id"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_displayName forKey:@"MixiName"];//mixi専用名を保存
    
    // 画像アイコンDL
	NSURL *url_img = [NSURL URLWithString:_thumbnailUrl];
	NSData *data = [NSData dataWithContentsOfURL:url_img];
    if (data == nil) {
        // エラー処理
        NSLog(@"mixi:ユーザーアイコン読み込みエラー");
        
    }
	_user_icon = [[UIImage alloc] initWithData:data];
    
    // 
    NSLog(@"user_icon読み込み完了");
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:_user_icon] autorelease];
    //    imageView.center = [self view].center;　// メインのウインドウの中心に置く
    [_user_icon release];
    
    [self.view addSubview:imageView]; // 画面に付け加える
    
    // ユーザ登録
    [self createUser: _displayName];
    
    // 仮UDで進める
    //self.MDAC_UID = 329;
    //self.MDAC_PASSCODE = @"qhz421S2hE7yvHyO6y35";
    
    // 取得したデータを本システムへ登録
    // マルチパートでのアップロード
    // 画像アイコンDL
	url_img = [NSURL URLWithString:_thumbnailUrl];
	NSData *photo = [NSData dataWithContentsOfURL:url_img];
    if (photo == nil) {
        // エラー処理
        NSLog(@"mixi:ユーザーアイコン読み込みエラー");
    }
    
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
        snsName=@"mixi";
        [defaults setObject:snsName forKey:@"SNS_NAME"];      
    }
    if([defaults objectForKey:@"MAIN_NAME"]==nil)
    {
        [defaults setObject:_displayName forKey:@"MAIN_NAME"];
    }
    
}

-(NSString *) reAccessTokenGet
{
    _client_id = MIXI_CONSUMER_KEY;
    _client_secret = MIXI_CONSUMER_SECRET;
    
    
    /// grant_typeが「refresh_token」
    // 「redirect_uri」「code」の代わりに「refresh_token」を指定する
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *mixiRefreshToken=[defaults objectForKey:@"MixiRefreshToken"];
    
    NSURL *url = [NSURL URLWithString: @"https://secure.mixi-platform.com/2/token"];
    
    //NSString *enc = [_redirect_uri stringByURLEncoding:NSUTF8StringEncoding];
	NSString *bodyString = [NSString stringWithFormat:@"grant_type=refresh_token&client_id=%@&client_secret=%@&refresh_token=%@",_client_id, _client_secret, mixiRefreshToken];
    
    NSData *myRequestData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"body='%@'", bodyString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:myRequestData];
    
    
	NSURLResponse *response = nil;
    NSError       *error    = nil;
	
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response error:&error];
	NSString *http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding]
                             autorelease];
    NSLog(@"gettoken %@", http_result);
    
	NSDictionary *dic = [http_result JSONValue];
    
    //NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    /* if ([dic valueForKey:@"refresh_token"])
     {
     // リフレッシュトークンを取得
     if ([self respondsToSelector:@selector(parse_refresh_token:)])
     {
     
     [defaults setObject:[dic valueForKey:@"refresh_token"] forKey:@"MixiRefreshToken"];
     [self parse_refresh_token:[dic valueForKey:@"refresh_token"]];
     }
     }*/
    if ([dic valueForKey:@"access_token"]) 
    {
        // アクセストークンを取得
        if ([self respondsToSelector:@selector(parse_access_token:)])
        {
            //トークン保存
            [defaults setObject:[dic valueForKey:@"access_token"] forKey:@"MixiAccessToken"];
            
            [self parse_access_token:[dic valueForKey:@"access_token"]];
        }
    }
    if ([dic valueForKey:@"expires_in"]) {
        // 有効時間を取得
        if ([self respondsToSelector:@selector(parse_expires_in:)]) 
        {
            [self parse_expires_in:[dic valueForKey:@"expires_in"]];
        }
    }
    
    return [dic valueForKey:@"access_token"];
}


//mixiボイスにメッセージ投稿
-(void)postMessage:(NSString *)message
{
    
    //トークンの取り直し
    NSString *mixiAccessToken=[self reAccessTokenGet];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://api.mixi-platform.com/2/voice/statuses/update"];
    NSString *header = [[NSString alloc] initWithFormat:@"OAuth %@", mixiAccessToken];
    
    NSData *body = [[NSString stringWithString:[[NSString alloc] initWithFormat:@"status=%@", message]] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
}
@end