//
//  TwTestViewController.m
//  mixitest
//
#import "SBJSon.h"
#import "TwTestViewController.h"
#import "SecondViewController.h"
@implementation TwTestViewController


//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//
//@synthesize login_vc = _login_vc; // ログイン用のLoginWebViewController

@synthesize client_id = _client_id;
@synthesize client_secret = _client_secret;
@synthesize stat = _stat;
@synthesize redirect_uri = _redirect_uri;
@synthesize oauth_token = _oauth_token;
@synthesize oauth_token_secret = _oauth_token_secret;
@synthesize request_token = _request_token;
@synthesize expires_in = _expires_in;
@synthesize access_token = _access_token;
@synthesize access_token_secret = _access_token_secret;
@synthesize nonce = _nonce;
@synthesize timestamp = _timestamp;
@synthesize error_code = _error_code;
@synthesize verifier = _verifier;

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
    [_redirect_uri release], _redirect_uri = nil;
    
    //[_login_vc release], _login_vc = nil;
    [_verifier release], _verifier = nil;
    _stat = @"";
    [_oauth_token release], _oauth_token = nil;
    [_oauth_token_secret release], _oauth_token_secret = nil;
    //[_request_token release], _request_token = nil;
    [_expires_in release], _expires_in = nil;
    [_access_token_secret release], _access_token_secret = nil;
    [_access_token release], _access_token = nil;
    [_nonce release], _nonce = nil;
    [_timestamp release], _timestamp = nil;
    [_error_code release], _error_code = nil;
    [_user_icon release], _user_icon = nil;
    _MDAC_UID = -1;
    
    [_MDAC_PASSCODE release], _MDAC_PASSCODE = nil;
    [_displayName release], _displayName = nil;
    [_thumbnailUrl release], _thumbnailUrl = nil;
    [_sns_id release], _sns_id = nil;
    
    
    //[_scope release], _scope = nil;
    //[_display release], _display = nil;
    //[_authorization release], _authorization = nil;
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
    //[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 試しに呼んでみる
    NSLog(@"TwTestViewContoroller::viewDidLoad");
    
    
    [self clientDataSetting];
    
    
}


- (void) clientDataSetting
{
    
    // Consumer Key
    _client_id = TWITTER_CONSUMER_KEY;
    // Consumer secret
    _client_secret = TWITTER_CONSUMER_SECRET;
    
    
    // リダイレクト先
    //_redirect_uri = @"";    //TWITTER_CALLBACK_URL;
    _redirect_uri = TWITTER_CALLBACK_URL;
    
    
    // ステート（本アプリではSNS名を設定）
    _stat = @"http://www.yahoo.com";
    
}



//画像をテスト表示
- (void)getPicture
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int mdacUid=[defaults integerForKey:@"MDAC_UID"]; 
    
    NSString *urlString= [NSString stringWithFormat:DATA_SERVER_URL "gw/getUserInfo/uid:%d",mdacUid];
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"img check"
                          message:urlString
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    
    
    
    
    // イメージの描画テスト
    UIImageView *img2 = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100.0, 100.0)] autorelease];
    img2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    // 画像変換サーバで縮小
    //NSString *urlString = [NSString stringWithFormat:CV_SERVER_URL "%@?sr.dw=100&sr.dh=100&sr.cx=2&sr.cy=2",[dic objectForKey:@"real_path"]];
    //url = [NSURL URLWithString: urlString];
    //NSData *data = [NSData dataWithContentsOfURL: url];
    //img2.image = [UIImage imageWithData: data];
    
    [self.view addSubview: img2];    
    
    
    
}







- (void)viewDidUnload
{
    [super viewDidUnload];
}


//--------------------------------------------------------------//
#pragma mark -- Private method --
//--------------------------------------------------------------//

// Login画面をクローズ
- (void)close_webview:(NSString *)_code
{
    // ログイン用のWebViewを閉じる
    [self dismissModalViewControllerAnimated:YES];
    
    
}

//  アクセストークンを取得
- (void)getAccessToken
{
    // 同期通信・アクセストークンゲット
    [self accessTokenGet];
    
    // ログイン
    [self login];
}

