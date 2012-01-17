#import "BadgViewController.h"
#import "dataButton.h"


@implementation BadgViewController
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

- (void)viewDidLoad
{
    NSLog(@"re_num%d",re_num);
    [scrollView setContentSize:CGSizeMake(320,1486)];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    // UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, 1000)];
    // sv.backgroundColor = [UIColor cyanColor];
    
    //UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 1000)];
    //[sv addSubview:uv];
    //sv.contentSize = uv.bounds.size;
    //[self.view addSubview:sv];
    
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getDecorationList:re_num];
    NSLog(@"deco %@",restmp);
    
    int i=0;
    int imgWidth=100;
    int imageMargin=40;
    int sideCount=3;
    int basex=2;
    int basey=4;
    
    int cnt = [[restmp objectForKey:@"result"] count];
    for (i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            // NSString *userName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];//名前
            // NSLog(@"decouser %@",userName);
            NSString *decoName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"decoration_name"]];//デコ名
            NSString *get_date=[NSString stringWithFormat:@"%@",[dic objectForKey:@"get_date"]];//
            UIImage *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_url"]];//アイコン画像
            NSLog(@"decoU %@",imageURL);
            
            
            int decoID=[[dic objectForKey:@"decoration_id"] integerValue];//デコID
            //NSLog(@"decoid %d",decoID);
            
            NSURL *url= [NSURL URLWithString: imageURL];
            NSData *data = [NSData dataWithContentsOfURL: url];
            // NSLog(@"data %@",data);
            
            // UIButtonを追加
            dataButton *button = [[dataButton alloc] initWithTitle:@"" data:get_date];
            
            button.frame = CGRectMake(basex, basey, imgWidth, imgWidth);
            [button setBackgroundImage:[UIImage imageWithData: data] forState:UIControlStateNormal];
            if(decoID == 8001)
            {
                UIImage *deco_sp02 = [UIImage imageNamed:@"badge04_02.png"];
                [button setBackgroundImage:deco_sp02 forState:UIControlStateNormal];
            }
            if(decoID == 8000){
                
                UIImage *deco_sp01 = [UIImage imageNamed:@"badge04_01.png"];
                [button setBackgroundImage:deco_sp01 forState:UIControlStateNormal];
            }
            button.tag=decoID;
            // button.accessibilityHint = get_date;
            [button addTarget:self action:@selector(ShowActivity:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:button];
            
            //ユーザー名
            UILabel *uLabel = [[UILabel alloc] init];
            uLabel.backgroundColor = [UIColor clearColor];
            [uLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel setNumberOfLines:0];
            
            uLabel.frame = CGRectMake(basex+5, basey + 100, 95, 50);
            uLabel.textColor = [UIColor grayColor];
            uLabel.font = [UIFont boldSystemFontOfSize:12];
            uLabel.textAlignment = UITextAlignmentLeft;
            uLabel.text = decoName;
            [scrollView addSubview:uLabel];
            
            basex = 2+((i+1)%sideCount *imgWidth)+((i+1)%sideCount+10);
            basey = 4+((i+1)/sideCount *imgWidth)+((i+1)/sideCount *imageMargin);  
        }
    }
    //super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

-(void)buttonTouched:(UIButton*)button
{
    NSLog(@"decobutton %d",button.tag);
    /*
     _detalisViewController = [[DetalisViewController alloc]initWithNibName:@"DetalisViewController" bundle:nil];
     [self.navigationController pushViewController:_detalisViewController animated:YES];
     */
}

