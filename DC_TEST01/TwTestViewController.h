//
//  TwTestViewController.h
//  mixitest
//
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonHMAC.h>


#import "SecondViewController.h"

@interface TwTestViewController : SecondViewController 
{
@public
    
    SecondViewController *_secondview;
    
    NSString *_client_id;
    NSString *_client_secret;
    NSString *_stat;
    NSString *_redirect_uri;
    
    //NSString *_request_token;
    NSString *_oauth_token;
    NSString *_oauth_token_secret;
    NSString *_expires_in;
    NSString *_access_token;
    NSString *_access_token_secret;
    
    NSString *_verifier;
    
    NSString *_timestamp;
    NSString *_nonce;
    
    NSString *_error_code;
    
    UIImage * _user_icon;
    
    //SecondViewController * login_vc;    
    
    // Twitter固有のログインデータ
    NSString *_displayName;     // ディスプレイ名
    NSString *_thumbnailUrl;    // サムネイルURL
    NSString *_sns_id;              // ID
    
    // mdacユーザーID等
    NSInteger _MDAC_UID;         // ユニークID
    NSString  *_MDAC_PASSCODE;   // パスコード
}

// プロパティ
@property (nonatomic, retain) NSString *client_id;
@property (nonatomic, retain) NSString *client_secret;
@property (nonatomic, retain) NSString *stat;
@property (nonatomic, retain) NSString *redirect_uri;

@property (nonatomic, retain) NSString *oauth_token;
@property (nonatomic, retain) NSString *oauth_token_secret;
@property (nonatomic, retain) NSString *request_token;
@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *access_token_secret;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *expires_in;
@property (nonatomic, retain) NSString *verifier;
@property (nonatomic, retain) NSString *error_code;
@property (nonatomic, retain) UIImage *user_icon;


//
//@property (nonatomic, retain) SecondViewController *login_vc;

//
@property (nonatomic, assign) NSInteger MDAC_UID;        // MeetユニークID
@property (nonatomic, retain) NSString* MDAC_PASSCODE;   // Meetパスコード

// mixi固有のログインデータ
@property (nonatomic, retain) NSString *displayName;     // ディスプレイ名
@property (nonatomic, retain) NSString *thumbnailUrl;    // サムネイルURL
@property (nonatomic, retain) NSString *sns_id;          // SNSのID

// mdacへのアクセスラッパー
// API
- (void) login;
- (void) createUser : (NSString *) name;

//
- (void)modalButtonDidPush:(id)sender;

- (void)getAccessToken;


- (void)parse_access_denied:(NSString *)error_code;
- (void)parse_callback_param:(NSString *)prm;
- (void)modalButtonDidPush;

- (NSString *)get_timestamp;
- (NSString *)get_nonce;

//
//- (NSMutableString *) Base64Encode_: (NSString *) input;
- (NSString *) stringWithBase64ForData:(NSData *)data;

- (NSString *)HmacSha1FromKey:(NSString*)key andBaseString:data;

-(void)updateTime;

//
-(NSString *) requestTokenGet;
-(NSString *) accessTokenGet;
- (void) clientDataSetting;
- (void)postMessage:(NSString *)updateText;
- (void)getPicture;

@end