//--------------------------------------------------------------//
#pragma mark -- LoginWebViewControllerDelegate --
//--------------------------------------------------------------//


/*
 // 承認が取れなかったときに呼ばれる
 - (void)parse_access_denied:(NSString *)error_code
 {
 
 
 NSLog(@"*errorcode* = %@", error_code);
 _error_code = error_code;
 
 UIAlertView *alert = [[UIAlertView alloc]
 initWithTitle:@"error"
 message:_error_code
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alert show];
 [alert release];
 
 // ログイン用のWebViewを閉じる
 //[self close_webview:error_code];
 }
 
 */

// Twitterのコールバック処理の時に呼ばれる
- (void)parse_callback_param: (NSString*) prm
{ 
    [self clientDataSetting];
    
    
    
    NSArray *params = [prm componentsSeparatedByString:@"&"];
    NSLog(@"test%@",params);
    
    NSString *str = [[params objectAtIndex:0] substringToIndex:6];
    if([str isEqualToString:@"denied"])
    {
        return;
    }
    
    NSInteger cou = [params count];
    NSInteger i;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _oauth_token=[defaults stringForKey:@"TwitterOauthToken"]; 
    _oauth_token_secret=[defaults stringForKey:@"TwitterOauthTokenSecret"]; 
    
    
    for (i=0; i<cou; i++) 
    {
        NSString *tmp = [params objectAtIndex:i];
        NSArray *divs = [tmp componentsSeparatedByString:@"="];
        
        // パラメータ取得
        NSString *value = [[divs objectAtIndex:1] description];
        NSString *key = [[divs objectAtIndex:0] description];
        
        //        NSLog(@"key:%@",key);
        //        NSLog(@"value:%@",value);
        
        //もどしたところ
        if ([key compare:@"oauth_token"] == NSOrderedSame) 
        {
            _access_token = value;
            [defaults setObject:value forKey:@"TwitterAccessToken"];
        } 
        else if ([key compare:@"oauth_verifier"] == NSOrderedSame) 
        {
            _verifier = value;
            [defaults setObject:value forKey:@"TwitterVerifier"];
        }
    }
    
    // NSLog(@"_oauth_token=%@",_access_token);
    
    // 同期通信・アクセストークンゲット ログイン
    [self getAccessToken];
    //[self getPicture];
    
}






//
// タイムスタンプを取得します。
- (NSString *)get_timestamp
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    unsigned long long timestampVal = (unsigned long long) timeInterval;
    
    return [NSString stringWithFormat:@"%qu", timestampVal];
}

// nonceを取得します。
- (NSString *)get_nonce 
{
    // make a random 64-bit number
    
    unsigned long long nonceVal = ((unsigned long long) arc4random()) << 32
    | (unsigned long long) arc4random();
    
    return [NSString stringWithFormat:@"%qu", nonceVal];
}

/*
 // Base64エンコード
 - (NSMutableString *) Base64Encode_: (NSString *)_input
 {
 // 注意：出力の整形（1行76文字）は行なっていません。
 // 通常テーブル
 static const char *table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
 NSMutableString *input = [NSMutableString stringWithString:_input];
 int rest = [input length] % 3;
 
 if(rest != 0){
 NSString * tmp = [NSString stringWithString:@"\x0\x0\x0"];
 [input appendString:[tmp substringFromIndex:rest]];
 }
 
 //    NSInteger bytes = [input length];
 NSMutableString * output =[[[NSMutableString alloc] init] autorelease];
 
 for(int i=0; i<[input length]; i+=3){
 int threeBytes = 0;
 for(int j=0; j<3; j++){
 threeBytes = (threeBytes << 8) | [input characterAtIndex:(i + j)];
 }
 for(int j=18; j>=0; j-=6){
 [output appendString:[NSString stringWithFormat:@"%c", table[(threeBytes >> j) & 0x3f]]];
 }
 }
 
 if(rest != 0){
 NSInteger len = [output length];
 [output substringToIndex:len - rest];
 [output appendString:[@"===" substringFromIndex:rest]];
 }
 
 return output;
 }
 */

