//
//  MysettingViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/12/01.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import "ModalDatePickerViewController.h"

@class TopViewController;

@interface MysettingViewController : TopViewController
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,ModalDatePickerViewControllerDelegate>
{
    ModalDatePickerViewController *datePickerController;
    NSDate *dateForDate1;
    NSDate *dateForDate2;
    IBOutlet UILabel *labelForDate1;
    IBOutlet UILabel *labelForDate2;
    IBOutlet UIButton *buttonForDate1;
    IBOutlet UIButton *buttonForDate2;
    
    UIPickerView *picker;
    
    IBOutlet UITextField* inputName;
    IBOutlet UITextField* inputBirth;   
    IBOutlet UITextView* inputComment;
    UIButton *iconButton;
    
    UITextField* textView;
}




@property (nonatomic,retain) NSDate *dateForDate1;
@property (nonatomic,retain) NSDate *dateForDate2;


- (IBAction) buttonForDate1Clicked:(id)sender;
- (IBAction) buttonForDate2Clicked:(id)sender;

- (IBAction)sendUserData:(id)sender;
-(IBAction) setUserName:(id)sender;
-(IBAction) setUserBirth:(id)sender;

- (void)showPhotoSheet;
- (void)showPicker;
- (BOOL)closePicker:(id)sender;
- (void) showModal:(UIView*) modalView;

-(void) uploadImage:(UIImage *)newImage;
@end
