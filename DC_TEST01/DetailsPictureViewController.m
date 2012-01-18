//
//  DetailsPictureViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "DetailsPictureViewController.h"
#import "loadingAPI.h"



#define HORIZ_SWIPE_MIN 12
#define VERT_SWIPE_MAX 8
#define SWIPE_NON 0
#define SWIPE_LEFT 1
#define SWIPE_RIGHT 2

@implementation DetailsPictureViewController
@synthesize re_value;
@synthesize startTime;
@synthesize post_image;

CGPoint startPt;
int swipe_direction;



- (void) handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender 
{   
    UISwipeGestureRecognizer *swipeAction=sender;
    
    
    CGPoint pt =[swipeAction locationInView:self.view];
    float ptx=pt.x;
    
    
    int direction = self.interfaceOrientation;
    // int direction = [self getDirection];
    
    //directionは逆になる上OS差もでない（なぜ？）
    NSLog(@"left x %d",direction);
    mainSize = [UIScreen mainScreen].bounds.size;
    if((mainSize.width-(mainSize.width/5)<ptx && direction<3)
       || (mainSize.height-(mainSize.height/4)<ptx && direction>=3))//左スワイプだけ、横向きにしたとき縦数値でチェック
    {
        [self returnDetailView];
    }
}


- (void) handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender 
{    
    UISwipeGestureRecognizer *swipeAction=sender;
    
    
    CGPoint pt =[swipeAction locationInView:self.view];//]locationInView:self.view];
    float ptx=pt.x;
    
    //NSLog(@"right x %f",ptx);
    mainSize = [UIScreen mainScreen].bounds.size;
    
    
    //  int direction = [self getDirection];
    
    
    
    //if (CGRectContainsPoint(CGRectMake(mainSize.width/4+mainSize.width/2,0,mainSize.width,mainSize.height),pt)) 
    if( ptx<mainSize.width/5)// && direction>=3)
        //  ||  (mainSize.height-(mainSize.height/4)<ptx && direction<3))
    {
        [self returnDetailView];
    }
    
}

//iOSバージョンごとの方角を検出
-(int)getDirection
{
    int direction = self.interfaceOrientation;
    
    NSArray *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor = [[aOsVersions objectAtIndex:0] intValue];
    NSInteger iOsVersionMinor1 = [[aOsVersions objectAtIndex:1] intValue];
    
    NSLog(@"major %d minot %d",iOsVersionMajor,iOsVersionMinor1);
    
    if(iOsVersionMajor>=5)
    {
        if(direction>=3) direction=1;
        else             direction=3;
    }
    
    return direction;
}