// Base64変換
- (NSString *)stringWithBase64ForData:(NSData *)data
{
    // Cyrus Najmabadi elegent little encoder from
    // http://www.cocoadev.com/index.pl?BaseSixtyFour
    if (data == nil) return nil;
    
    const uint8_t* input = [data bytes];
    NSUInteger length = [data length];
    
    NSUInteger bufferSize = ((length + 2) / 3) * 4;
    NSMutableData* buffer = [NSMutableData dataWithLength:bufferSize];
    
    uint8_t* output = [buffer mutableBytes];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger idx = (i / 3) * 4;
        output[idx + 0] =                    table[(value >> 18) & 0x3F];
        output[idx + 1] =                    table[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    NSString *result = [[[NSString alloc] initWithData:buffer
                                              encoding:NSASCIIStringEncoding] autorelease];
    return result;
}

//
- (NSString *)HmacSha1FromKey:(NSString*)key andBaseString:data
{
    NSMutableData *sigData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1,
           [key UTF8String], [key length],
           [data UTF8String], [data length],
           [sigData mutableBytes]);
    
    NSString *signature = [self stringWithBase64ForData:sigData];
    
    
    return [signature stringByURLEncoding2:NSUTF8StringEncoding]; // 英小文字パーセントエンコーディング
}

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//

//ボタンタッチテスト
- (void)modalButtonDidPush
{
    
    /*    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     _MDAC_UID=[defaults integerForKey:@"MDAC_UID"]; 
     if(_MDAC_UID>=1)
     {
     _MDAC_PASSCODE=[defaults stringForKey:@"MDAC_PASSCODE"]; 
     //
     _access_token=[defaults stringForKey:@"TwitterAccessToken"]; 
     _access_token_secret=[defaults stringForKey:@"TwitterAccessTokenSecret"]; 
     _verifier=[defaults stringForKey:@"TwitterVerifier"]; 
     
     _sns_id=[defaults stringForKey:@"TwitterSnsId"]; 
     _displayName=[defaults stringForKey:@"TwitterDisplayName"]; 
     
     
     // ログイン
     [self login];        
     return;
     }
     */    
    
    // リクエストトークン取得処理へ
    NSString *http_result = nil;    
    http_result = [self requestTokenGet];
    
    
    // 戻り値の解析    
    
    ///////////////////////
    // 中にオーサライズが必要
    ///////////////////////
    NSString *uri = [NSString stringWithFormat:TWITTER_AUTHORIZE_URL "?oauth_token=%@",_oauth_token];
    
    //NSLog(@"uri = %@", uri);
    
    _secondview->_authorize_uri = uri;
    _secondview->_response_uri = nil;
    _secondview->_params = nil;
    _secondview->_caller = self;
    [_secondview viewURLPage];
    
    //一番上の層に_login_vcを表示する
    // [self presentModalViewController:_login_vc animated:YES];
    
    
    
    
    
    // http_result = [self accessTokenGet];
    // 結果の確認
    // NSLog(@"\raccess=%@\r", http_result);
    
}
// 時間（タイムスタンプ・nonce）の更新
-(void)updateTime
{
    
    NSString *oauthNonce = [self get_nonce];
    _nonce = oauthNonce;
    NSString *oauthTimestamp = [NSString stringWithFormat:@"%d",(long)[[NSDate date] timeIntervalSince1970]];
    _timestamp = oauthTimestamp;
}



