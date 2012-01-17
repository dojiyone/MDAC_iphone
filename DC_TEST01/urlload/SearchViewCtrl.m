#import "SearchViewCtrl.h"
//#import "XPathQuery.h"
#import "UIAsyncImageView.h"

#include <QuartzCore/CALayer.h>
#import "NSString+Encode.h"
#import "SFHFKeychainUtils.h"
#import "TopViewController.h"
#import "loadingAPI.h"
#import "MypageViewController.h"

#import "GADBannerView.h"
#import "GADRequest.h"

@implementation SearchViewCtrl

@synthesize thumbnailView;
@synthesize tagpage_flag;
@synthesize nowTagNum;
@synthesize adBanner = adBanner_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        basey = 4;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        Category=[defaults stringForKey:@"MDAC_CATEGORY"];
        //if(Category!=@"1"&&Category!=@"0")    Category=@"0%2c1";
        
        
        int setY=460;//107*(50/3);
        NSLog(@"setY %d",setY);
		thumbnailView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, setY)];//仮の指定
		thumbnailView.backgroundColor = [UIColor clearColor];
		//thumbnailView.contentSize = self.view.frame.size;
		thumbnailView.indicatorStyle = UIScrollViewIndicatorStyleBlack;		
		thumbnailView.clipsToBounds = YES;
		thumbnailView.scrollEnabled = YES;
		thumbnailView.canCancelContentTouches = NO;	
        
		thumbnailView.delegate =self;
        
        //   thumbnailView.userInteractionEnabled = YES;
        // [thumbnailView setMultipleTouchEnabled:YES];
        //    self.view.userInteractionEnabled = YES;
        //    [self.view setMultipleTouchEnabled:YES];	
		
        [self.view addSubview:thumbnailView];
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}





