//
//  FirstViewController.m
//  DC_TEST01
//
#include <QuartzCore/CALayer.h>

#import "NSString+Encode.h"

#import "SFHFKeychainUtils.h"

#import "FirstViewController.h"
#import "MDC_NavigationBar.h"

#import "TOPScrollView.h"

// マクロ
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:1.0];

// Admob関連
#define	MY_BANNER_UNIT_ID	@"a14ea53e6d6b1f4" // 本アプリのパブリッシャーID
#define ANIMATION_DURATION	0.5f
#define TABBAR_HEIGHT		49.0f


// テストサーバの定義
#define DATA_SERVER_URL @"http://stage.mdac.me/"
#define IMAGE_SERVER_URL @"http://pic.mdac.me"
#define CV_SERVER_URL @"http://img.mdac.me"
#define USER_SERVER_URL @"http://pic.mdac.me"
// パスワードのサービスネーム
#define SERVICE_NAME @"DC_TEST01 App"

UIViewController * _vc;

// Obj-C
@implementation FirstViewController

@synthesize _scrollView;
@synthesize myImage;

@synthesize mToken_Twitter;
@synthesize mTokenSecret_Twitter;
@synthesize mUserID_Twitter;

// 暗号化記録の取得
+ (NSString *) getSetting: (NSString *)name
{
    NSError *error;
    return [SFHFKeychainUtils getPasswordForUsername:name andServiceName:SERVICE_NAME error: &error];
}

// ViewController取得
+ (UIViewController *) getViewController 
{
    return _vc;
}

