//
//  PostEditViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/11.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;
@class loadingAPI;

@interface PostEditViewController : TopViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    IBOutlet UITextField* inputText;
    IBOutlet UITextView* inputComment;
    IBOutlet UITextField* tf;
    IBOutlet UIImageView*  _img;
    IBOutlet UIImageView*  _imgOl;
    IBOutlet NSString* upCategory;
    IBOutlet UIButton * ct_button;
    IBOutlet UIScrollView *MainScrollView; 
    
    IBOutlet UIImageView *post_Tw;
    IBOutlet UIImageView *post_Fb;
    IBOutlet UIImageView *post_Mx;
    
    int Tw_post_flag;
    int Fb_post_flag;
    int Mx_post_flag;
    UITextField *textField;
    
    //Table関連
    IBOutlet UIView *tagView;
    IBOutlet UITableView *TagtableView;
    
    IBOutlet UITableView *SwitchTable;
    NSArray* object;
    
    //Table用
    NSArray* keys;
    NSMutableArray* dataSource_;
    NSMutableArray* dataSource2_;
    
    NSMutableArray *names;
    NSMutableArray *names2;
    //タグ
    NSString *tagString[10];
    NSString *editTag;
    NSMutableArray *list;
    
    
    UIScrollView *tagsv;
    UITextField* textView;
    UITextField* textView2;
    
    NSString *tagText;
}

-(unsigned)countOfList; //returns number of elements in list
- (id)objectInListAtIndex:(unsigned)theIndex; //returns object at given index
- (void)addData:(NSString*)data; //adds data to the list
- (void)removeDataAtIndex:(unsigned)theIndex;
@property (nonatomic, copy, readwrite) NSMutableArray *list;
@property (nonatomic,retain) IBOutlet UIImageView*  _img;
@property (nonatomic,retain) IBOutlet UIImageView*  _imgOl;
//@property int Tw_post_flag;
//@property int Fb_post_flag;
//@property int Mx_post_flag;
//@property (nonatomic,retain)IBOutlet UITextField* inputText;

- (void)showWithTitle:(NSString *)title text:(NSString *)text;
-(void)setTextViewText:(NSString *)text;
-(NSString *)string:returnText;
- (IBAction)inputTitleField;
- (IBAction)inputCommentField;
- (IBAction)post;

- (void)post_Tw:(int)switchType;
- (void)post_Fb:(int)switchType;
- (void)post_Mx:(int)switchType;

- (UISwitch*)switchForCell:(const UIView*)cell;
- (UISwitch*)switchForCell2:(const UIView*)cell;
- (UISwitch*)switchForCell3:(const UIView*)cell;

-(void)pushSwitch1:(UISwitch*)theswitch;
-(void)pushSwitch2:(UISwitch*)theswitch;
-(void)pushSwitch3:(UISwitch*)theswitch;
-(void)pushSwitch1_off:(UISwitch*)theswitch;
-(void)pushSwitch2_off:(UISwitch*)theswitch;
-(void)pushSwitch3_off:(UISwitch*)theswitch;

- (IBAction)buttonDownCategorySelect:(id)sender;//:(UIButton*)button;

@end