- (void)getTagLists:(NSString *)tag:(int)offset:(int)limit
{  
    loadtype=1;
    NSString *enctag=[tag encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByEvaluation?category=%@&tag=%@&offset=%d&limit=%d",Category,enctag,offset,limit];
    
    logString=tag;//返還前のものを保持
    
    NSLog(@"taglist %@",urlString);
    [self start:urlString:0];
}

-(void) getUsersList:(int)uid
{
    loadtype=0;
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getUserInfo/uid:%d",uid];
    NSLog(@"%@",urlString);      
    [self start:urlString:0];    
}
-(void) getAlbumList:(int)uid
{
    loadtype=0;
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getAlbumList/uid:%d",uid];
    NSLog(@"%@",urlString);      
    [self start:urlString:0];
}


- (void)getAlbumimageList:(int)uid: (int)offset:(int)limit:(int)albumid//アルバムリスト一覧
{
    loadtype=4;
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getAlbumimageList/uid:%d/album_id:%d/offset:%d/limit:%d",uid,albumid,offset,limit];
    
    logint1=uid;
    logint2=albumid;
    [self start:urlString:0];
}






//評価順画像一覧を取得します。
-(void)getPostimageByEvaluationList :(int)scrollNum :(NSArray *)taglist :(int)offset :(int)limit
{   
    //タグはURLエンコ
    NSString *encodeString = [taglist encodeString:NSUTF8StringEncoding];
    logString=encodeString;
    logint1=scrollNum;
    
    [self getPostimageByEvaluationList2 :encodeString :offset :limit];
}
-(void)getPostimageByEvaluationList2 :(NSString *)encodeString :(int)offset :(int)limit
{
    loadtype=0;
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByEvaluation?tag=%@&category=%@&offset=%d&limit=%d",encodeString,Category,offset,limit];
    
    //NSLog(@"%@",urlString);    
    [self start:urlString:2];
    
}


/*
 + "/gw/getPostimageByEvaluation?tag="
 + URLEncoder.encode(tag)
 + "&category="
 + URLEncoder.encode(ApplicationSettings
 .getCategoryString()) + "&offset=" + offset
 + "&limit=" + limit);
 */    




//画像検索一覧searchText :0 :0 :0 :40]
-(void)getSearchPostimage :(NSString *)keyword :(int)sort :(int)offset :(int)limit
{
    loadtype=5;
    NSLog(@"getSearchPostimage");
    NSString *enckeyword=[keyword encodeString:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/searchPostimage?keyword=%@&sort=%@&category=%@&offset=%d&limit=%d",enckeyword,sort,Category,offset,limit];
    
    logString=keyword;
    logint1=sort;
    //    NSLog(@"url %@",urlString);
    
    [self start:urlString:0];
}




- (void)getPickupPicture//ピックアップ画像
{
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPickup/category:%@",Category];
    
    //NSLog(@"pickstart %@",urlString);
    [self start:urlString:1];
}



- (void)getPostimageByNewList : (int) newoffset:(int) newlimit//新着画像一覧
{
    loadtype=6;
    int pickupFlag=0;
    //vID=0;
    //vString=@"";
    if(newoffset==-1) 
    {
        pickupFlag=1;
        newoffset=0;//オフセットはゼロにしておく
        offset++;
        //return;
    }
    
    NSString *urlString = [NSString stringWithFormat:DATA_SERVER_URL "gw/getPostimageByNew/category:%@/offset:%d/limit:%d",Category,newoffset,newlimit];
    
    NSLog(@"%@",urlString);
    if(pickupFlag==1) [self start:urlString:3];//ピックアップ表示エリア抜きトップビュー用
    else              [self start:urlString:0];
    
}


//表示タイプ別に分岐
- (void)parseDidEnd:(NSMutableData *)ddata:(int)showType
{	
    NSString *jsonString= [[NSString alloc] initWithData:ddata encoding:NSUTF8StringEncoding];
    NSDictionary * restmp = [jsonString JSONValue]; // SBJsonを使った解析
    
    switch (showType)
    {
        case 1:NSLog(@"pick showType"); [self showImgPicComment:restmp];  break;
        case 2: [self showRankImgList:restmp];  break;
            
        case 3: [self showImgList:restmp:1];  break;    
        case 0:    
        default: [self showImgList:restmp:0];  break; 
    }
    
}


-(void)showEnd
{
    NSLog(@"touch");
	//[pool release];
}






//タップされた画像のIDを元に詳細ページへジャンプ
-(void)buttonTouched:(id)sender
{
    UIAsyncImageView *ai = [(UIAsyncImageView *)sender view];   
    
    //if(ai.accessibilityLabel==nil) return;
    // UITapGestureRecognizer *tap;
    //tap = (UITapGestureRecognizer *)sender; 
    
    
    // NSLog(@"sender %@",sender);      
    NSLog(@"ai.tag %d",ai.tag);  
    NSString *idstring =[NSString stringWithFormat:@"%d",ai.tag];
    NSDictionary *dic= [NSDictionary dictionaryWithObject:idstring forKey:@"imageID"];
    
    // 通知を作成する
    NSNotification *n = [NSNotification notificationWithName:@"Tuchi" object:self userInfo:dic];
    
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
}




-(void)showImgList:(NSDictionary *)restmp:(int)pickupFlag//:(NSString *)pickupString:(int)pickupID
{
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return;
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    int nextsizeY=(int)[thumbnailView bounds].size.height;
    int imgWidth= 100;
    int imageMarginH =8;
	int basex = 0;
	int imageMargin=6;
    int sideCount=3;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // SBJSONを使ったJSONデータのパース処理
    
    
    //ピックアップ画像分をあけて表示
    int addPosition=0;
    if(pickupFlag!=0)
    {
        addPosition=1;
        NSLog(@"test");
        
        //ピックアップ画像
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setTitle:@"" forState:UIControlStateNormal];
        [iconButton setBackgroundImage:[UIImage imageNamed:@"top_pickup.png"] forState:UIControlStateNormal];
        //[iconButton sizeToFit];
        iconButton.frame = CGRectMake(31, 4, 76, 18);//画像サイズがいかなる場合でも77×77にする
        iconButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //[iconButton addTarget:viewController1 action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
        //iconButton.center = CGPointMake(6, 51);
        //iconButton.contentMode = UIViewContentModeScaleToFill;
        [thumbnailView addSubview:iconButton];
    }
    
    int newbasey=basey;
    
    
    // NSLog(@"show %d",cnt);
    int i=0;
    for (i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        
        NSLog(@"%@",result);
        for (NSDictionary *dic in result) 
        {
            basex= 4+(addPosition%sideCount *imgWidth)+(addPosition%sideCount *imageMargin);
            basey= newbasey+(addPosition/sideCount *imgWidth)+(addPosition/sideCount *imageMarginH);
            addPosition++;
            
            //   NSLog(@"list表示");
            //NSString *imageID=[dic objectForKey:@"post_image_id"];
            NSString* imageIDString=[dic objectForKey:@"post_image_id"];
            if(imageIDString==nil) return;
            
            
            int imageID= [imageIDString integerValue];
            NSLog(@"%d",imageID);
            
            
            //非同期画像読み込み
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] initWithFrame:CGRectMake(basex, basey, imgWidth, imgWidth)];
            ai.tag=imageID;
            //ai.accessibilityLabel=[NSString stringWithFormat:@"%d",imageID];
            
            //NSLog(@"buttonTouched %@",ai.accessibilityLabel);  
            [ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            //タップジェスチャー
            UITapGestureRecognizer *tap;
            tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
            //tap.=imageID;//
            [ai addGestureRecognizer:tap];
            
            
            
            
            
            [thumbnailView addSubview:ai];
            
            
            
            //格子背景の設置
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_bg2.png"]];
            img.frame = CGRectMake(0, ((i+1/3)*108)+newbasey-4, 320, 109);//108 109
            [thumbnailView addSubview: img];  
            
            
            [img release];
            if(tagpage_flag ==1)
            {
                
                UILabel *pictRankLabel01 = [[UILabel alloc] init];
                switch (nowTagNum) 
                {
                    case 0:
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:1.0 green:0.647 blue:0.7 alpha:1.0];
                        break;
                    case 1:            
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.847 green:0.824 blue:0.137 alpha:1.0];
                        break;
                    case 2:            
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.553 green:0.831 blue:0.471 alpha:1.0];
                        break;
                    case 3:            
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.478 green:0.686 blue:0.925 alpha:1.0];
                        break;
                    case 4:            
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:1.0 green:0.647 blue:0.7 alpha:1.0];                    break;
                    case 5:          
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.847 green:0.824 blue:0.137 alpha:1.0];                      break;
                    case 6:            
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.553 green:0.831 blue:0.471 alpha:1.0];
                        break;
                    case 7:            
                        
                        pictRankLabel01.backgroundColor = [UIColor colorWithRed:0.478 green:0.686 blue:0.925 alpha:1.0];
                        break;
                        
                    default:
                        break;
                }
                pictRankLabel01.frame = CGRectMake(3+(i%3*107), 88+(i/3)*108, 16, 16);
                pictRankLabel01.textColor = [UIColor whiteColor];
                pictRankLabel01.font = [UIFont boldSystemFontOfSize:12];
                pictRankLabel01.textAlignment = UITextAlignmentCenter;
                pictRankLabel01.text = [NSString stringWithFormat:@"%d",i+1];
                [thumbnailView addSubview:pictRankLabel01];
                [pictRankLabel01 release];
                
                if(i ==100)tagpage_flag =0;
            }
            
            //長押し削除
            int imgUid=[[dic objectForKey:@"uid"] integerValue];
            if(imgUid==uid ||loadtype==4)
            {
                UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
                
                [ai addGestureRecognizer:longPressGesture];
                [longPressGesture release];                
            }
            [ai release];        
        }
    }
    
    
    //サイズの本指定
    [thumbnailView setContentSize:CGSizeMake([thumbnailView bounds].size.width,basey+ 358)];
	[pool release];
    
    loadflag=0;
}