///////////////////////////////
// リクエストトークンを取得
-(NSString *)requestTokenGet
{
    NSString *http_result = nil;
    
    // Strings
    NSString *urlString = TWITTER_REQUEST_TOKEN_URL;
    NSString *urlEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString *oauthCallback = TWITTER_CALLBACK_URL;
    NSString *oauthConsumerKey =  TWITTER_CONSUMER_KEY;
    NSString *oauthConsumerSecret = TWITTER_CONSUMER_SECRET;
    [self updateTime];
    NSString *oauthSignatureMethod = @"HMAC-SHA1";
    NSString *oauthVersion = @"1.0";
    
    // Create base string and signature
    NSMutableString *baseString = [NSMutableString stringWithFormat:@"GET&%@&",urlEncoded];
    
    
    // コールバックURL無し
    // NSString *paramString = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",oauthConsumerKey,_nonce,oauthSignatureMethod,_timestamp,oauthVersion];
    
    
    // コールバックURL有り
    NSString *paramString = [NSString stringWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",[oauthCallback encodeString:NSUTF8StringEncoding],oauthConsumerKey,_nonce,oauthSignatureMethod,_timestamp,oauthVersion];
    
    
    NSString *paramStringEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)paramString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    [baseString appendString:paramStringEncoded];
    
    // シグネチャの生成
    NSString *sig_prm = [NSString stringWithFormat:@"GET&%@&%@",
                         urlEncoded,paramStringEncoded];
    
    
    
    NSString *secretEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)oauthConsumerSecret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString *signingKey = [NSString stringWithFormat:@"%@&",secretEncoded];
    
    NSString *oauthSignature = [self HmacSha1FromKey:signingKey andBaseString:baseString];    
    
    // Create request
    NSString *param = [NSString stringWithFormat: @"?"
                       "oauth_callback=%@&"
                       "oauth_consumer_key=%@&"
                       "oauth_nonce=%@&"
                       "oauth_signature=%@&"
                       "oauth_signature_method=%@&"
                       "oauth_timestamp=%@&"
                       "oauth_version=%@",
                       [oauthCallback encodeString:NSUTF8StringEncoding],
                       oauthConsumerKey,
                       _nonce,
                       oauthSignature,
                       oauthSignatureMethod,
                       _timestamp,
                       oauthVersion];
    
    // 同期アクセス
    urlString = [NSString stringWithFormat:@"%@%@", TWITTER_REQUEST_TOKEN_URL, param];
    //NSLog(@"*urlString:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    
    // ここで呼び出すと思われる
	NSURLResponse *response = nil;
    NSError       *error    = nil;
	
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response error:&error];
	http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding] autorelease];
    
    // 戻り値の解析
    NSArray *params = [http_result componentsSeparatedByString:@"&"];
    
    NSInteger cou = [params count];
    NSInteger i;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    for (i=0; i<cou; i++) 
    {
        NSString *tmp = [params objectAtIndex:i];
        NSArray *divs = [tmp componentsSeparatedByString:@"="];
        
        // パラメータ取得
        NSString *value = [[divs objectAtIndex:1] description];
        NSString *key = [[divs objectAtIndex:0] description];
        
        
        
        if ([key compare:@"oauth_token"] == NSOrderedSame) 
        {
            _oauth_token = value;
            [defaults setObject:value forKey:@"TwitterOauthToken"];
        } 
        else if ([key compare:@"oauth_token_secret"] == NSOrderedSame) 
        {   
            _oauth_token_secret = value;
            [defaults setObject:value forKey:@"TwitterOauthTokenSecret"];
        } 
        else if ([key compare:@"oauth_callback_confirmed"] == NSOrderedSame) 
        {
        }
    }
    
    return http_result;
}



