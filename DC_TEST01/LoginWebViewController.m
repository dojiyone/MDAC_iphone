//
//  LoginWebViewController.m
//  MixiOAuth
//
#import "MixiTestViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "LoginWebViewController.h"

@class MixiTestViewController;
@class FBTestViewController;
@class TwTestViewController;
@class UIWebviewDelegate;

@implementation LoginWebViewController

// プロパティ
@synthesize authorize_uri = _authorize_uri;
@synthesize response_uri = _response_uri;
@synthesize web_view = _web_view;
@synthesize caller = _caller;
@synthesize webview_delegate = _webview_delegate;
@synthesize params = _params;
@synthesize pin = _pin;


//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

// ダミー初期化
- (id) init
{
    
    self = [super init];
    if (!self) {
        // 初期化失敗
        return nil;
    }
    // ここからがカスタムコード
    
    
    //   _sheardInstance = self;
    return self;
}

// こっちから飛んでくる
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"WebViewController::initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"modal closed.");

    if ([[_caller stat] compare:@"tw"] == NSOrderedSame) 
    {
        // ツイッターの場合は、TwTestViewにその後の処理を移譲

        
        [_caller getAccessToken];
    }
 
    
    //
    [_authorize_uri release], _authorize_uri = nil;
    [_response_uri release], _response_uri = nil;
    [_web_view release], _web_view = nil;
    _caller = nil;
    _webview_delegate = nil;
    [_params release], _params = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------//
#pragma mark -- ビュー --
//--------------------------------------------------------------//

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //NSLog(@"WebView::viewDidLoad");
  
    _web_view = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    _web_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _web_view.scalesPageToFit = YES;
    _web_view.delegate = (id) _webview_delegate;
    
    [self.view addSubview:_web_view];
