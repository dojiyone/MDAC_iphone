
#import "SearchViewController.h"
#import "SearchViewCtrl.h"
#import "loadingAPI.h"

@implementation SearchViewController


-(void) viewDidLoad
{
    
    
    //[scrollView setContentSize:CGSizeMake(320,1486)];
    
    NSLog(@"@%@",[self nibName]);
    
    UISearchBar *sb = [[[UISearchBar alloc] init] autorelease];
    sb.frame=CGRectMake(0, 45, 320, 45);
    sb.delegate = self;
    [sb sizeToFit];
    sb.showsCancelButton = NO;
    sb.prompt = @"";
    sb.placeholder = @"検索ワードを入力してください";
    sb.keyboardType = UIKeyboardTypeDefault;
    sb.tintColor=[UIColor orangeColor];
    [self.view addSubview:sb];
    
    
    //詳細はどこをを経由したか？YES
    //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"FROM_ALBUM_FLAG"];

    
    
    // テーブルのヘッダーに配置する場合
    //tableView.tableHeaderView = sb;
}


-(void)viewWillAppear:(BOOL)animated{
    
}

//ロード完了読み込み
- (void)viewDidAppear:(BOOL)animated
{
    [self nextDataLoadSearch];
    
    [self netAccessEnd];
}

- (void)nextDataLoadSearch
{
    
    
}


-(void)searchItem:(NSString *)searchText
{
    NSLog(@"item");
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"button %@",searchBar.text);
    [self getSearchData:searchBar.text];
    [searchBar resignFirstResponder];//検索入力エリア閉じる
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //if([searchText length]!=0)
}


- (void)getSearchData:(NSString *)searchText
{ 
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:uv];
    
    NSLog(@"text %@",searchText);
    
    //loadingapi = [[loadingAPI alloc] init]; 
    //NSDictionary *restmp=[loadingapi searchPostimage:searchText:0:0:0:40];
    //[self showImgListSearch:restmp];
    
    
	SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
	[scrollView addSubview:searchViewCtrl.view];
    
    //キーワード画像検索　ソート　カテゴリ　オフセット　リミット
    [searchViewCtrl getSearchPostimage :searchText :0 :0 :40];
    
    
    /*
     //ここのDetail移動メソッドは相談
     UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 32, kScrollObjWidth, kScrollObjHeight)];
     [button setBackgroundImage:[UIImage imageNamed:@"bg.png"]
     forState:UIControlStateNormal];
     [button addTarget:self action:@selector(deleteButtonPressed:) 
     forControlEvents:UIControlEventTouchUpInside];
     [scrollView addSubview:button];
     */
    // Override point for customization after application launch
    //[self makeKeyAndVisible];
}

/*
 - (void)showImgListSearch:(NSDictionary *)restmp
 {
 int nextsizeY=(int)[thumbnailView bounds].size.height;
 int imgWidth= 100;
 int basex = 0;
 int basey = 0;
 int imageMargin=10;
 int sideCount=3;
 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 // SBJSONを使ったJSONデータのパース処理
 int i=0;
 for (i=0; i<30; i++) 
 {
 NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
 //NSLog("res%@",result);
 for (NSDictionary *dic in result) 
 {
 //UIAsyncImageView *ai = [[UIAsyncImageView alloc] initWithFrame:CGRectMake(basex, basey, imgWidth, imgWidth)];
 //[ai changeImageStyle:[dic objectForKey:@"real_path"] :imgWidth:imgWidth :2:2 :@"" :0 :0 :0:0 :0 :0:0];
 //ai.userInteractionEnabled = YES;
 
 //   [thumbnailView addSubview:ai];
 
 UIImage *image;
 NSString *urlString = [NSString stringWithFormat:CV_SERVER_URL "%@?sr.dw=100&sr.dh=100&sr.cx=2&sr.cy=2",[dic objectForKey:@"real_path"]];
 NSURL *url= [NSURL URLWithString: urlString];
 NSData *data = [NSData dataWithContentsOfURL: url];
 image = [UIImage imageWithData: data];
 
 // UIButtonを追加
 UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(basex, basey, imgWidth, imgWidth)];
 [button setBackgroundImage:image forState:UIControlStateNormal];
 
 
 // NSString *imageID=[dic objectForKey:@"image_id"];
 int imageID=[[dic objectForKey:@"image_id"] integerValue];
 //NSLog(@"%d",imageID);
 button.tag=imageID;
 //[button setTitle:imageID forState:UIControlStateNormal];
 
 [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
 [thumbnailView addSubview:button];
 
 // [ai release];
 
 basex = (i%sideCount *imgWidth)+(i%sideCount *imageMargin);
 basey = (i/sideCount *imgWidth)+(i/sideCount *imageMargin);
 }
 }
 [thumbnailView setContentSize:CGSizeMake([thumbnailView bounds].size.width,basey)];
 
 //UIScrollView *thumbnailView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,nextsizeY,[thumbnailView bounds].size.width,basey)];
 //[thumbnailView2 addSubview:thumbnailView];
 [pool release];
 }
 */



-(IBAction) back_btn_down:(id)sender;
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