- (DC_TEST01AppDelegate *) getAppDelegate 
{
    // デリゲートのポインタを取得している
    return (DC_TEST01AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// 暗号化記録の設定
- (void) setSetting: (NSString *)name data:(NSString *)dat;
{
    NSError *error;
    [SFHFKeychainUtils storeUsername:name andPassword:dat 
                forServiceName:SERVICE_NAME updateExisting:YES error: &error];
 }

// URLとパラメータをエンコードしてNSStringを返す
- (NSString *) getEncodedURL : (NSString *)urlString prm:(NSString *)prmString
{
    // 引数エンコード
    NSString *encodeString = [prmString encodeString:NSUTF8StringEncoding];
    // サーバに渡すＵＲＬ文字列
    return [NSString stringWithFormat:@"%@%@",urlString, encodeString];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    _vc = self;

    // パラメータ読み込み
    mToken_Twitter = [FirstViewController getSetting: @"token"];
    if (mToken_Twitter != nil) {
        NSLog(@"mToken='%@'", mToken_Twitter);
    } /* else {
        mToken_Twitter = @"";
    }
       */
    
    // ScrollViewの設定
    _scrollView.backgroundColor = HEXCOLOR(0xf2ceb1);   // 背景色の設定
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];  
//    [self setMyImage:img];  
    
    _scrollView.pagingEnabled = NO;  
//    _scrollView.contentSize = CGSizeMake(img.frame.size.width, img.frame.size.height+40);
    _scrollView.contentSize = img.bounds.size;
    _scrollView.showsHorizontalScrollIndicator = NO;  
    _scrollView.showsVerticalScrollIndicator = YES;  
    _scrollView.scrollsToTop = YES;  
//    _scrollView.delegate = self;  
    
    [_scrollView addSubview: img];  
    [img release];  
    
    // ナビゲーションバーを生成
    MDC_NavigationBar* navBarTop = [[MDC_NavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    navBarTop.alpha = 1.0f;
    /*    
     // ナビゲーションアイテムを生成
     UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"Title"];
     
     // 戻るボタンを生成
     UIBarButtonItem* btnItemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack:)];
     
     // ナビゲーションアイテムの右側に戻るボタンを設置
     title.rightBarButtonItem = btnItemBack;
     
     // ナビゲーションバーにナビゲーションアイテムを設置
     [navBarTop pushNavigationItem:title animated:YES];
     */   
    // ビューにナビゲーションアイテムを設置
//    [self.view addSubview:navBarTop];

    
    // imageviewの生成とサブビュー追加
    UIImageView *imageView;
    UIImage *image;
    image = [[UIImage imageNamed:@"navi.png"]
             stretchableImageWithLeftCapWidth:0 topCapHeight:1];
    imageView = [[UIImageView alloc] initWithImage:image];
    [imageView autorelease];
    
    imageView.frame = navBarTop.bounds;
    imageView.autoresizingMask = (
                                  UIViewAutoresizingFlexibleWidth
                                  | UIViewAutoresizingFlexibleHeight);
    imageView.layer.zPosition = -FLT_MAX;

    if([navBarTop respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) 
    {
        //iOS 5 new UINavigationBar custom background
        [navBarTop setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    } 
    else 
    {
        // iOS4
        [navBarTop insertSubview:imageView atIndex:0];
    }
    
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:navBarTop];

/*    
    // ナビゲーションバーに載せるボタンの色
    UIColor *tintColor;
    tintColor = [UIColor
                 colorWithHue:0.774
                 saturation:0.521
                 brightness:0.618
                 alpha:1.000];
    navBarTop.tintColor = tintColor;
 */    
    
/*    
    // OAuth処理 (Twitter)
    GTMOAuthAuthentication *auth = [self twitterAuth];
    // signed in
    [self signInTwitterWithAuth:auth];
 */   

    // パブリックタグを取得
//    [self getPublicTagList];
    
    // テスト表示
    
    [self getPickupPicture];
    [self getRankingPicture :0];
    [self getRankingPicture :1];
    [self getRankingPicture :2];
    [self getRankingPicture :3];
    [self getRankingPicture :4];

//    http://www.awaresoft.jp/ios-dev/item/90-gtmoauthでtwitterなどのoauthを行う方法.html
    
}

// ラベルを書き込む
-(void)putLabel: (NSString *)str rect:(CGRect)rect size:(NSInteger)fsize align:(UITextAlignment) talign
{
    // ピックアップコメント
    UILabel *label = [[UILabel alloc] init];
    
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setNumberOfLines:0];
    label.font = [UIFont fontWithName:@"AppleGothic" size:fsize];
    label.backgroundColor = [UIColor clearColor];
    //label.backgroundColor = [UIColor whiteColor];
    label.textColor = HEXCOLOR(0x82593b);
    
    label.frame = rect;
    label.textAlignment = talign;
    [label setText:str];
    if (talign != UITextAlignmentRight) {
        [label sizeToFit];
    }
    
    [_scrollView addSubview:label];
    [label release];
    
}

// ピックアップ画像をテスト表示
- (void)getPickupPicture
{
    // JSONテスト
    // pickupの取得
    // URL
    NSString *urlString = DATA_SERVER_URL "gw/getPickup/category:";
    // 引数
    NSString *paramString = @"0,1";
    // 引数エンコード
    NSString *encodeString = [paramString encodeString:NSUTF8StringEncoding];
    // サーバに渡すＵＲＬ文字列
    //    NSString *urlString2 = [[[self getEncodedURL] urlString prm:paramString]];
    
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",urlString, encodeString];
    
    // サーバアクセス
    NSURL *url = [NSURL URLWithString:urlString2];
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // アクセスＵＲＬ表示
    NSLog(@"urlString2=%@", urlString2);
    
    // SBJsonを使った解析
    NSDictionary * restmp = [jsonString JSONValue];
    NSLog(@"%@", restmp);
    
    //
    NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:0];
    
    // SBJSONを使ったJSONデータのパース処理
    for (NSDictionary *dic in result) 
    {
        //        NSArray *tmpArray = [[dic count ]inde objectForKey:@"result"];
        NSLog(@"---");
        //        NSLog(@"items=%d", [dic count]);        
        
        //        NSLog(@"%@", [dic objectForKey:@"post_image_id"]);
        //        NSLog(@"%@", [dic objectForKey:@"image_id"]);
        NSLog(@"%@", [dic objectForKey:@"real_path"]);
        
        // イメージの描画テスト
//        UIImageView *img2 = [[[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.0, 100.0, 100.0)] autorelease];
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.0, 100.0, 100.0)];
        img2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        // 画像変換サーバで縮小
        NSString *urlString = [NSString stringWithFormat:CV_SERVER_URL "%@?sr.dw=100&sr.dh=100&sr.cx=2&sr.cy=2",
                               [dic objectForKey:@"real_path"]];
        url = [NSURL URLWithString: urlString];
        NSData *data = [NSData dataWithContentsOfURL: url];
        img2.image = [UIImage imageWithData: data];
        // イメージの回転
        CGAffineTransform rotate = CGAffineTransformMakeRotation(3.0f * (M_PI / 180.0f));
        [img2 setTransform:rotate];
        
        [_scrollView addSubview: img2];        
        [img2 release];  
        
        // ピックアップコメント
        [self putLabel: [dic objectForKey:@"comment"] rect:CGRectMake(152, 54, 144, 50) size:10 align:UITextAlignmentLeft];
        // 投稿者の名前
        NSString *nameString = [NSString stringWithFormat:@"by %@",[dic objectForKey:@"name"]];
        [self putLabel:nameString rect:CGRectMake(180, 86, 112, 12) size:9 align:UITextAlignmentRight];
    }
    

}

