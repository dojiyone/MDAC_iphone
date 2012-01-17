//
//  FBTestViewController.h
//  mixitest
//
#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@class SecondViewController;

@interface FBTestViewController : SecondViewController 
{
@public
    SecondViewController *_secondview;
    NSString *_client_id;
    NSString *_client_secret;
    NSString *_scope;
    NSString *_display;
    NSString *_stat;
    NSString *_redirect_uri;
    
    NSString *_authorization;
    NSString *_refresh_token;
    NSString *_expires_in;
    NSString *_access_token;
    
    NSString *_error_code;
    
    UIImage  *_user_icon;
    
    //SecondViewController * login_vc;    
    
    // FaceBook固有のログインデータ
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
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *stat;
@property (nonatomic, retain) NSString *redirect_uri;

@property (nonatomic, retain) NSString *authorization;
@property (nonatomic, retain) NSString *refresh_token;
@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *expires_in;

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
- (void)modalButtonDidPush;

- (void)parse_authorization_code:(NSString *)authorization_code;
- (void)parse_access_denied:(NSString *)error_code;
- (void)parse_refresh_token:(NSString *)refresh_token;
- (void)parse_access_token:(NSString *)access_token;
- (void)parse_expires_in:(NSString *)expires_in;

- (BOOL) accessTokenGet;
- (void)postMessage:(NSString *)message;
@end