//長押し検出　投稿削除 アルバム削除
- (void) handleLongPressGesture:(UILongPressGestureRecognizer*) sender
{
    UIAsyncImageView *ai=sender.view;
    NSLog(@"long press %d",ai.tag);
    
    if(alertflag==1) return;
    alertflag=1;
    
    [NSThread sleepForTimeInterval:0.5];
    
    NSString *alertTitle=@"";
    NSString *alertMess=@"";
    if(loadtype==4)
    {
        alertTitle=@"写真の削除";
        alertMess=@"アルバムから写真を削除します。";
    }
    else
    {
        alertTitle=@"投稿写真の削除";
        alertMess=@"投稿した写真を削除します。\n※印この操作は元に戻す事が出来ません。";
    }
    
    
    //投稿写真の削除
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:alertTitle
                          message:alertMess
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:@"キャンセル",nil];
    alert.tag=ai.tag;
    //    [alert sleepForTimeInterval:1.0];
    
    
    [alert show];
    [alert release];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    switch (buttonIndex) 
    {
        case 0:
            NSLog(@"hai");
            int imageID =alertView.tag;
            
            NSLog(@"imageid %d",imageID);
            
            loadingAPI *loadingapi = [[loadingAPI alloc] init];
            
            if (loadtype==4)
            {
                [loadingapi deleteAlbumimage:logint2:imageID];
            }
            else
            {
                [loadingapi deletePostimage:imageID];
            }
            
            
            //リロード
            UIView *uv = [[UIView alloc] init];
            uv.frame = self.view.bounds;
            uv.backgroundColor = [UIColor whiteColor];
            [thumbnailView addSubview:uv];
            
            SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
            
            int offset=0;
            int limit=30;
            
            if (loadtype==4)
            {
                [searchViewCtrl getAlbumimageList:Uid:offset:limit:logint2];
            }
            else
            {
                [searchViewCtrl getAlbumimageList:Uid:offset:limit:0];
            }
            [thumbnailView addSubview:searchViewCtrl.view];   
            
            break;
        default:
        case 1: 
            NSLog(@"iie");
            break;
    }
    alertflag=0;
    
}



