//
//  InfoViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface InfoViewController : TopViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *_webview;
}

@property  (nonatomic,retain)IBOutlet UIWebView *_webview;
-(void) getActivity;

-(void) setUIWebView;
@end
