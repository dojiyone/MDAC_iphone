//
//  SecondViewController.h
//  DC_TEST01
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "TopViewController.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class TopViewController;

@class MixiTestViewController;
@class FBTestViewController;
@class TwTestViewController;

@interface SecondViewController : TopViewController 
<UITableViewDataSource,UITableViewDelegate,
UITextFieldDelegate,
MFMailComposeViewControllerDelegate,UIWebViewDelegate>

{
    NSString *snsName;
    NSString *usrName;
    NSString *passcode;
    NSString *name;
    
    MixiTestViewController *viewController1;
    FBTestViewController *viewController2;
    TwTestViewController *viewController3;  
    
    
    IBOutlet UIWebView *_web_view;
    
    NSString *_authorize_uri;
    NSString *_response_uri;
    NSString *_params;
    NSString *_pin;
    
    //table
    IBOutlet UITableView *myTableView;
    
    NSArray* keys_;
    NSDictionary* dataSource_;
    
    id _caller;
    
    int delCheck;
    UITextField* textView;
    UITextField* textView2;
    UITextField* textView2_2;
    UITextField* textView3;
}

@property (nonatomic, retain) NSString *authorize_uri;
@property (nonatomic, retain) NSString *response_uri;
@property (nonatomic, retain) UIWebView *web_view;
@property (nonatomic, retain) NSString *params;
@property (nonatomic, retain) NSString *pin;

@property (nonatomic, assign) id caller;
///@property (nonatomic, assign) id webview_delegate;

//
-(void) endLoading:(NSMutableString *)page;

-(void)parseQuery: (NSString *)urlstring sep:(NSString *)_sep;


- (void) loginButton;
- (void) viewURLPage;

-(bool)getSnsLoginStatus:(int)snsType;
- (UISwitch*)switchForCell:(const UIView*)cell;
- (UISwitch*)switchForCell2:(const UIView*)cell;
- (UISwitch*)switchForCell3:(const UIView*)cell;


- (void)changeMainSNS;
- (void)ShowHelp;
- (void)ShowVersio;
- (void)ShowPolicy;
- (void)ShowSupport;
- (void)UserImigrate;
- (void)Leave;
- (void)shiftUser;
- (NSString *) requestUserShift:(NSString *)passNo;
- (bool)processUserShift:(NSString *)shiftNo:(NSString *)passNo;
- (void)deleteUser;

//

@end