-(void)showImgPicComment:(NSDictionary *)restmp
{
    NSLog(@"pickup到達");
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return;
    
    int imgWidth= 100;
	int basex = 4;
	int basey = 4;
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog("res%@",result);
        for (NSDictionary *dic in result) 
        {
            int imageID=[[dic objectForKey:@"post_image_id"] integerValue];
            
            //非同期画像読み込み
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] initWithFrame:CGRectMake(basex, basey, imgWidth, imgWidth)];
            ai.tag=imageID;
            
            [ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            ai.userInteractionEnabled=YES;
            
            //タップジェスチャー
            UITapGestureRecognizer *tap;
            tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
            [ai addGestureRecognizer:tap];
            
            
            
            [thumbnailView addSubview:ai];
            [ai release];
        }
    }
}





//ランキングビューコントローラーリスト
-(void)showRankImgList:(NSDictionary *)restmp
{
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return;
    
    const CGFloat kScrollObjHeight2	= 100.0;
    const CGFloat kScrollObjWidth2	= 100.0;
    const NSUInteger kNumImages2	= 10;
    
	int imgWidth= 100;
	int basex = 0;
	int basey = 0;
	int imageMargin=20;
    int sideCount=10;
    
    CGFloat curXLoc = 0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    for (int i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {        
            UIAsyncImageView *ai = [[UIAsyncImageView alloc] initWithFrame:CGRectMake(basex, basey, imgWidth, imgWidth)];
            [ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
            
            [thumbnailView addSubview:ai];
            [ai release];
            
            
            basex = (i%sideCount *imgWidth)+(i%sideCount *imageMargin);
            //basey = 0;//(i/sideCount *imgWidth)+(i/sideCount *imageMargin); 
        }
    }
    
    [thumbnailView setContentSize:CGSizeMake((kNumImages2 * kScrollObjWidth2), [thumbnailView bounds].size.height)];
    [thumbnailView setContentSize:CGSizeMake([thumbnailView bounds].size.width,basey)];
    [pool release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}




//スクロールで再ロード
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{  
    //広告を消す
   // _topViewController = [[TopViewController alloc]init];
   // NSLog(@"top %@",_topViewController);
    
    //[_topViewController delAd];
   // _topViewController.adBanner.hidden =YES;
    if(adBanner_ !=nil)
    {
        [self delAd];
    }
    
    
    if(loadtype!=6) return;//新着以外は読まない
    //if(loadtype==0) return;
    
    CGRect r = scrollView.bounds;
    NSLog(@"scr %@",[NSString stringWithFormat:@"%lf", r.origin.y]);
    NSLog(@"basey %d",basey);
    
    if(loadflag==1) return;
    
    //次スクロールビューのロード
    // int nowY=107*((offset+limit)/3);
    //int addY=(107*(limit/3))+self.view.bounds.size.height;
    if(r.origin.y>basey-200)
    {
        loadflag=1;
        basey +=107;//１列分追加
        //SearchViewCtrl *search = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
        
        /*  UIView *uv = [[UIView alloc] init];
         uv.frame = self.view.bounds;
         uv.backgroundColor = [UIColor whiteColor];
         [self.view addSubview:uv];
         */
        
        // [thumbnailView setContentSize:CGSizeMake(320,addY)];
        
        //uv.frame = thumbnailView.bounds;
        
        
        NSLog(@"offset %d",self->offset);
        self->offset=self->offset+self->limit;
        self->limit =45;//self->limit;
        
        
        switch (loadtype) 
        {
            case 0:
                //[self getUsersList:(int)uid]; 
                //[self getAlbumList:(int)uid];
                break;
            case 1:
                [self getTagLists:logString:self->offset:self->limit]; 
                break;         
            case 2:
                break;         
            case 3: 
                [self getPostimageByEvaluationList2:logString :(int)offset :(int)limit];
                break;         
            case 4:
                [self getAlbumimageList:logint1:self->offset:self->limit:logint2]; 
                break;         
            case 5:
                [self getSearchPostimage :logString :logint1 :self->offset:self->limit]; 
                break;         
            case 6:    
            default:
                [self getPostimageByNewList :self->offset:self->limit];   
                break;
        }    
    }
}



- (void)dealloc {
    [super dealloc];
}



//広告の表示非表示/////////////////////////////////////////////////////////////
-(void)bannerLoad:(TopViewController *)top
{
    self.adBanner = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                     self.view.frame.size.height,
                                                                     GAD_SIZE_320x50.width,
                                                                     GAD_SIZE_320x50.height)] autorelease];
    self.adBanner.adUnitID = MY_BANNER_UNIT_ID;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    [top.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self createRequest]];
    
    //adBanner_=self.adBanner;
}


- (void)delAd
{
    NSLog(@"deladd %@",adBanner_);
    //    self.adBanner.hidden =YES;
    adBanner_.hidden=YES;
    // 時間差で広告を出す
    [self performSelector:@selector(showAd) withObject:@"ほげ" afterDelay:3.0f];
}
-(void)showAd
{
    //    self.adBanner.hidden =NO;
    adBanner_.hidden=NO;
    
}



#pragma mark GADRequest generation

// Here we're creating a simple GADRequest and whitelisting the simulator
// and two devices for test ads. You should request test ads during development
// to avoid generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    //Make the request for a test ad
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,                               // Simulator
                           nil];
    
    return request;
}

#pragma mark GADBannerViewDelegate impl

//グーグルアドセンス処理
// Since we've received an ad, let's go ahead and set the frame to display it.
- (void)adViewDidReceiveAd:(GADBannerView *)adView 
{
    NSLog(@"Received ad");
    
    //[UIView animateWithDuration:1.0 animations:^ {
        adView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  adView.frame.size.height-47,
                                  adView.frame.size.width,
                                  adView.frame.size.height);
        
    //}];
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error 
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


@end
