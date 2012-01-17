//
//  FollowlistViewController.m
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "FollowlistViewController.h"
#import "loadingAPI.h"
#import "UIAsyncImageView.h"

@implementation FollowlistViewController
@synthesize re_value;
@synthesize re_num;

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
- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    NSLog(@"%d",re_num);
    int Uid;
    Uid = re_num;
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp = [loadingapi getFollowingList:Uid];
    
    int cnt = [[restmp objectForKey:@"result"] count];
    
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    
    int margin = 89;//配置時の高さマージン
    int i=0;
    
    for (int i=0; i<cnt; i++) 
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
            //NSLog(@"uri = %@",uri);
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
            iconButton.tag = [[dic objectForKey:@"uid"] integerValue];
            [iconButton addTarget:self action:@selector(modalButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
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
             deletaButton.tag = [[dic objectForKey:@"uid"] integerValue];
             deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
             [deletaButton addTarget:self action:@selector(deleteFollow:) forControlEvents:UIControlEventTouchUpInside];
             //deletaButton.center = CGPointMake(6, 51);
             //deletaButton.contentMode = UIViewContentModeScaleToFill;
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

- (void)modalButtonDidPush:(UIButton *)sender
{
    //ログインID＝fanpageIDならmypageへ移動
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sender.tag forKey:@"FOLLOW_ID"];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    int Fid=[[defaults stringForKey:@"FOLLOW_ID"]intValue];
    if(Uid == Fid){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _mypageViewController = [[MypageViewController alloc] 
                                 initWithNibName:@"MypageViewController" 
                                 bundle:nil];
        
        [self.navigationController pushViewController:_mypageViewController
                                             animated:YES];
        
    }
    else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _fanpageViewController = [[FanpageViewController alloc]
                                  initWithNibName:@"FanpageViewController" 
                                  bundle:nil];
        [self.navigationController pushViewController:_fanpageViewController 
                                             animated:YES];
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

-(void)deleteFollow:(UIButton *)sender
{
    int tag = sender.tag;
    NSLog(@"sender = %d",tag);
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    [loadingapi deleteFollow:tag];
    
    // 生成と同時に各種設定も完了させる例
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@""
     message:@"フォローを解除しました"
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    
    [alert show];

    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    
    NSDictionary *restmp = [loadingapi getFollowingList:re_num];
    
    int cnt = [[restmp objectForKey:@"result"] count];
    
    UIViewController *viewController1;
    viewController1 = [[UIViewController alloc] init];
    
    int margin = 89;//配置時の高さマージン
    int i=0;
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        NSLog(@"res%@",result);
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
            //NSLog(@"uri = %@",uri);
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
            iconButton.tag = [[dic objectForKey:@"uid"] integerValue];
            [iconButton addTarget:self action:@selector(modalButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
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
            deletaButton.tag = [[dic objectForKey:@"uid"] integerValue];
            deletaButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [deletaButton addTarget:self action:@selector(deleteFollow:) forControlEvents:UIControlEventTouchUpInside];
            //deletaButton.center = CGPointMake(6, 51);
            //deletaButton.contentMode = UIViewContentModeScaleToFill;
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

@end