- (void)ShowActivity:(dataButton *)sender;
{
    NSLog(@"%d",sender.tag); 
    NSLog(@"%@",sender.accessibilityHint); 
    NSString *date = [sender.data substringToIndex:16];
    
    NSLog(@"%@",date); 
    //Activityの有無を確認
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getDecorationList:re_num];
    
    int i;
    int cnt = 1;//[[restmp objectForKey:@"result"] count];
    
    //アクティビティなし
    if(cnt<=0) return;
    
    
    NSString *actMsg=@"";
    NSString *actTitle=@"";
    NSString *pic_path=@"badge03_01.png";
    NSString *activity_type;
    int activity_id;
    for (i=0; i<cnt; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        //NSLog(@"res %@",result);
        for (NSDictionary *dic in result) 
        {
            activity_type=[dic objectForKey:@"activity_type"];
            activity_id=[[dic objectForKey:@"activity_id"] integerValue];
            
            if (sender.tag==9900)
            {
                actTitle = @"スタートアップ";
                actMsg=@"スタートアップ参加！／スタートアップバッジを入手！";
                pic_path=@"badge03_01.png";
            }
            else if (sender.tag==9901)
            {
                actTitle = @"ハッピーバスデー";
                actMsg=@"お誕生日おめでとう！／ハッピーバスデーバッジを入手！";
                pic_path=@"badge03_02.png";
            }
            //
            else if(sender.tag==1100)
            {
                actTitle = @"SNS投稿デビュー";
                actMsg=@"初めてのSNS投稿！／SNS投稿デビューバッジを入手！";
                pic_path=@"badge02_01.png";        
            }
            else if(sender.tag==1101)
            {
                actTitle = @"Thanks share!ブロンズ";
                actMsg=@"SNS投稿×10回達成！／「Thanks share!ブロンズ」バッジを入手！";
                pic_path=@"badge02_02.png";        
            }
            else if(sender.tag==1102)
            {
                actTitle = @"Thanks share!シルバー";
                actMsg=@"SNS投稿×50回達成！／「Thanks share!シルバー」バッジを入手！";
                pic_path=@"badge02_03.png";        
            }
            else if(sender.tag==1103)
            {
                actTitle = @"Thanks share!ゴールド";
                actMsg=@"SNS投稿×100回達成！／「Thanks share!ゴールド」バッジを入手！";
                pic_path=@"badge02_04.png";        
            }
            else if(sender.tag==1104)
            {
                actTitle = @"Thanks share!ダイヤ";
                actMsg=@"SNS投稿×300回達成！／「Thanks share!ダイヤ」バッジを入手！";
                pic_path=@"badge02_05.png";        
            }
            //
            else if(sender.tag==1000)
            {
                actTitle = @"イイネデビュー";
                actMsg=@"初めてのイイネ！／イイネデビューバッジを入手！";
                pic_path=@"badge01_01.png";        
            }
            else if(sender.tag==1001)
            {
                actTitle = @"ドッグリスト";
                actMsg=@"イイネ×5回達成！／「ドッグリスト」バッジを入手！";
                pic_path=@"badge01_02.png"; 
            }
            else if(sender.tag==1002)
            {
                actTitle = @"隠れネコ派";
                actMsg=@"隠れネコ派バッジを入手！";
                pic_path=@"badge01_03.png";
            }
            else if(sender.tag==1003)
            {
                actTitle = @"ブロンズ・ドッグリスト";
                actMsg=@"イイネ×10回達成！／「ブロンズ・ドッグリスト」バッジを入手！";
                pic_path=@"badge01_04.png";
            }
            else if(sender.tag==1004)
            {
                actTitle = @"シルバー・ドッグリスト";
                actMsg=@"イイネ×50回達成！／「シルバー・ドッグリスト」バッジを入手！";
                pic_path=@"badge01_05.png";
            }
            else if(sender.tag==1005)
            {
                actTitle = @"ゴールデン・ドッグリスト";
                actMsg=@"イイネ×100回達成！／「ゴールデン・ドッグリスト」バッジを入手！";
                pic_path=@"badge01_06.png";
            }
            else if(sender.tag==1006)
            {
                actTitle = @"キャットリスト";
                actMsg=@"イイネ×5回達成！／「キャットリスト」とバッジを入手！";
                pic_path=@"badge01_07.png";
            }
            else if(sender.tag==1007)
            {
                actTitle = @"隠れ犬派";
                actMsg= @"隠れ犬派バッジを入手！";
                pic_path=@"badge01_08.png";
            }
            else if(sender.tag==1008)
            {
                actTitle = @"ブロンズ・キャットリスト";
                actMsg=@"イイネ×10回達成！／「ブロンズ・キャットリスト」バッジを入手！";
                pic_path=@"badge01_09.png";
            }
            else if(sender.tag==1009)
            {
                actTitle = @"シルバー・キャットリスト";
                actMsg=@"イイネ×50回達成！／｢シルバー・キャットリスト｣バッジを入手！";
                pic_path=@"badge01_10.png";
            }
            else if(sender.tag==1010)
            {
                actTitle = @"ゴールデン・キャットリスト";
                actMsg=@"イイネ×100回達成！／「ゴールデン・キャットリスト」バッジを入手！";
                pic_path=@"badge01_11.png";
            }
            else if(sender.tag==8000)
            {
                actTitle = @"よくできました";
                actMsg=@"おめでとうございます！あなたの投稿した写真に5人のｆａｎが「イイネ!」をつけましたので「よくできました」バッジを入手!";
                pic_path=@"badge04_01.png";
            }
            else if(sender.tag==8001)
            {
                actTitle = @"たいへんよくできました";
                actMsg=@"おめでとうございます！あなたの投稿した写真に50人のｆａｎが「イイネ!」をつけましたので「よくできました」バッジを入手!";
                pic_path=@"badge04_02.png";
            }
            
            
            //Activiy update proc
            //半透明の黒背景背景
            badgView[i] = [[UIView alloc] initWithFrame:[[self view] bounds]];
            [badgView[i] setBackgroundColor:[UIColor blackColor]];
            [badgView[i] setAlpha:0.5];
            [[self view] addSubview:badgView[i]];
            
            //スクロールビューを定義
            badgSv[i] = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 60, 240, 340)];
            badgSv[i].backgroundColor = [UIColor whiteColor];
            badgSv[i].layer.masksToBounds = YES;  
            badgSv[i].layer.cornerRadius = 10; 
            [badgSv[i] setAlpha:0.0];
            
            //アニメーションの対象となるコンテキスト
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            //アニメーションを実行する時間
            [UIView setAnimationDuration:0.5];
            //アニメーションイベントを受け取るview
            [UIView setAnimationDelegate:self];
            //アニメーション終了後に実行される
            [UIView setAnimationDidStopSelector:@selector(endAnimation)];
            
            //TODO: 
            [badgSv[i] setAlpha:1.0];
            // アニメーション開始
            [UIView commitAnimations];	
            
            
            //チュートリアル画像を追加
            img = [UIImage imageNamed:pic_path];
            iv = [[UIImageView alloc] initWithImage:img];
            iv.center = CGPointMake(120, 110);
            
            badgSv[i].contentSize = iv.bounds.size;
            
            //ユーザー名
            UILabel *uLabel = [[UILabel alloc] init];
            uLabel.backgroundColor = [UIColor clearColor];
            [uLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel setNumberOfLines:0];
            
            uLabel.frame = CGRectMake(20, 245 , 200, 70);
            uLabel.font = [UIFont boldSystemFontOfSize:12];
            uLabel.minimumFontSize = 8.0;
            uLabel.textAlignment = UITextAlignmentLeft;
            uLabel.adjustsFontSizeToFitWidth = YES;
            
            uLabel.text = actMsg;
            
            UILabel *uLabel2 = [[UILabel alloc] init];
            uLabel2.backgroundColor = [UIColor clearColor];
            [uLabel2 setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel2 setNumberOfLines:0];
            
            uLabel2.frame = CGRectMake(20, 190 , 200, 70);
            //uLabel.textColor = [UIColor Color];
            uLabel2.font = [UIFont boldSystemFontOfSize:17];
            uLabel2.textAlignment = UITextAlignmentLeft;
            uLabel2.text = actTitle;
            
            UILabel *uLabel3 = [[UILabel alloc] init];
            uLabel3.backgroundColor = [UIColor clearColor];
            [uLabel3 setLineBreakMode:UILineBreakModeWordWrap];//改行モード
            [uLabel3 setNumberOfLines:0];
            
            uLabel3.frame = CGRectMake(20, 285 , 200, 70);
            //uLabel.textColor = [UIColor Color];
            uLabel3.font = [UIFont boldSystemFontOfSize:14];
            uLabel3.textAlignment = UITextAlignmentLeft;
            uLabel3.text = date;
            
            [badgSv[i] addSubview:uLabel];
            [badgSv[i] addSubview:uLabel2];
            [badgSv[i] addSubview:uLabel3];
            
            //スクロールを描画
            [self.view addSubview:badgSv[i]];
            //チュートリアルを描画
            [badgSv[i] addSubview:iv];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.hidden =NO;
            btn.tag=i;
            btn.frame = CGRectMake(0, 0, 240, 280);
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal]; 
            [btn addTarget:self action:@selector(hoge2:)forControlEvents:UIControlEventTouchDown];
            
            [badgSv[i] addSubview:btn];
            
            //[loadingapi updateReadFlag:];
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
}


@end
