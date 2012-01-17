//
//  BlocklistViewController.m
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/03.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "BlocklistViewController.h"
#import "loadingAPI.h"
#import "UIAsyncImageView.h"

@implementation BlocklistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    
    //公式タグ一覧のデータを受信
    NSDictionary *restmp=[loadingapi getBlockList];
    NSLog(@"aaa %@",restmp);
    
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    int loopCount = [[restmp objectForKey:@"result"] count];
    //[[restmp objectForKey:@"result"] count];//count
    int margin = 89;//配置時の高さマージン
    int i=0;
    
    for (; i <=loopCount -1; i++)
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog("res%@",result);
        for (NSDictionary *dic in result) 
        {
            
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
            
            [ai changeImageStyle:[dic objectForKey:@"icon_path"] :60:60 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            
            CGRect rect = ai.frame;
            rect.size.height = 60;
            rect.size.width = 60;
            ai.frame = rect;
            ai.tag = i;
            //plz set Frame size this erea
            ai.frame = CGRectMake(0, 0, 60, 60);
            //[icon_image addSubview:ai];
            [ai release];
            
            NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"icon_path"]];
            NSLog(@"uri = %@",uri);
            NSData *dt = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:uri]];
            UIImage *image = [[UIImage alloc] initWithData:dt];
        
        //ユーザーアイコン（ボタン）
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setTitle:@"" forState:UIControlStateNormal];
        [iconButton setBackgroundImage:image forState:UIControlStateNormal];
        //[iconButton sizeToFit];
        iconButton.frame = CGRectMake(6, 6 + margin * i, 77, 77);//画像サイズがいかなる場合でも77×77にする
        iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
        //iconButton.center = CGPointMake(6, 51);
        //iconButton.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:iconButton];
        
        //ユーザー名
        UILabel *userNameLabel = [[UILabel alloc] init];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.frame = CGRectMake(91, 6 + margin * i, 200, 20);
        userNameLabel.textColor = [UIColor grayColor];
        userNameLabel.font = [UIFont boldSystemFontOfSize:14];
        userNameLabel.textAlignment = UITextAlignmentLeft;
        userNameLabel.text = [dic objectForKey:@"name"];
        [scrollView addSubview:userNameLabel];
        
        //削除ボタン（リムーブボタン）（フォローリストのみ表示）
        UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deletaButton setTitle:@"" forState:UIControlStateNormal];
        [deletaButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
        deletaButton.frame = CGRectMake(91, 51 + margin * i, 0, 0);
        [deletaButton sizeToFit];
        //位置調整など
        deletaButton.tag = [[dic objectForKey:@"uid"]integerValue];
        deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [deletaButton addTarget:self action:@selector(delblock:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:deletaButton];
        
        //削除（固定文言）
        UILabel *deletaLabel = [[UILabel alloc] init];
        deletaLabel.frame = CGRectMake(106, 56 + margin * i, 200, 20);
        deletaLabel.backgroundColor = [UIColor clearColor];
        deletaLabel.textColor = [UIColor lightGrayColor];
        deletaLabel.font = [UIFont boldSystemFontOfSize:15];
        deletaLabel.textAlignment = UITextAlignmentLeft;
        deletaLabel.text = @"削除";
        [scrollView addSubview:deletaLabel];
        
        //横線
        UIView *uv = [[UIView alloc] init];
        uv.frame = CGRectMake(0, 88 + margin * i, 320, 1);
        uv.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:uv];
            
        scrollView.contentSize = CGSizeMake(320,133 + margin * i);
	}
    
    }
}