// アクセストークンの取得 同期通信
-(NSString*) accessTokenGet
{
    
    //NSLog(@"_oauth_token=%@",_oauth_token);
    //NSLog(@"_oauth_token_secret=%@",_oauth_token_secret);
    //return nil;
    
    NSString *http_result = nil;
    
    // Strings
    NSString *urlString = [NSString stringWithString:TWITTER_ACCESS_TOKEN_URL];
    NSString *urlEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString *oauthConsumerSecret = [NSString stringWithString:TWITTER_CONSUMER_SECRET];
    
    
    NSString *oauthToken = [NSString stringWithString:_oauth_token];
    NSString *oauthTokenSecret = [NSString stringWithString:_oauth_token_secret];
    
    [self updateTime];
    
    NSString *oauthVerifier = [NSString stringWithString:_verifier];
    
    // Create base string and signature
    NSMutableString *baseString = [NSMutableString stringWithFormat:@"POST&%@&",urlEncoded];
    
    //
    NSString *paramString = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_token=%@&oauth_verifier=%@&oauth_version=1.0",
                             TWITTER_CONSUMER_KEY,
                             _nonce,
                             _timestamp,
                             oauthToken,
                             oauthVerifier];
    
    NSString *paramStringEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)paramString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    [baseString appendString:paramStringEncoded];
    
    
    
    NSString *sig_prm = [NSString stringWithFormat:@"POST&%@&%@",urlEncoded,paramStringEncoded];
    //NSLog(@"sig_prm:%@", sig_prm);
    
    // シグネチャの生成（文字列その３）
    NSString *c_secretEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)oauthConsumerSecret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);    
    NSString *tokenEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)oauthTokenSecret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@",c_secretEncoded, tokenEncoded];
    NSLog(@"key:%@", signingKey);
    
    NSString *oauthSignature = [self HmacSha1FromKey:signingKey andBaseString:baseString];
    NSLog(@"signature:%@", oauthSignature);
    
    // Create request
    NSString *authHeader = [NSString stringWithFormat: @"OAuth oauth_consumer_key=\"%@\",oauth_nonce=\"%@\",oauth_signature=\"%@\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"%@\",oauth_token=\"%@\",oauth_verifier=\"%@\",oauth_version=\"1.0\"",
                            TWITTER_CONSUMER_KEY,
                            _nonce,
                            oauthSignature,
                            _timestamp,
                            oauthToken,
                            oauthVerifier];
    
    // 同期アクセス
    urlString = [NSString stringWithString:TWITTER_ACCESS_TOKEN_URL];
    NSLog(@"*urlString:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"authHeader=%@", authHeader);
    
    // ここで呼び出すと思われる
	NSURLResponse *response = nil;
    NSError       *error    = nil;
	
    NSData *oauth_response = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response error:&error];
    // エラーコード取得
    //    NSLog(@"response=%@",response);
    //    NSLog(@"error=%@",error);
    
    http_result = [[[NSString alloc] initWithData:oauth_response encoding:NSUTF8StringEncoding] autorelease];
    
    
    // 戻り値の解析
    NSArray *params = [http_result componentsSeparatedByString:@"&"];
    
    NSInteger cou = [params count];
    NSInteger i;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    for (i=0; i<cou; i++) 
    {
        NSString *tmp = [params objectAtIndex:i];
        NSArray *divs = [tmp componentsSeparatedByString:@"="];
        
        // パラメータ取得
        NSString *value = [[divs objectAtIndex:1] description];
        NSString *key = [[divs objectAtIndex:0] description];
        
        if ([key compare:@"oauth_token"] == NSOrderedSame) 
        {
            // アクセストークン
            _access_token = value;
            [defaults setObject:value forKey:@"TwitterAccessToken"];
        } 
        else if ([key compare:@"oauth_token_secret"] == NSOrderedSame) 
        {
            // アクセストークン・シークレット
            _access_token_secret = value;            
            [defaults setObject:value forKey:@"TwitterAccessTokenSecret"];
        }
        else if ([key compare:@"user_id"] == NSOrderedSame) 
        {
            // ユーザーID
            _sns_id = value;
            [defaults setObject:value forKey:@"TwitterSnsId"];
        } 
        else if ([key compare:@"screen_name"] == NSOrderedSame) 
        {
            // スクリーンネーム
            _displayName = value;
            [defaults setObject:value forKey:@"TwitterDisplayName"];
        }
    }
    
    return http_result;
}





//--------------------------------------------------------------//
#pragma mark -- API --
//--------------------------------------------------------------//

// SNS(Twitter)にログインして、ユーザIDと画像を取ってきます。
// そして本システムに登録します。 