//前の画面に戻る
-(void)returnDetailView
{
    if(endflag==1)    return;
    endflag=1;
    
    NSLog(@"swipe");
    [UIApplication sharedApplication].statusBarHidden	= NO;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [startTime release];
    [super dealloc];
}

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
    
    
    NSLog(@"post image%@",post_image);

    //パン
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];  
    [self.view addGestureRecognizer:panGesture];  
    [panGesture release];  
    
    // 左へスワイプ
    /* UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
     swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.view addGestureRecognizer:swipeLeftGesture];
     [swipeLeftGesture release];
     // 右へスワイプ
     UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
     swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
     [self.view addGestureRecognizer:swipeRightGesture];
     [swipeRightGesture release];
     */
    //ダブルタップ
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    //シングルタップ
    UITapGestureRecognizer* singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [imgScrollView addGestureRecognizer:singleTapGesture];//self.view
    [singleTapGesture release];
    
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification	
                                               object:nil];
    
    
    
    
    
    [UIApplication sharedApplication].statusBarHidden	= YES;
    //[super viewDidLoad];
    NSLog(@"@%@",re_value);
    long num = [re_value integerValue];
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi detailPostimage:num :NULL];
    [loadingapi release];
    
    // NSLog(@"1 %@",restmp);
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            real_path = [NSString stringWithFormat:@"http://pic.mdac.me%@",[dic objectForKey:@"real_path"]];
        }
    }
    
    NSData *dt = [NSData dataWithContentsOfURL:
                  [NSURL URLWithString:real_path]];
    UIImage *newimage = [[UIImage alloc] initWithData:dt];

    //    newimage = post_image;

    
    //画像が画面サイズよりデカイ場合はそのまま///////////////////
    float newWidth;
    float newHeight;
    mainSize = [UIScreen mainScreen].bounds.size;
    
    NSLog(@"サイズ %f %f",mainSize.width,newimage.size.width);
    //小さい場合は拡張して設置する
    if(newimage.size.width > mainSize.width
       && newimage.size.height > mainSize.height)
    {
        //画面より大きい場合はそのまま
        NSLog(@"そのまま");
    }
    else
    {
        newWidth=mainSize.width*2;
        newHeight=mainSize.height*2;
        if(newimage.size.width > newimage.size.height)
        {
            NSLog(@"小さいw");
            newHeight= newimage.size.width*newimage.size.height/newWidth;
        }
        else//高さが大きい
        {
            NSLog(@"小さいh");
            newWidth=newimage.size.height*newimage.size.width/newHeight;
        }
        newimage=[newimage stretchableImageWithLeftCapWidth:newWidth topCapHeight:newHeight];
    }
    
    float imgWidth;
    float imgHeight;
    myImage.image = newimage;
    myImage.contentMode = UIViewContentModeScaleAspectFill;//アスペクト比維持
    //[imgScrollView addSubview:myImage];
    //スクロールビューのピンチインアウト・回転時サイズ変更
    
    //幅・高さを固定にするか可変にするか
    imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imgScrollView.delegate = self;  
    
    imgWidth=myImage.image.size.width;
    imgHeight=myImage.image.size.height;
    
    //画面サイズに合わせ初期ズーム値を設定
    
    imgScrollView.contentSize = mainSize;
    title.contentMode= UIViewAutoresizingNone;
    
    
    myImage.frame= CGRectMake(0, 0,imgWidth ,imgHeight );
    
    
    
    //縮尺比率の取得///////////////////////////////////////
    
    NSLog(@"size %f %f",imgWidth,imgHeight);
    if(imgWidth > imgHeight) //横長画像
    {
        int hiritu=imgHeight*100/imgWidth;
        if(hiritu<80) 
            defaultScaleYoko= mainSize.height/ imgWidth;
        else    defaultScaleYoko= mainSize.width/ imgHeight;//imgWidth;
        
        NSLog(@"yokonaga %d",hiritu);
        //defaultScaleYoko= mainSize.height/imgWidth;
        defaultScaleTate= mainSize.width/ imgWidth;        
        
        //画面より小さい画像向けに一度定義してやらないと定格サイズで表示されてしまう
        imgScrollView.minimumZoomScale = defaultScaleYoko;
        imgScrollView.zoomScale=defaultScaleYoko;
        imgScrollView.maximumZoomScale = 5.0;
    }
    else//縦長画像
    { 
        //正方形に近いか
        int hiritu=imgWidth*100/imgHeight;
        if(hiritu<80) 
            defaultScaleTate=mainSize.height/ imgHeight;
        else    defaultScaleTate=mainSize.width/ imgWidth;//imgHeight;
        
        NSLog(@"tatenaga %d",hiritu);
        defaultScaleYoko=mainSize.width/ imgHeight;//
        
        //画面より小さい画像向けに一度定義してやらないと定格サイズで表示されてしまう
        imgScrollView.minimumZoomScale = defaultScaleTate;
        imgScrollView.zoomScale=defaultScaleTate;
        imgScrollView.maximumZoomScale = 5.0;
    }
    
    
    //  imgScrollView.center=CGPointMake(mainSize.width/2, mainSize.height/2);
    [self setDefaultAngle:3];
    [self showSetumeiLabel];
    
    
}

-(void)back_change_btn:(id)sender
{
    NSLog(@"test");
    [self returnDetailView];
}

-(void)showSetumeiLabel
{
    
    //画像変更ボタン（リムーブボタン）（フォローリストのみ表示）
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"common_button_b_0.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 20, 0, 0);
    [backButton sizeToFit];
    //位置調整など
    backButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    backButton.hidden=YES;//最初は不可視
    [backButton addTarget:self action:@selector(back_change_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];////imgScrollView
    
    //画像変更（固定文言）
    backLabel = [[UILabel alloc] init];
    backLabel.frame = CGRectMake(30, 25, 200, 20);
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.textColor = [UIColor lightGrayColor];
    backLabel.font = [UIFont boldSystemFontOfSize:12];
    backLabel.textAlignment = UITextAlignmentLeft;
    backLabel.text = @"戻る";
    [self.view addSubview:backLabel];
    
    
     
     NSString *labeltext=@"画面をタップすると戻るボタンが出現します";
     
     
     //ラベル作成/////////////////////////////
     UILabel *userNameLabel = [[UILabel alloc] init];
     userNameLabel.backgroundColor = [UIColor grayColor];//[UIColor clearColor];
     userNameLabel.frame = CGRectMake(0, 0, 290, 20);
     userNameLabel.center = CGPointMake(mainSize.width/2,mainSize.height/2+mainSize.height/3);
     userNameLabel.textColor = [UIColor whiteColor];
     userNameLabel.font = [UIFont boldSystemFontOfSize:14];
     userNameLabel.textAlignment = UITextAlignmentCenter;
     userNameLabel.tag = 10;
     userNameLabel.text = labeltext;
     
     
     //フェードアウト処理//////////////////////
     userNameLabel.alpha = 1.0;
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:2.6];//3.0
     userNameLabel.alpha = 0.0;
     [UIView commitAnimations];
     ////////////////////////////////////////
     
     [imgScrollView addSubview:userNameLabel];
}
-(void)showBackButton
{
    if(backButton.hidden==YES)
    {
        backButton.hidden=NO;
        backLabel.hidden =NO;
    }
    else
    {
        backButton.hidden=YES;
        
        backLabel.hidden =YES;
    }
}


