//
//  PostDataEditViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 12/01/18.
//  Copyright (c) 2012年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface PostDataEditViewController : TopViewController <UIActionSheetDelegate>
{
    UINavigationController *nabi;
    NSString *image_id;
    NSString *re_value;
    
    IBOutlet UITextField *textField;
    IBOutlet UITextView* textView;
    
    IBOutlet NSString* upCategory;
    IBOutlet UIButton * ct_button;
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *image_id;
@property (nonatomic,retain)UINavigationController *nabi;

- (IBAction)post;
- (IBAction)buttonDownCategorySelect:(id)sender;
@end
