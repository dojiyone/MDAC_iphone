//
//  DC_TEST01AppDelegate.h
//  DC_TEST01
//

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

#define kOAuthConsumerKey                   @"MAmfrKc0ZIx8eJK46HsMVA"          //REPLACE ME
#define kOAuthConsumerSecret                @"cuCnelGhuMH3mXwc134w5ZarPr2KbWLJA5vU4sdUXBo"          //REPLACE ME
/*
#import "TopViewController.h"
#import "SecondViewController.h"
#import "RankingViewController.h"
#import "InfoViewController.h"
#import "PopularTagViewController.h"
#import "SerchViewController.h"
#import "MypageViewController.h"
#import "PostViewController.h"
*/
@class RootViewController;

@interface DC_TEST01AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIBackgroundTaskIdentifier backgroundTask;
    SA_OAuthTwitterEngine *_engine;
    RootViewController     *viewController;
    /*
    TopViewController *topViewController;
    RankingViewController *rankingViewController;
    SecondViewController *secondViewController;
    InfoViewController *infoViewController;
    PopularTagViewController *popularTagViewController;
    SerchViewController *serchViewController;
    MypageViewController *mypageViewController;
    PostViewController *postViewController;
     */
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
-(void) twitterAccountLogin;

@end
