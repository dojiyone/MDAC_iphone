
//
//  DC_TEST01AppDelegate.m
//  DC_TEST01
//

#import "DC_TEST01AppDelegate.h"
#import "FirstViewController.h"

@implementation DC_TEST01AppDelegate
#import "TopViewController.h"

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
- (id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    NSLog(@"AppDelegate:init");
    
 //   _sheardInstance = self;
    return self;
}

//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    [self.window makeKeyAndVisible];
    
    // 起動後にここに来る
    //
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   // [defaults setInteger:0 forKey:@"TUTORIAL_FLAG"];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^{
            [application endBackgroundTask:backgroundTask];
        }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)dealloc
{
    [_window release];
    //[_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


- (void)tweetFromApplication {
    
    // Twitter Initialization
    if(!_engine){
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey    = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }  
    
    if(![_engine isAuthorized]){
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){
            [viewController presentModalViewController: controller animated: YES];
        }else{
			[_engine sendUpdate: [NSString stringWithFormat: @"アップデート. %@", [NSDate date]]];
		}
    }
}


@end
