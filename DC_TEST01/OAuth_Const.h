//
//  OAuth_Const.h
//  DC_TEST01
//

#ifndef DC_TEST01_OAuth_Const_h
#define DC_TEST01_OAuth_Const_h

// マクロ
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:1.0];

// Admob関連
#define	MY_BANNER_UNIT_ID	@"a14ea53e6d6b1f4" // 本アプリのパブリッシャーID
#define ANIMATION_DURATION	0.5f
#define TABBAR_HEIGHT		49.0f

#if DEBUG
// テストサーバの定義
#define DATA_SERVER_URL @"http://stage.mdac.me/"//本番@"http://mdac.me/"
#define IMAGE_SERVER_URL @"http://pic.mdac.me/upload_t/"//本番@"http://pic.mdac.me/upload/"
#define CV_SERVER_URL @"http://img.mdac.me"//本番@"http://mdac.me/"
#define USER_SERVER_URL @"http://pic.mdac.me"//本番@"http://pic.mdac.me"

#endif

//
#define MIXI_LOGIN_URI @"https://mixi.jp/connect_authorize.pl"
#define MIXI_TOKEN_URI @"https://secure.mixi-platform.com/2/token"
#define MIXI_API_URI   @"http://api.mixi-platform.com/2/"

#if DEBUG
// mixi テスト用
// meet本来の値のはず
#define MIXI_CONSUMER_KEY	@"1ee0619f2d3a5c840d7e"

#else

// mixi 本番用
#define MIXI_CONSUMER_KEY	 @"6yayqicFuQreSwCfnRfbA"
#define MIXI_CONSUMER_SECRET @"f937c95c69203171ab6c3d0292d4ce43"

#endif

// mixi 共通版
#define MIXI_CONSUMER_SECRET    @"87ee73bbf06a703b96800e475e37cdd855d64610"
#define MIXI_CALLBACK_URL       @"https://mixi.jp/connect_authorize_success.html"

#if DEBUG

// twitter テスト用
//#define TWITTER_CONSUMER_KEY    @"6yayqicFuQreSwCfnRfbA"
//#define TWITTER_CONSUMER_SECRET @"JZqLzML66iOHPko3clX2buC9T3xgE4qbH2Ay9yZ3Xvg"

#define TWITTER_CONSUMER_KEY    @"MAmfrKc0ZIx8eJK46HsMVA"
#define TWITTER_CONSUMER_SECRET @"cuCnelGhuMH3mXwc134w5ZarPr2KbWLJA5vU4sdUXBo"


#define TWITTER_CALLBACK_URL    @"http://www.cybermuse.co.jp/fake_twitter_callback.php"
//#define TWITTER_CALLBACK_URL    @"http://stage.mdac.me/gw/getPostImageByNew/category:0,1/offset:0/limit:10"

#endif

#define TWITTER_REQUEST_TOKEN_URL   @"https://api.twitter.com/oauth/request_token"
#define TWITTER_AUTHORIZE_URL       @"https://api.twitter.com/oauth/authenticate"
#define TWITTER_ACCESS_TOKEN_URL 	@"https://api.twitter.com/oauth/access_token"
#define TWITTER_API_URL             @"https://api.twitter.com/oauth/"
#define TWITTER_BASE_URL            @"https://api.twitter.com/"


#if DEBUG
// facebook テスト用
//#define FACEBOOK_APP_ID     @"183849395033618"
//#define FACEBOOK_APP_SECRET @"3bd057e90e02365b53cd6b4a82b21157"
#define FACEBOOK_APP_ID     @"187679104634076"
#define FACEBOOK_APP_SECRET @"94b840b4b935c0a5d7f5a9dde934b3d5"

#else

// facebook 本番用
//#define FACEBOOK_APP_ID     @"242306612473219"
//#define FACEBOOK_APP_SECRET @"3f32bc424379615ee36b8f2bc482ea86"

#endif

// facebook 共通設定
#define FACEBOOK_AUTH_URL   @"https://m.facebook.com/dialog/oauth"
//#define FACEBOOK_AUTH_URL   @"https://www.facebook.com/dialog/oauth"
#define FACEBOOK_API_URL    @"https://graph.facebook.com/"
#define FACEBOOK_REQUEST_URL @"https://www.facebook.com/dialog/permissions.request"
#define FACEBOOK_TOKEN_CALLBACK_URL @"https://www.facebook.com/connect/login_success.html"
//#define FACEBOOK_TOKEN_CALLBACK_URL @"http://mdac.me/callback/facebook_callback.php"

#endif  // DC_TEST01_OAuth_Const_h