-(void)setDefaultAngle:(int)direction
{   
    NSLog(@"sc %@",imgScrollView);
    NSLog(@"direc %d",direction);
    mainSize = [UIScreen mainScreen].bounds.size;
    imgScrollView.contentSize = mainSize;
    imgScrollView.contentOffset=CGPointMake(0, 0);
    nowSwipeCenter=CGPointMake(0, 0);
    
    
    
    //本体方向/////////////////////////////////////
    if(direction>=3)//縦3 4
    {  
        //imgScrollView.center=CGPointMake(mainSize.height/2, mainSize.width/2);
        imgScrollView.minimumZoomScale = defaultScaleTate;
        imgScrollView.zoomScale=defaultScaleTate;
        imgScrollView.maximumZoomScale = 5.0;
        
        
        myImage.center = CGPointMake(mainSize.width/2,mainSize.height/2);
    }
    else//横1 2
    {
        // imgScrollView.center=CGPointMake(mainSize.width/2, mainSize.height/2);
        imgScrollView.minimumZoomScale = defaultScaleYoko;
        imgScrollView.zoomScale=defaultScaleYoko;
        imgScrollView.maximumZoomScale = 5.0;
        
        myImage.center = CGPointMake(mainSize.height/2,mainSize.width/2);
    }
}

- (void)viewDidUnload
{
    //[UIApplication sharedApplication].statusBarHidden	= NO;
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//ピンチインアウト
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return myImage;  
}  


//回転方向検出
- (void) didRotate:(NSNotification *)notification 
{
    UIDeviceOrientation orientation = [[notification object] orientation];
	if (orientation == UIDeviceOrientationLandscapeLeft)
    {
		NSLog(@"Device rotate Leftl!");
        [self setDefaultAngle:1];
	} 
    else if (orientation == UIDeviceOrientationLandscapeRight) 
    {
		NSLog(@"Device rotate Rightl!");
        [self setDefaultAngle:2];
	} 
    else if (orientation == UIDeviceOrientationPortraitUpsideDown)
    {
		NSLog(@"Device rotate UpsideDownl!");
        [self setDefaultAngle:3];
	} 
    else if (orientation == UIDeviceOrientationPortrait) 
    {
		NSLog(@"Device rotate Portraitl!");
        [self setDefaultAngle:4];
	}
}


//傾けたら回転
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    /* if (UIDeviceOrientationIsPortrait(interfaceOrientation))
     {
     
     }
     else if (UIDeviceOrientationIsLandscape(interfaceOrientation))
     {
     }
     */
    
    
    int direction = [self getDirection];
    
    if(startflag!=1)
    {
        startflag=1;
        // direction=3;//縦デフォルト
        nowAngle=direction;
        return YES;
    }
    //  if(nowAngle>=3 &&direction>=3)direction=1;
    // if(nowAngle<3 &&direction<3)direction=3;
    
    //[self setDefaultAngle:direction];
    
    nowAngle=direction;
    return YES;
}


//パンジェスチャー処理
- (void)handlePanGesture:(id)sender 
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint point = [pan translationInView:self.view];//移動位置
    //CGPoint velocity = [pan velocityInView:self.view];//移動距離
    //NSLog(@"pan. translation: %@, velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
    /*
     float addX;
     float addY;
     if(point.x <0)  addX=4;
     else            addX=-4;
     if(point.y <0)  addY=4;
     else            addY=-4;
     */
    //スクロールビューのセンターを移動させる
    mainSize = [UIScreen mainScreen].bounds.size;
    imgScrollView.contentSize = mainSize;
    imgScrollView.contentOffset=CGPointMake(-point.x,-point.y);//CGPointMake(imgScrollView.contentOffset.x+addX,imgScrollView.contentOffset.y+addY);//point;
    nowSwipeCenter=CGPointMake(0, 0);
    
}



-(IBAction)swaip:(id)sender{
    NSLog(@"@@@@@@@@@");
}

- (void)viewDidAppear:(BOOL)animated
{
}




//ダブルタップの動作
- (void) handleDoubleTapGesture:(UITapGestureRecognizer*)sender
{
    NSLog(@"tapcount %d", sender.numberOfTapsRequired);
    if(sender.numberOfTapsRequired==1)
    {
        [self showBackButton];
        return;
    }
    
    //現在の向きを検出して角度変更処理へ
    int direction=self.interfaceOrientation;
    if(direction < 2)direction =3;
    else direction =1;
    [self setDefaultAngle:direction];
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

@end
