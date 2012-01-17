//
//  TageditViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/02.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;
@class AlertTableTagViewController;

@interface TageditViewController : TopViewController
<UITableViewDataSource,UITableViewDelegate,
UIAlertViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *postTag;
    NSMutableArray* dataSource_;    //table
    
    NSArray* keys_;
    
    
    
    //IBOutlet UIScrollView *MainScrollView; 
    
    UITextField *textField;
    
    //Table関連
    IBOutlet UIView *tagView;
    UIScrollView *tagsv;
    UITextField* textView;
    UITextField* textView2;
    
    NSString *tagText;
    
    NSString *re_value;
    NSString *uid;
    int fanpage_uid;
    
    
    IBOutlet UILabel *taglabel;
    
}

@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *image_id;
@property (nonatomic,retain)NSString *uid;

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UITextField* textView;
+ (TageditViewController*)alertWithTextField:(NSString*)title message:(NSString*)message delegate:(id)delegate textDelegate:(id<UITextFieldDelegate>)textDelegate placeholder:(NSString*)placeholder button:(NSString*)button;

-(IBAction)post_tag_btn:(id)sender;
-(void)alertText;
-(void)deleteTag;
-(void)makeTag:(UITableView*)tableView:(NSIndexPath*)indexPath;

-(void)sendNewTag:(NSString *)newTag:(long)postImageId;
-(void)setTag:(NSString *)stringName;
@end