// ログインを行います。
- (void) login 
{
    NSLog(@"token:%@", _access_token);
    NSLog(@"token2:%@", _access_token_secret);
    NSLog(@"oauth:%@", _oauth_token);
    NSLog(@"oauthsercret:%@", _oauth_token_secret);
    
    //
    // Create base string and signature
    NSString *urlString = [NSString stringWithString:TWITTER_BASE_URL "account/verify_credentials.json"];
    NSString *urlEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSMutableString *baseString = [NSMutableString stringWithFormat:@"GET&%@&",urlEncoded];
    
    // nonceとtimestamp更新
    //[self updateTime];
    
    NSString *paramString = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0",
                             TWITTER_CONSUMER_KEY,
                             _nonce,
                             _timestamp,
                             _access_token];
    
    NSString *paramStringEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)paramString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    [baseString appendString:paramStringEncoded];
    
    
    
    NSString *sig_prm = [NSString stringWithFormat:@"GET&%@&%@",urlEncoded,paramStringEncoded];
    //    NSLog(@"sig_prm:%@", sig_prm);
    
    // シグネチャの生成（文字列その３）
    NSString *c_secretEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_client_secret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);    
    NSString *tokenEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_access_token_secret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@",c_secretEncoded, tokenEncoded];
    //    NSLog(@"key:%@", signingKey);
    
    NSString *oauthSignature = [self HmacSha1FromKey:signingKey andBaseString:baseString];
    //    NSLog(@"signature:%@", oauthSignature);
    
    
    //    もどしたとこ
    // Create request
    NSString *authHeader = [NSString stringWithFormat: @"oauth_consumer_key=\"%@\",oauth_nonce=\"%@\",oauth_signature=\"%@\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"%@\",oauth_token=\"%@\",oauth_version=\"1.0\"",
                            TWITTER_CONSUMER_KEY,
                            _nonce,
                            oauthSignature,
                            _timestamp,
                            _access_token];
    
    
    
    
    // Twitterから自分の情報を取ってくる
    NSString * urlString2 = [NSString stringWithFormat: @"%@?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0",
                             urlString,
                             TWITTER_CONSUMER_KEY,
                             _nonce,
                             oauthSignature,
                             _timestamp,
                             _access_token];
    
    
    
    
    NSURL *url = [NSURL URLWithString: urlString2];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    
    //もどしたとこ    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"OAuth %@", authHeader] forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
    //
    NSLog(@"url=%@",url);
    NSLog(@"url=%@",urlString);
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    
    
    request = [NSMutableURLRequest requestWithURL:url];
    
    
    result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    json = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"json=%@",json);    
    // SBJsonを使った解析
    NSDictionary * restmp = [json JSONValue];
    
    
    NSLog(@"displayName=%@", [restmp objectForKey:@"name"]);
    NSLog(@"thumbnailUrl=%@", [restmp objectForKey:@"profile_image_url"]);
    NSLog(@"id=%@", [restmp objectForKey:@"id"]);
    
    
    // 結果をしまっておく
    _displayName = [restmp objectForKey:@"name"];
    _thumbnailUrl = [restmp objectForKey:@"profile_image_url"];
    _sns_id = [restmp objectForKey:@"id"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_displayName forKey:@"TwitterName"];//twitter専用名を保存
    // 画像アイコンDL
	NSURL *url_img = [NSURL URLWithString:_thumbnailUrl];
	NSData *data = [NSData dataWithContentsOfURL:url_img];
    if (data == nil) 
    {
        // エラー処理
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"twitter error"
                              message:_thumbnailUrl//@"ユーザー情報を読み込めません"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];  
        
        return;
    }
    
    
	_user_icon = [[UIImage alloc] initWithData:data];
    
    
    
    
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:_user_icon] autorelease];
    //    imageView.center = [self view].center;　// メインのウインドウの中心に置く
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
    if (photo == nil) 
    {
        // エラー処理
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"load error"
                              message:@"ユーザーアイコンを読み込めません"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        return;
    }
    
    NSLog(@"Twitter画像URL=%@",_thumbnailUrl);
    NSLog(@"渡す画像URL=%@",url_img);
    // コンテンツの作成
    // マルチパートアップロード
    //NSLog(@"画像アップロード");
    
    
    // バウンダリ設定
    NSString *boundary = [NSString stringWithString:@"--meets-dogs-and-cats--"];
    
    NSMutableData* result_ = [[NSMutableData alloc] init];
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"post_image\"; filename=\"%d.jpg\"\r\n\r\n", _MDAC_UID] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSASCIIStringEncoding]];//m
    
    [result_ appendData:photo];
    
    [result_ appendData:[[NSString stringWithFormat:@"%@", @"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uid\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", _MDAC_UID]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];   // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pass_code\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%@\r\n", _MDAC_PASSCODE]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];  
    // バウンダリ
    
    //
    [result_ appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"size\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [result_ appendData:[[NSString stringWithFormat:@"%d\r\n", [photo length] ]
                         dataUsingEncoding:NSASCIIStringEncoding]];
    
    // バウンダリの終端
    [result_ appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    // リクエストの作成
    url = [NSURL URLWithString:DATA_SERVER_URL"gw/userImage"];
    //url = [NSURL URLWithString:IMAGE_SERVER_URL];
    
    NSLog(@"サーバーURL=%@",url);
    
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
    
    for (NSString *str in dic) 
    {
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
        snsName=@"twitter";
        [defaults setObject:snsName forKey:@"SNS_NAME"];  
    }
    if([defaults objectForKey:@"MAIN_NAME"]==nil)
    {
        [defaults setObject:_displayName forKey:@"MAIN_NAME"];
    }
    
    
    
#if 0    
    // SBJSONを使ったJSONデータのパース処理
    for (NSDictionary *dic in result) 
    {
        //        NSArray *tmpArray = [[dic count ]inde objectForKey:@"result"];
        NSLog(@"---");
        //        NSLog(@"items=%d", [dic count]);        
        
        //        NSLog(@"%@", [dic objectForKey:@"post_image_id"]);
        //        NSLog(@"%@", [dic objectForKey:@"image_id"]);
        NSLog(@"%@", [dic objectForKey:@"real_path"]);
    }
#endif
}


