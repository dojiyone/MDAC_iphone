//
//  PostDataEditViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 12/01/18.
//  Copyright (c) 2012年 CyberMuse, Inc. All rights reserved.
//

#import "PostDataEditViewController.h"
#import "PostEditViewController.h"
#import "loadingAPI.h"
#import "SecondViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "MixiTestViewController.h"
#import "AlertTableTagViewController.h"
#import "DetailsViewController.h"
#import "DetailsShareViewConroller.h"
#import "TopViewController.h"
#import "MypageViewController.h"

@implementation PostDataEditViewController

@synthesize re_value;
@synthesize image_id;
@synthesize nabi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationkjfgpijariogja;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [scrollView setContentSize:CGSizeMake(320,2186)];

}
- (IBAction)post
{   
    int category=[upCategory intValue];
    int tagCount=0;
    
    // タイトル未入力はエラー。
    if([textField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"タイトルが未入力です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    if([textField.text length] >50){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"タイトル文字数は50文字までです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //コメント未入力はエラー
    if([textView.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"コメントが未入力です"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    if([textView.text length] > 1000){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"本文は1000文字までですです"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    //[loadingapi updatePostimage:post_img_id :category_id :textField.text :textView.text];
}
- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (IBAction)buttonDownCategorySelect:(id)sender//:(UIButton*)button
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"dogs",
                                  @"cats",
                                  nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:sender];
    [actionSheet release];    
}
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //番号別変更
    //NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:upCategory=@"0"; 
            [ct_button setTitle:@"dogs" forState:UIControlStateNormal];
            break;
        case 1:upCategory=@"1"; 
            [ct_button setTitle:@"cats" forState:UIControlStateNormal];
            break;    
        default:  break;
    }
    
    
}


@end