- (void)delblock:(UIButton *)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:@"このユーザーのブロックを解除しますがよろしいですか？"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:@"キャンセル", nil];
    int deluid =sender.tag;
    alert.tag = deluid;
    alert.delegate =self;
    NSLog(@"alertView.tag%d",alert.tag);
    [alert show];
    [alert release];
    
    //loadingAPI* loadingapi=[[loadingAPI alloc] init];
    //[loadingapi deleteBlock:deluid];
    
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSLog(@"alertView.tag%d",alertView.tag);
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            [loadingapi deleteBlock:alertView.tag];
        
            ///////////////////////////////////////////ロードしなおし
            
            UIView *uv = [[UIView alloc] init];
            uv.frame = self.view.bounds;
            uv.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:uv];
            
            //公式タグ一覧のデータを受信
            NSDictionary *restmp=[loadingapi getBlockList];
            NSLog(@"aaa %@",restmp);
            
            //[super viewDidLoad];
            // Do any additional setup after loading the view from its nib.
            UIViewController *viewController1;
            viewController1 = [[UIViewController alloc] init];
            int loopCount = [[restmp objectForKey:@"result"] count];
            //[[restmp objectForKey:@"result"] count];//count
            int margin = 89;//配置時の高さマージン
            int i=0;
            
            for (; i <=loopCount -1; i++)
            {
                NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
                //NSLog("res%@",result);
                for (NSDictionary *dic in result) 
                {
                    
                    UIAsyncImageView *ai = [[UIAsyncImageView alloc] init];
                    
                    [ai changeImageStyle:[dic objectForKey:@"icon_path"] :60:60 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
                    ai.userInteractionEnabled=YES;
                    
                    
                    CGRect rect = ai.frame;
                    rect.size.height = 60;
                    rect.size.width = 60;
                    ai.frame = rect;
                    ai.tag = i;
                    //plz set Frame size this erea
                    ai.frame = CGRectMake(0, 0, 60, 60);
                    //[icon_image addSubview:ai];
                    [ai release];
                    
                    NSString *uri = [NSString stringWithFormat:@"%@%@", @"http://pic.mdac.me", [dic objectForKey:@"icon_path"]];
                    NSLog(@"uri = %@",uri);
                    NSData *dt = [NSData dataWithContentsOfURL:
                                  [NSURL URLWithString:uri]];
                    UIImage *image = [[UIImage alloc] initWithData:dt];
                    
                    //ユーザーアイコン（ボタン）
                    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [iconButton setTitle:@"" forState:UIControlStateNormal];
                    [iconButton setBackgroundImage:image forState:UIControlStateNormal];
                    //[iconButton sizeToFit];
                    iconButton.frame = CGRectMake(6, 6 + margin * i, 77, 77);//画像サイズがいかなる場合でも77×77にする
                    iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                    [iconButton addTarget:self action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
                    //iconButton.center = CGPointMake(6, 51);
                    //iconButton.contentMode = UIViewContentModeScaleToFill;
                    [scrollView addSubview:iconButton];
                    
                    //ユーザー名
                    UILabel *userNameLabel = [[UILabel alloc] init];
                    userNameLabel.backgroundColor = [UIColor clearColor];
                    userNameLabel.frame = CGRectMake(91, 6 + margin * i, 200, 20);
                    userNameLabel.textColor = [UIColor grayColor];
                    userNameLabel.font = [UIFont boldSystemFontOfSize:14];
                    userNameLabel.textAlignment = UITextAlignmentLeft;
                    userNameLabel.text = [dic objectForKey:@"name"];
                    [scrollView addSubview:userNameLabel];
                    
                    //削除ボタン（リムーブボタン）（フォローリストのみ表示）
                    UIButton *deletaButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deletaButton setTitle:@"" forState:UIControlStateNormal];
                    [deletaButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
                    deletaButton.frame = CGRectMake(91, 51 + margin * i, 0, 0);
                    [deletaButton sizeToFit];
                    //位置調整など
                    deletaButton.tag = [[dic objectForKey:@"uid"]integerValue];
                    deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                    [deletaButton addTarget:self action:@selector(delblock:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:deletaButton];
                    
                    //削除（固定文言）
                    UILabel *deletaLabel = [[UILabel alloc] init];
                    deletaLabel.frame = CGRectMake(106, 56 + margin * i, 200, 20);
                    deletaLabel.backgroundColor = [UIColor clearColor];
                    deletaLabel.textColor = [UIColor lightGrayColor];
                    deletaLabel.font = [UIFont boldSystemFontOfSize:15];
                    deletaLabel.textAlignment = UITextAlignmentLeft;
                    deletaLabel.text = @"削除";
                    [scrollView addSubview:deletaLabel];
                    
                    //横線
                    UIView *uv = [[UIView alloc] init];
                    uv.frame = CGRectMake(0, 88 + margin * i, 320, 1);
                    uv.backgroundColor = [UIColor lightGrayColor];
                    [scrollView addSubview:uv];
                    
                    scrollView.contentSize = CGSizeMake(320,133 + margin * i);
                }
                
            }
            
            ///////////////////////////////////////////ロードしなおし
       
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            break;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated
{
}

-(void)modalButtonDidPush
{
    
}
@end
