//
//  DetailsCommentsViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface DetailsCommentsViewController : TopViewController
{
    UINavigationController *nabi;
    NSString *image_id;
    NSString *re_value;
    IBOutlet UITextView *post_textView;
    
    IBOutlet UIScrollView *main_scrollView;
    
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *image_id;
@property (nonatomic,retain)UINavigationController *nabi;

- (void)getComment;
-(IBAction) postComment_btn_down:(id)sender;
- (int) strLength :(NSString *) aValue :(int)strlen;
@end