/*    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mixi.jp/connect_authorize.pl?client_id=829f4b5fa305ec88e576&response_type=code&scope=r_voice&display=touch&state=first"]];
 */
    

    
    //test
    //NSURLRequest *request =[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_authorize_uri]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_authorize_uri]];
    [_web_view loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    _web_view.delegate = nil;
    [_web_view stopLoading];
    [_web_view release], _web_view = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//
- (void) endLoading:(NSMutableString *)page 
{ 
//    [self resetWebView];
/*    
    NSLog(@"FeedViewController: endLoading");
    [_web_view loadHTMLString:page 
                      baseURL:[NSURL URLWithString:@""]];
 */
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

/*
// エラーが起きた場合
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"=== WebView::didFailLoadWithError");

    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"error='%@'", error);
    // Webのロードを止める
    [self.web_view stopLoading];

    NSLog(@"domain='%@'", error.domain);
#if 0    
    if (error.code == 101 && [error.domain hasPrefix:@"WebKitErrorDomain"]) {
        // エラーの先を無理矢理替える
        NSDictionary *dic = error.userInfo;
        NSMutableString *str = [dic objectForKey:@"NSErrorFailingURLKey"];
        NSMutableString *str2 = [NSMutableString stringWithFormat:@"%@", str];

        // ある一定の文字列の長さ以上で、プレフィクスがmeetのものだったら
        NSString *scheme = MIXI_CALLBACK_URL_MEET;
        if (str2.length >= scheme.length && [str2 hasPrefix:MIXI_CALLBACK_URL_MEET]) {
            // 先頭を削る
            [str2 deleteCharactersInRange:NSMakeRange(0, scheme.length)];      // 先頭のスキームを削る
            [str2 insertString:MIXI_CALLBACK_URL atIndex:0];
            NSLog(@"*str2='%@'", str2);
            // 飛び先をリダイレクト
            [self webRedirect: str2];
        }
        return;
    }
 }
    // 他のエラー処理を入れる
    //
}
#endif
*/

//
 /*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"WebView::shouldStartLoadWithRequest");    
    return YES;
}

//
- (void)webViewDidStartLoad:(UIWebView *)webView
{

    NSLog(@"WebView::webViewDidStartLoad");
}
  */
    
// 戻り値がURLに来るとき用のパース
// _sep は区切り記号
-(void)parseQuery: (NSString *)urlstring sep:(NSString *)_sep
{
    NSRange search_result = [urlstring rangeOfString:urlstring];
    
    if (search_result.location != NSNotFound) {
        NSArray* components = [urlstring componentsSeparatedByString:_sep];
        
        if ([components count] > 1) 
        {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            for (NSString *query in [[components lastObject] componentsSeparatedByString:@"&"]) 
            {
                NSArray *keyAndValues = [query componentsSeparatedByString:@"="];
                [parameters setObject:[keyAndValues objectAtIndex:1] forKey:[keyAndValues objectAtIndex:0]];
            }
            
#if DEBUG            
            // 戻り値のテスト
            NSLog(@"***parseQuery:戻り値のテスト***");
            for (NSString *str in parameters) 
            {
                NSLog(@"%@=%@", str, [parameters valueForKey:str]);
            }
            NSLog(@"*****************");
#endif            
            // 戻り値（アクセストークン）取得
            if ([parameters valueForKey:@"code"]) 
            {
                // authorization_codeを取得
                if ([_caller respondsToSelector:@selector(parse_authorization_code:)]) 
                {
                    [_caller parse_authorization_code:[parameters valueForKey:@"code"]];
                }
            } 
            
            if ([parameters valueForKey:@"error"]) 
            {
                // errorを取得
                if ([_caller respondsToSelector:@selector(parse_access_denied:)]) 
                {
                    [_caller parse_access_denied:[parameters valueForKey:@"error"]];
                }
            } 
            else if ([parameters valueForKey:@"state"]) 
            {
                // stateを取得
                if ([_caller respondsToSelector:@selector(parse_state:)]) 
                {
                    [_caller parse_state:[parameters valueForKey:@"state"]];
                }
            } 
            else if ([parameters valueForKey:@"access_token"]) 
            {
                // FBのアクセストークンを取得
                if ([_caller respondsToSelector:@selector(parse_access_token:)]) 
                {
                    [_caller parse_access_token:[parameters valueForKey:@"access_token"]];
                }
            } 
            /* else  if ([parameters valueForKey:@"oauth_verifier"]) {
                // Twitterのverifuerを取得
                if ([_caller respondsToSelector:@selector(parse_verifier:)]) {
                    [_caller parse_verifier:[parameters valueForKey:@"oauth_verifier"]];
                }
            } */
        }
    }
   
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"WebView::webViewDidFinishLoad");

    // アクセスインジケータ停止
    //    [activityIndicator stopAnimating];
    
    int loadcheck=0;
    
    // ロード終わり
    NSString* urlstring = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"*urlstring='%@'", urlstring);
    
    // ロード内容をパース
    if ([urlstring hasPrefix:MIXI_CALLBACK_URL "?state=mixi&code="]) 
    {
        loadcheck=1;
        //////////
        // mixi
        //////////
        // URLからパラメータを取得
        [self parseQuery: urlstring sep:@"?"];
        
        // 同期通信・トークンゲット
        [(MixiTestViewController *)_caller accessTokenGet];
        
        // ログイン
        [_caller login];
    } 
    else if ([urlstring hasPrefix:FACEBOOK_REQUEST_URL "?"]) 
    {
        loadcheck=2;
        /////////////
        // facebook
        /////////////
        [self parseQuery: urlstring sep:@"?"];
    }
    else if ([urlstring hasPrefix:FACEBOOK_TOKEN_CALLBACK_URL "#"]) 
    {
        loadcheck=3;
        /////////////
        // facebook
        /////////////
        // URLからパラメータを取得
        [self parseQuery:urlstring sep:@"#"];
        
        // 同期通信・トークンゲット
        [(FBTestViewController *)_caller accessTokenGet];
        
        // ログイン
        [(FBTestViewController *)_caller login];
    }
//#ifndef TWITTER_CALLBACK_URL                
        ////////////////
        // twitter PIN
        ////////////////
    else if ([urlstring hasPrefix:TWITTER_AUTHORIZE_URL]) 
    {

        // HTMLを取得
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        //      NSLog(@"---- html begin ----\r%@---- html end ----", html);

        
        //文字列内で、PINコード文字列を検索
        NSRange searchResult1 = [html rangeOfString:@"<code>"];
        if (searchResult1.location == NSNotFound) 
        {
            loadcheck=41;         
        } 
        else
        {
            NSRange searchResult2 = [html rangeOfString:@"</code>"];
            if (searchResult2.location == NSNotFound) 
            {
                
                loadcheck=42;
            } 
            else
            {
                loadcheck=43;
                // コード見つかった
                NSInteger begin = searchResult1.location+searchResult1.length;
                NSInteger len = searchResult2.location - begin;
                self.pin = [html substringWithRange:NSMakeRange(begin,len)];
                            
                // URLからパラメータを取得
                // [self parseQuery:urlstring sep:@"?"];
               // [(TwTestViewController *)_caller parse_verifier:self.pin];

              //[(TwTestViewController *)_caller accessTokenGet];//もどした
                
                // ログイン
              //[(TwTestViewController *)_caller login];//もどした

            }
        }

    }
//#else
    else if ([urlstring hasPrefix:TWITTER_CALLBACK_URL]) 
    {
        loadcheck=5;
        
         
        
        _web_view.delegate = nil;
        [_web_view stopLoading];
        [_web_view release], _web_view = nil;
        
        
        ////////////////////
        // twitter Callback
        ////////////////////
       // NSLog(@"callback=%@", urlstring);
        NSArray* components = [urlstring componentsSeparatedByString:@"?"];
        if ([components count] > 1) 
        {
            [(TwTestViewController *)_caller parse_callback_param:[[components objectAtIndex:1] description]];
            
        }

    }
    /*
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"load check"
                          message: [NSString stringWithFormat:@"%d", loadcheck]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
     */
//#endif
}






@end
