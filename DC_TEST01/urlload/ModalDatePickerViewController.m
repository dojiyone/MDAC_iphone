//
//  ModalDatePickerViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/26.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "ModalDatePickerViewController.h"

@implementation ModalDatePickerViewController
@synthesize delegate, pickerName_, dispDate_;

- (id) init {
    if ((self = [self initWithNibName:@"ModalDatePickerViewController" bundle:nil])) {
        }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
    picker.datePickerMode = UIDatePickerModeDate;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.dispDate_ != nil) {
        [picker setDate:self.dispDate_];
        }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (IBAction)commitButtonClicked:(id)sender {
    [self.delegate didCommitButtonClicked:self selectedDate:picker.date pickerName:self.pickerName_];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.delegate didCancelButtonClicked:self pickerName:self.pickerName_];
}

- (IBAction)clearButtonClicked:(id)sender {
    [self.delegate didClearButtonClicked:self pickerName:self.pickerName_];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [pickerName_ release];
    pickerName_ = nil;
    [dispDate_ release];
    dispDate_ = nil;
}

- (void)dealloc {
    [pickerName_ release];
    [dispDate_ release];
    [super dealloc];
}

@end
