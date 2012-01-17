//
//  FirstViewController.h
//  DC_TEST01
//

#import <UIKit/UIKit.h>
#import "TOPScrollView.h"

@class DC_TEST01AppDelegate;

@interface FirstViewController : UIViewController {
    IBOutlet TOPScrollView *_scrollView;
    UIImageView *myImage;
    

    // 変数
    NSString * mToken_Twitter;
    NSString * mUserID_Twitter;
}

@property (nonatomic, retain) IBOutlet TOPScrollView *_scrollView;
@property (nonatomic, retain) UIImageView *myImage;
@property (nonatomic, retain) NSString *mToken_Twitter;
@property (nonatomic, retain) NSString *mTokenSecret_Twitter;
@property (nonatomic, retain) NSString *mUserID_Twitter;

//
- (NSString *) getEncodedURL : (NSString *)urlString prm:(NSString *)prmString;

// 自前メソッド
+ (UIViewController *) getViewController;
+ (NSString *) getSetting: (NSString *)name;
- (void) setSetting: (NSString *)user data:(NSString *)dat;

- (NSDictionary *) tw_account_verify_credencials: (NSString *)nonce;

- (void) getPickupPicture;
- (void) getRankingPicture : (NSInteger) kind;

@end