// ランキング画像をテスト表示
- (void)getRankingPicture : (NSInteger) kind
{
    // JSONテスト
    // pickupの取得
    // URL
//    NSString *urlString = DATA_SERVER_URL "gw/getPostimageByNew/category:0/offset:0/limit:";
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByNew/category:0/offset:%d/limit:",
                           kind*3];
    // 引数
    NSString *paramString = @"3";
    // 引数エンコード
    NSString *encodeString = [paramString encodeString:NSUTF8StringEncoding];
    // サーバに渡すＵＲＬ文字列
    //    NSString *urlString2 = [[[self getEncodedURL] urlString prm:paramString]];
    
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",urlString, encodeString];
    // サーバアクセス
    NSURL *url = [NSURL URLWithString:urlString2];
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // アクセスＵＲＬ表示
    NSLog(@"PickupurlString2=%@", urlString2);
    
    // SBJsonを使った解析
    NSDictionary * restmp = [jsonString JSONValue];
    NSLog(@"%@", restmp);
    
    //
//    NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:0];
    
    NSInteger count = 0;
    CGFloat x = 5.0f;
    CGFloat y = 150 + (kind * 148);
    
    // SBJSONを使ったJSONデータのパース処理
//    for (NSDictionary *dic in result) {
    for (int i=0; i<3; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            NSLog(@"---");
        //        NSLog(@"items=%d", [dic count]);        
        
        //        NSLog(@"%@", [dic objectForKey:@"post_image_id"]);
        //        NSLog(@"%@", [dic objectForKey:@"image_id"]);
            NSLog(@"%@", [dic objectForKey:@"real_path"]);
        
            // イメージの描画テスト
            UIImageView *img2 = [[[UIImageView alloc] initWithFrame:CGRectMake(x, y, 100.0, 100.0)] autorelease];
            img2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            // 画像変換サーバで縮小
            NSString *urlString = [NSString stringWithFormat:CV_SERVER_URL "%@?sr.dw=100&sr.dh=100&sr.cx=2&sr.cy=2",
                                   [dic objectForKey:@"real_path"]];
            url = [NSURL URLWithString: urlString];
            NSData *data = [NSData dataWithContentsOfURL: url];
            img2.image = [UIImage imageWithData: data];
        
            [_scrollView addSubview: img2];        
            //        [img2 release];  
        
            x += 105.0f;
        
            if ((++count) >= 3) {
                break;
            }
        }
    }
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [self set_scrollView:nil];
    [_scrollView release];
    _scrollView = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [myImage release];  
    [super dealloc];
}


@end
