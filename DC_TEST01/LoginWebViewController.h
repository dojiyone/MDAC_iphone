//
//  LoginWebViewController.h
//  MixiOAuth
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginWebViewController.h"

@interface LoginWebViewController : UIViewController {
    NSString *_authorize_uri;
    NSString *_response_uri;
    UIWebView *_web_view;

    NSString *_params;
    
    NSString *_pin;

    id _caller;
    id _webview_delegate;
}

// プロパティ
@property (nonatomic, retain) NSString *authorize_uri;
@property (nonatomic, retain) NSString *response_uri;
@property (nonatomic, retain) UIWebView *web_view;

@property (nonatomic, retain) NSString *params;
@property (nonatomic, retain) NSString *pin;

@property (nonatomic, assign) id caller;
@property (nonatomic, assign) id webview_delegate;


//
-(void) endLoading:(NSMutableString *)page;

-(void)parseQuery: (NSString *)urlstring sep:(NSString *)_sep;

@end