//sns連携
- (void)postMessage:(NSString *)updateText
{
    
    //140字切り詰め
    if ([updateText length] > 140)
    {
        updateText = [updateText substringToIndex:140];
    }
    
    
    NSString *encodeMessage= [updateText encodeString:NSUTF8StringEncoding];
    //投稿データ
    // NSString *bodyString = [NSString stringWithFormat:@"status=%@",
    //                       (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                                          (CFStringRef)updateText,NULL,NULL,kCFStringEncodingUTF8)]; 
    
    NSString *bodyString=[NSString stringWithFormat:@"status=%@",encodeMessage];
    
    
    // アクセストークン、シークレット取得
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _access_token=[defaults stringForKey:@"TwitterAccessToken"];
    _access_token_secret=[defaults stringForKey:@"TwitterAccessTokenSecret"];
    
    
    //update URL
    NSString *urlString =@"https://api.twitter.com/1/statuses/update.json";
    
    
    
    NSString *urlEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSMutableString *baseString = [NSMutableString stringWithFormat:@"POST&%@&",urlEncoded];
    
    
    [self updateTime];
    
    NSString *paramString = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0&%@",
                             TWITTER_CONSUMER_KEY,
                             _nonce,
                             _timestamp,
                             _access_token,
                             bodyString];
    
    NSString *paramStringEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)paramString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    
    [baseString appendString:paramStringEncoded];
    
    
    
    NSString *sig_prm = [NSString stringWithFormat:@"POST&%@&%@",urlEncoded,paramStringEncoded];
    
    NSLog(@"sig_prm:%@", sig_prm);
    
    NSString *c_secretEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)TWITTER_CONSUMER_SECRET, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);    
    NSString *tokenEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_access_token_secret, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@",c_secretEncoded, tokenEncoded];
    //    NSLog(@"key:%@", signingKey);
    
    NSString *oauthSignature = [self HmacSha1FromKey:signingKey andBaseString:baseString];
    NSLog(@"signature:%@", oauthSignature);
    
    
    NSString *authHeader = [NSString stringWithFormat: @"OAuth oauth_consumer_key=\"%@\",oauth_nonce=\"%@\",oauth_signature=\"%@\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"%@\",oauth_token=\"%@\",oauth_version=\"1.0\"",
                            TWITTER_CONSUMER_KEY,
                            _nonce,
                            oauthSignature,
                            _timestamp,
                            _access_token];
    
    
    
    NSURL *url = [NSURL URLWithString: urlString];    
    
    
    NSLog(@"authHeader   %@",authHeader);
    
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    
    NSDictionary * restmp = [json JSONValue];
    
    //結果
    NSLog(@"restmp %@",restmp);
    
}



@end
