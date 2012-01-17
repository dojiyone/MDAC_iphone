//
//  ModalDatePickerViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/26.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalDatePickerViewController;
@protocol ModalDatePickerViewControllerDelegate

- (void)didCommitButtonClicked:(ModalDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName;
- (void)didCancelButtonClicked:(ModalDatePickerViewController *)controller pickerName:(NSString *)pickerName;
- (void)didClearButtonClicked:(ModalDatePickerViewController *)controller pickerName:(NSString *)pickerName;

@end

@interface ModalDatePickerViewController : UIViewController {
    NSString *pickerName_;
    NSDate *dispDate_;
    IBOutlet UIDatePicker *picker;
    IBOutlet UIButton *commitButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *clearButton;
    id<ModalDatePickerViewControllerDelegate>delegate;
}

- (IBAction)commitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)clearButtonClicked:(id)sender;

@property (nonatomic, assign) id<ModalDatePickerViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *pickerName_;
@property (nonatomic, retain) NSDate *dispDate_;

@end
