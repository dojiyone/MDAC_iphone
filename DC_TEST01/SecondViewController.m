//
//  SecondViewController.m
//  DC_TEST01
//

#import "SecondViewController.h"
#import "NSString+Encode.h"
#import "MixiTestViewController.h"
#import "FBTestViewController.h"
#import "TwTestViewController.h"
#import "loadingAPI.h"


@class MixiTestViewController;
@class FBTestViewController;
@class TwTestViewController;
@class UIWebviewDelegate;


@implementation SecondViewController

@synthesize authorize_uri = _authorize_uri;
@synthesize response_uri = _response_uri;
@synthesize web_view = _web_view;
@synthesize caller = _caller;
//@synthesize webview_delegate = _webview_delegate;
@synthesize params = _params;
@synthesize pin = _pin;

- (void)viewDidLoad
{
    //[super viewDidLoad];
    
    /*
     usrName=@"";
     passcode=@"";
     
     //ユーザー名
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     int mdacUid=[[defaults stringForKey:@"MDAC_UID"] intValue]; 
     
     //APIの呼び出し
     loadingAPI* loadingapi=[[loadingAPI alloc] init];
     NSDictionary *restmp=[loadingapi getUserInfo:mdacUid];//APIメソッド
     
     NSLog(@"受け取りデータ一覧%@", restmp);
     NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:0];
     for (NSDictionary *dic in result) 
     {
     usrName= [dic objectForKey:@"name"];
     passcode= [dic objectForKey:@"pass_code"];
     }
     
     */
    
    
    // Twitter
    viewController3 = [[TwTestViewController alloc] init]; //initWithNibName:@"SecondView" bundle:nil] autorelease];
    
    // facebook
    viewController2 = [[FBTestViewController alloc] init];//initWithNibName:@"SecondView" bundle:nil] autorelease];
    
    // mixi
    viewController1 = [[MixiTestViewController alloc] init];//initWithNibName:@"SecondView" bundle:nil] autorelease];
    
    viewController1->_secondview=self;
    viewController2->_secondview=self;
    viewController3->_secondview=self;
    
    
    //[self.view addSubview:_viewController1.view];  // mixiボタン
    //[self.view addSubview:_viewController2.view]; // FBボタン
    //[self.view addSubview:_viewController3.view]; // Twitterボタン
    
    
    //[self loginButton];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    delCheck=0;
    
    
    // 表示するデータを作成
    keys_ = [[NSArray alloc] initWithObjects:@"SNS設定",@"",@"一般設定",@"ユーザー設定",nil];
    NSArray* object1 = [NSArray arrayWithObjects:@"メインSNS",@"ユーザー名",nil];
    NSArray* object2 = [NSArray arrayWithObjects:@"twitter",@"facebook",@"mixi",nil];
    NSArray* object3 = [NSArray arrayWithObjects:@"ヘルプ",@"チュートリアル",@"バージョン情報",@"利用規約",@"プライバシーポリシー",@"お問い合わせ",nil];
    NSArray* object4 = [NSArray arrayWithObjects:@"ユーザー情報の移行",@"退会",nil];
    NSArray* objects = [NSArray arrayWithObjects:object1, object2, object3, object4, nil];
    dataSource_ = [[NSDictionary alloc] initWithObjects:objects forKeys:keys_];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int Uid=[[defaults stringForKey:@"MDAC_UID"] intValue];
    
    //APIの呼び出し
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi getUserInfo:Uid];
    NSLog(@"1 %@",restmp);
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];//名前
        }
    }
    
    NSLog(@"name %@",name);
}

-(void)viewWillAppear:(BOOL)animated{
    
}



- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    id key = [keys_ objectAtIndex:section];
    return [[dataSource_ objectForKey:key] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    snsName=[defaults stringForKey:@"SNS_NAME"]; 
    usrName=[defaults stringForKey:@"MAIN_NAME"];
    
    static const id identifiers[4] = {@"sns-cell",@"second-cell",@"basis-cell",@"user-cell"};
    NSString* identifier = identifiers[indexPath.section];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( nil == cell ) {
        if (indexPath.section == 0) {
            
            switch(indexPath.row){
                case 0:                     
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    
                    cell.detailTextLabel.text = snsName;
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                case 1:              
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];    
                    
                    cell.detailTextLabel.text = usrName;
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
            }
        }
        
        
        else if(indexPath.section == 1){
            switch(indexPath.row){
                case 0:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self switchForCell:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
                case 1:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self switchForCell2:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
                case 2:                   
                    cell = [[[UITableViewCell alloc] 
                             initWithStyle:UITableViewCellStyleValue1 
                             reuseIdentifier:identifier] 
                            autorelease];       
                    [cell.contentView addSubview:[self switchForCell3:cell]];
                    cell.textLabel.textColor = [UIColor grayColor];
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
            }
        }
        
        else if(indexPath.section == 2){
            
            cell = [[[UITableViewCell alloc] 
                     initWithStyle:UITableViewCellStyleValue1 
                     reuseIdentifier:identifier] 
                    autorelease];       
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        
        else if(indexPath.section == 3){
            
            cell = [[[UITableViewCell alloc] 
                     initWithStyle:UITableViewCellStyleValue1 
                     reuseIdentifier:identifier] 
                    autorelease];       
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;            
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        
        else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            [cell autorelease];
        }
    }
    id key = [keys_ objectAtIndex:indexPath.section];
    NSString* text = [[dataSource_ objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [keys_ count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return [keys_ objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        switch(indexPath.row)
        {
            case 0: [self changeMainSNS];     break;//MainSNSの設定
                
        }
    }    
    
    if(indexPath.section == 1)
    {
        switch(indexPath.row)
        {
            case 0: ;     break;//Twitter
        }
    }
    
    if(indexPath.section == 2)
    {
        if(indexPath.row==0){
            _helpView = [[HelpView alloc] 
                         initWithNibName:@"HelpView" 
                         bundle:nil];
            [self.navigationController pushViewController:_helpView 
                                                 animated:YES];
        }
        
        if(indexPath.row==1){    
            [self ShowTutorial];
        }
        
        if(indexPath.row==2){    
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"バージョン情報"
                                  message:@"Meet! Dogs'n Cats\nバージョン：1.00"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
        
        if(indexPath.row==3){
            _ruleView = [[ruleView alloc] 
                         initWithNibName:@"ruleView" 
                         bundle:nil];
            [self.navigationController pushViewController:_ruleView 
                                                 animated:YES];
        }
        
        if(indexPath.row==4){
            _policyView = [[policyView alloc] 
                           initWithNibName:@"policyView" 
                           bundle:nil];
            [self.navigationController pushViewController:_policyView 
                                                 animated:YES];
        }
        if(indexPath.row==5){
            [self ShowSupport];
        }
        
    }
    
    if(indexPath.section == 3)
    {
        if(indexPath.row==0)
        {    //移行
            [self shiftUser];
        }
        else if(indexPath.row==1)
        {
            [self deleteUser];
        }
    }
    
}

-(bool)getSnsLoginStatus:(int)snsType
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    // NSString* category=[defaults stringForKey:@"MDAC_CATEGORY"];
    
    NSString* snsid=nil;
    bool result=NO;
    switch(snsType)
    {
        case 1: snsid=[defaults stringForKey:@"TwitterName"]; break;
        case 2: snsid=[defaults stringForKey:@"FBName"]; break;
        case 3: snsid=[defaults stringForKey:@"MixiName"]; break;
    }
    
    if(snsid !=nil) result=YES;
    return result;
}



- (UISwitch*)switchForCell:(const UITableViewCell*)cell 
{
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    bool TwitterSNSlogin =[self getSnsLoginStatus:1];
    if(TwitterSNSlogin == YES){
        theSwitch.on = YES;
        [theSwitch addTarget:self action:@selector(pushSwitch1_off:)
            forControlEvents:UIControlEventValueChanged];
    }
    else{
        theSwitch.on = NO;
        [theSwitch addTarget:self action:@selector(pushSwitch1:)
            forControlEvents:UIControlEventValueChanged];
    }
    
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}

- (UISwitch*)switchForCell2:(const UITableViewCell*)cell {
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    bool FacebookSNSlogin =[self getSnsLoginStatus:2];
    if(FacebookSNSlogin == YES){
        theSwitch.on = YES;
        [theSwitch addTarget:self action:@selector(pushSwitch2_off:)
            forControlEvents:UIControlEventValueChanged];
    }
    else{
        theSwitch.on = NO;
        [theSwitch addTarget:self action:@selector(pushSwitch2:)
            forControlEvents:UIControlEventValueChanged];
        
    }
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}

- (UISwitch*)switchForCell3:(const UITableViewCell*)cell {
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    bool MixiSNSlogin =[self getSnsLoginStatus:3];
    if(MixiSNSlogin == YES){
        theSwitch.on = YES; 
        [theSwitch addTarget:self action:@selector(pushSwitch3_off:)
            forControlEvents:UIControlEventValueChanged];
    }
    else{
        theSwitch.on = NO;    
        [theSwitch addTarget:self action:@selector(pushSwitch3:)
            forControlEvents:UIControlEventValueChanged];
        
    }
    
    
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}

-(void)pushSwitch1:(UISwitch*)theswitch{
    [viewController3 modalButtonDidPush];
}

-(void)pushSwitch2:(UISwitch*)theswitch{
    [viewController2 modalButtonDidPush];
}

-(void)pushSwitch3:(UISwitch*)theswitch{
    [viewController1 modalButtonDidPush];
}

-(void)pushSwitch1_off:(UISwitch*)theswitch{
    //Twitterログアウト処理
    //アクセストークン、アクセストークンシークレットを消す
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Nil forKey:@"TwitterAccessToken"];
    [defaults setObject:Nil forKey:@"TwitterAccessTokenSecret"];
    [defaults setObject:Nil forKey:@"TwitterName"];
    
    NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];
    if([MainSNS isEqualToString:@"twitter"]){
    if([self getSnsLoginStatus:3]==1)[defaults setObject:@"mixi" forKey:@"SNS_NAME"];
    else if([self getSnsLoginStatus:2]==1)[defaults setObject:@"facebook" forKey:@"SNS_NAME"];
    //if([self getSnsLoginStatus:1]==1)[defaults setObject:@"twitter" forKey:@"SNS_NAME"];
    else [defaults setObject:Nil forKey:@"SNS_NAME"];
    }
    
    _secondViewController = [[SecondViewController alloc] 
                             initWithNibName:@"SecondView" 
                             bundle:nil];
	[self.navigationController pushViewController:_secondViewController 
										 animated:YES];
    
    
}

-(void)pushSwitch2_off:(UISwitch*)theswitch{
    //アクセストークン、アクセストークンシークレットを消す
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Nil forKey:@"FBAccessToken"];
    [defaults setObject:Nil forKey:@"FBName"];
    
    NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];
    if([MainSNS isEqualToString:@"facebook"]){
    if([self getSnsLoginStatus:3]==1)[defaults setObject:@"mixi" forKey:@"SNS_NAME"];
    //if([self getSnsLoginStatus:2]==1)[defaults setObject:@"facebook" forKey:@"SNS_NAME"];
    else if([self getSnsLoginStatus:1]==1)[defaults setObject:@"twitter" forKey:@"SNS_NAME"];
    else [defaults setObject:Nil forKey:@"SNS_NAME"];
    }
    
    _secondViewController = [[SecondViewController alloc] 
                             initWithNibName:@"SecondView" 
                             bundle:nil];
	[self.navigationController pushViewController:_secondViewController 
										 animated:YES];
}

-(void)pushSwitch3_off:(UISwitch*)theswitch{
    //Mixiログアウト処理
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Nil forKey:@"MixiAccessToken"];
    [defaults setObject:Nil forKey:@"MixiName"];
    
    //if([self getSnsLoginStatus:3]==1)[defaults setObject:@"mixi" forKey:@"SNS_NAME"];
    //FB
    NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];
    if([MainSNS isEqualToString:@"mixi"]){
        if([self getSnsLoginStatus:2]==1)[defaults setObject:@"facebook" forKey:@"SNS_NAME"];
        
        else if([self getSnsLoginStatus:1]==1)[defaults setObject:@"twitter" forKey:@"SNS_NAME"];
        else [defaults setObject:Nil forKey:@"SNS_NAME"];
    }
    
    _secondViewController = [[SecondViewController alloc] 
                             initWithNibName:@"SecondView" 
                             bundle:nil];
	[self.navigationController pushViewController:_secondViewController 
										 animated:YES];
}





// UITextField で入力を受け付けるかどうかを判断する UITextFieldDelegate メソッドです。

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string

{
    BOOL result;
    
    //文字数を制限
    NSUInteger maxLength=0;
    if(textField.tag==1)       maxLength = 4;
    else if(textField.tag==2)  maxLength = 5;
    else                        return NO;
    
    // iPhone の Return キーが押された場合は "\n" が渡されてくるところに注意します。
    if ([string compare:@"\n"] == 0)        
    {
        // Return キーが押された場合は、文字数に限らず、それを受け入れるようにしておきます。
        result = YES;
    }    
    else
    {
        // Return キーではない場合には、最大文字数を超えないときだけ、受け入れるようにします。
        NSUInteger textLength = textField.text.length;
        NSUInteger rangeLength = range.length;
        NSUInteger stringLength = string.length;
        
        NSUInteger length = textLength - rangeLength + stringLength;
        result = (length <= maxLength);
    }
    
    return result;
}




//ユーザー移行//////////////////////////////////////////////////
-(void) shiftUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //
    if(delCheck==100)
    {
        bool saveCheck=false;
        int uid;
        
        NSString *passNo=textView3.text;//テキストフィールドからパス番号を取得する
        NSString *shiftNo=[NSString stringWithFormat:@"%@%@",textView2.text,textView2_2.text];//テキストフィールドからシフト番号を取得する
        NSLog(@"pass %@ shift %@",passNo,shiftNo);
        
        loadingAPI* loadingapi=[[loadingAPI alloc] init];
        NSDictionary *restmp=[loadingapi processUserShift:shiftNo:passNo];
        
        NSString *altitle=@"確認";
        NSString *almes=@"受付番号か暗証番号が違います。";
        if([[restmp objectForKey:@"result"] count]>0)
        {
            altitle=@"完了";
            almes=@"ユーザー情報の移行を行いました。";
            for (int i=0; i<1; i++) 
            {
                NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
                for (NSDictionary *dic in result) 
                {
                    uid=[[dic objectForKey:@"uid"] integerValue];
                    NSString *pass_code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pass_code"]];
                    
                    [defaults setInteger:uid forKey:@"MDAC_UID"];
                    [defaults setObject:pass_code forKey:@"MDAC_PASSCODE"];
                    saveCheck=true;
                    
                    
                }
            }
        }
        
        if(saveCheck==true)
        {
            restmp=[loadingapi getUserInfo:uid];
            for (int i=0; i<1; i++) 
            {
                NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
                for (NSDictionary *dic in result) 
                {
                    NSString *newName=
                    [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    [defaults setObject:newName forKey:@"MAIN_NAME"];
                }
            }
            
            // [loadingapi changeProfile:newName :profComment :birthDay];
        }
        
        
        
        NSLog(@"res %@",restmp);
        UIAlertView *alert = [[UIAlertView alloc]//移行
                              initWithTitle:altitle
                              message:almes
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag=101;
        [alert show];
        [alert release];
        delCheck=0;
        return;
    }
    else if([defaults stringForKey:@"MDAC_UID"]==nil)
    {        
        //未ログインユーザーの場合        
        UIAlertView *alert = [[UIAlertView alloc]//移行
                              initWithTitle:@"ユーザー情報の移行"
                              message:@"受付番号（数字１０桁）\n—\n\n暗証番号（数字４桁）\n\n"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"キャンセル",nil];
        //textView2 =[[UITextField alloc] initWithFrame:CGRectMake(100.0, 67.0, 80.0, 24.0)];     
        //textView3 =[[UITextField alloc] initWithFrame:CGRectMake(70.0, 127.0, 140.0, 24.0)];
        
        //受付番号
        textView2 =[[UITextField alloc] initWithFrame:CGRectMake(50.0, 67.0, 80.0, 24.0)];
        textView2.borderStyle=UITextBorderStyleRoundedRect;
        textView2.text = @"";
        textView2.textAlignment = UITextAlignmentLeft;
        textView2.font = [UIFont fontWithName:@"Arial" size:19.0f];
        textView2.backgroundColor = [UIColor whiteColor];
        textView2.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        textView2.delegate=self;
        textView2.tag=2;
        
        textView2_2 =[[UITextField alloc] initWithFrame:CGRectMake(154.0, 67.0, 80.0, 24.0)];
        textView2_2.borderStyle=UITextBorderStyleRoundedRect;
        textView2_2.text = @"";
        textView2_2.textAlignment = UITextAlignmentLeft;
        textView2_2.font = [UIFont fontWithName:@"Arial" size:19.0f];
        textView2_2.backgroundColor = [UIColor whiteColor];
        textView2_2.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        textView2_2.delegate=self;
        textView2_2.tag=2;
        
        
        
        //暗証番号
        textView3 =[[UITextField alloc] initWithFrame:CGRectMake(100.0, 127.0, 80.0, 24.0)];     
        textView3.borderStyle=UITextBorderStyleRoundedRect;
        textView3.text = @"";
        textView3.textAlignment = UITextAlignmentLeft;
        textView3.font = [UIFont fontWithName:@"Arial" size:19.0f];
        textView3.backgroundColor = [UIColor whiteColor];
        textView3.secureTextEntry = YES;
        textView3.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        textView3.delegate=self;
        textView3.tag=1;
        
        [alert addSubview:textView2];
        [alert addSubview:textView2_2];
        [alert addSubview:textView3];
        
        alert.tag=100;
        [alert show];
        [alert release];
        
        [textView2 becomeFirstResponder];
        [textView2 release];
        //[textView2_2 becomeFirstResponder];
        [textView2_2 release];
        //[textView3 becomeFirstResponder];
        [textView3 release];
        return;
    }
    
    
    //ログイン済の場合
    if(delCheck==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ユーザー情報の移行"
                                                        message:@"受付番号\n暗証番号（数字４桁）\n\n\n"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"キャンセル",nil];
		
        //オブジェクトを強制的に移動
        //CGAffineTransform trans = CGAffineTransformMakeTranslation(0.0, 100.0); 
        //[alert setTransform:trans];
        
        textView =[[UITextField alloc] initWithFrame:CGRectMake(100.0, 95.0, 80.0, 25.0)];
        textView.borderStyle=UITextBorderStyleRoundedRect;
        textView.text = @"";
        textView.textAlignment = UITextAlignmentLeft;
        textView.font = [UIFont fontWithName:@"Arial" size:20.0f];
        textView.backgroundColor = [UIColor whiteColor];
        textView.secureTextEntry = YES;
        textView.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        textView.delegate=self;
        textView.tag=1;
        //フォーカスがはずれたときの処理
        //[textView addTarget:self action:@selector(hoge3:)forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [alert addSubview:textView];
        alert.tag=50;
        [alert show];
        [alert release];
        
        [textView becomeFirstResponder];
        [textView release];
        
    }
    else if(delCheck==50)//
    {
        NSString *passNo=textView.text;//テキストフィールドからパス番号を取得する
        
        if([passNo length]<=3)
        {
            delCheck=0;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"暗証番号を入力してください"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        
        NSString *requestNO=[self requestUserShift:passNo];//テキストフィールドから拾った値を設定
        if(requestNO ==nil)
        {
            delCheck=0;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"確認"
                                  message:@"受付番号を取得できませんでした。"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        NSLog(@"requestNo %@",requestNO);
        NSString *requestNO1 = [requestNO substringWithRange:NSMakeRange(0,5)];
        NSString *requestNO2 = [requestNO substringWithRange:NSMakeRange(5,5)];
        
        delCheck=0;        
        UIAlertView *alert = [[UIAlertView alloc]//移行
                              initWithTitle:@"ユーザー情報の移行"
                              message:[NSString stringWithFormat: @"以下の受付番号と暗証番号を\n新端末で入力してください。\n（有効期限　３時間）\n\n\n受付番号 %@ - %@\n\n暗証番号 %@",requestNO1,requestNO2,passNo]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];  
        [alert show];
        [alert release];
    }
}
-(bool)processUserShift:(NSString *)shiftNo:(NSString *)passNo
{
    bool processGet=false;
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi processUserShift:shiftNo:passNo];
    
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return processGet;
    for (int i=0; i<1; i++) 
    {
        NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
        for (NSDictionary *dic in result) 
        {
            int uid=[[dic objectForKey:@"uid"] integerValue];
            NSString *pass_code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pass_code"]];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:uid forKey:@"MDAC_UID"];
            [defaults setObject:pass_code forKey:@"MDAC_PASSCODE"];
            
            processGet=true;
        }
    }
    
    return processGet;
}
-(NSString *) requestUserShift:(NSString *)passNo
{
    NSString *shift_no=@"";
    
    loadingAPI* loadingapi=[[loadingAPI alloc] init];
    NSDictionary *restmp=[loadingapi requestUserShift:passNo];
    
    //NSLog(@"restmp %@",restmp);
    int cnt = [[restmp objectForKey:@"result"] count];
    if(cnt==0) return nil;
    
    NSDictionary *resDic = [restmp objectForKey:@"result"];
    shift_no=[NSString stringWithFormat:@"%@",[resDic objectForKey:@"shift_no"]]; 
    /* for (int i=0; i<cnt; i++) 
     {
     NSArray *result = [[restmp objectForKey:@"result"] objectAtIndex:i];
     for (NSDictionary *dic in result) 
     {
     shift_no=[NSString stringWithFormat:@"%@",[dic objectForKey:@"shift_no"]];
     }
     }*/
    NSLog(@"shift %@",shift_no);
    return shift_no;
    
}
//////////////////////////////////////////////////////////////




- (void) deleteUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:@"MDAC_UID"]==nil)
    {
        delCheck=0;
        UIAlertView *alert = [[UIAlertView alloc]//退会2
                              initWithTitle:@""
                              message:@"ユーザーは設定されていません。"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(delCheck==0)
    {   
        UIAlertView *alert = [[UIAlertView alloc]//退会0
                              initWithTitle:@"確認"
                              message:@"ユーザー情報の削除を行うと、投稿した写真も含め全てのデータが削除されますがよろしいですか？"
                              delegate:self
                              cancelButtonTitle:@"はい"
                              otherButtonTitles:@"いいえ", nil];
        alert.tag=1;
        [alert show];
        [alert release];
    }
    else if(delCheck==1)
    {
        UIAlertView *alert = [[UIAlertView alloc]//退会1
                              initWithTitle:@"！最終確認！"
                              message:@"この操作の取り消しは行えません。投稿した写真も含め全てのデータが削除されます。本当に削除してもよろしいですか？"
                              delegate:self
                              cancelButtonTitle:@"はい"
                              otherButtonTitles:@"いいえ", nil];
        alert.tag=2;
        [alert show];
        [alert release];
    }
    else if(delCheck==2)
    {
        delCheck=0;
        //APIの呼び出し
        loadingAPI* loadingapi=[[loadingAPI alloc] init];
        [loadingapi deleteUser];
        //ログイン情報の消去
        
        [defaults setObject:Nil forKey:@"MDAC_UID"];
        [defaults setObject:Nil forKey:@"_MDAC_PASSCODE"];
        [defaults setObject:Nil forKey:@"MDAC_CATEGORY"];
        
        [defaults setObject:Nil forKey:@"TwitterAccessToken"];
        [defaults setObject:Nil forKey:@"TwitterAccessTokenSecret"];
        [defaults setObject:Nil forKey:@"TwitterName"];
        [defaults setObject:nil forKey:@"TwitterSnsId"];
        [defaults setObject:nil forKey:@"TwitterDisplayName"];
        
        [defaults setObject:Nil forKey:@"FBAccessToken"];
        [defaults setObject:Nil forKey:@"FBName"];
        
        [defaults setObject:Nil forKey:@"MixiAccessToken"];
        [defaults setObject:nil forKey:@"MixiRefreshToken"];
        [defaults setObject:Nil forKey:@"MixiName"];
        [defaults setObject:Nil forKey:@"SNS_NAME"];
        
        [defaults setObject:Nil forKey:@"MAIN_NAME"];
        [defaults setObject:nil forKey:@"BIRTH_DAY"];
        [defaults setObject:nil forKey:@"USER_PROFILE"];
        
        [defaults setObject:nil forKey:@"TUTORIAL_FLAG"];
        [defaults setObject:nil forKey:@"PASS_RANKING"];
        [defaults setObject:nil forKey:@"FOLLOW_ID"];
        [defaults setObject:nil forKey:@"FROM_ALBUM"];
        [defaults setObject:nil forKey:@"FROM_ALBUM_FLAG"];
        
        
        UIAlertView *alert = [[UIAlertView alloc]//退会2
                              initWithTitle:@"完了"
                              message:@"ユーザー情報の削除を行いました。ご利用ありがとうございました。"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag=101;
        [alert show];
        [alert release];
    }
    
    //退会しましたメッセージ
    /*    _secondViewController = [[SecondViewController alloc] 
     initWithNibName:@"SecondView" 
     bundle:nil];
     [self.navigationController pushViewController:_secondViewController 
     animated:YES];
     
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     [self.navigationController popToRootViewControllerAnimated:YES];     */
}

-(void)loginAlert
{
    
    // 複数行で書くタイプ（複数ボタンタイプ）
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"SNSにログインが必要です";
    alert.message = @"この操作を行うには、各SNSにログインが必要です。OKを押すと設定画面が開きます";
    alert.tag=500;
    [alert addButtonWithTitle:@"キャンセル"];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if(alertView.tag ==500){
        return;
    }
    
    if(alertView.tag==101)//リロード
    {
        //NSLog(@"test");
        _secondViewController = [[SecondViewController alloc] 
                                 initWithNibName:@"SecondView" 
                                 bundle:nil];
        [self.navigationController pushViewController:_secondViewController 
                                             animated:NO];
        return;
    }
    
    
    // NSLog(@"button %d",buttonIndex);
    switch (buttonIndex)
    {
        default:
        case 1:
            NSLog(@"iie");
            delCheck=0;
            textView=nil;
            textView2=nil;
            textView3=nil;
            break;
        case 0:
            //[textView.text copy] autorelease];
            //NSLog(@"hai %@",textView.text);
            delCheck=alertView.tag;
            
            if(delCheck<10) [self deleteUser];
            else            [self shiftUser];
            break;
    }
}


- (void) loginButton
{/*
  // ボタン設置
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"" forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"details_mixi_0.png"] forState:UIControlStateNormal];
  [button sizeToFit];
  button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  [button addTarget:viewController1 action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
  button.center = CGPointMake(160, 200);
  [self.view addSubview:button];
  
  // ボタン設置
  UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
  [button2 setTitle:@"" forState:UIControlStateNormal];
  [button2 setBackgroundImage:[UIImage imageNamed:@"details_facebook_0.png"] forState:UIControlStateNormal];
  [button2 sizeToFit];
  button2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  [button2 addTarget:viewController2 action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
  button2.center = CGPointMake(160, 100);
  [self.view addSubview:button2];
  
  // ボタン設置
  UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
  [button3 setTitle:@"" forState:UIControlStateNormal];
  [button3 setBackgroundImage:[UIImage imageNamed:@"details_twitter_0.png"] forState:UIControlStateNormal];
  [button3 sizeToFit];
  button3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  [button3 addTarget:viewController3 action:@selector(modalButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
  button3.center = CGPointMake(160, 300);
  [self.view addSubview:button3];*/
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{    
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _web_view.delegate = nil;
    [_web_view stopLoading];
    
    
    
    [_authorize_uri release], _authorize_uri = nil;
    [_response_uri release], _response_uri = nil;
    [_web_view release], _web_view = nil;
    _caller = nil;
    
    [_params release], _params = nil;
    
    viewController3 = nil;
    viewController2 = nil;
    viewController1 = nil;
    
    
}





// 戻り値がURLに来るとき用のパース
// _sep は区切り記号
-(void)parseQuery: (NSString *)urlstring sep:(NSString *)_sep
{
    NSRange search_result = [urlstring rangeOfString:urlstring];
    
    if (search_result.location != NSNotFound) 
    {
        NSArray* components = [urlstring componentsSeparatedByString:_sep];
        
        if ([components count] > 1) 
        {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            for (NSString *query in [[components lastObject] componentsSeparatedByString:@"&"]) 
            {
                NSArray *keyAndValues = [query componentsSeparatedByString:@"="];
                [parameters setObject:[keyAndValues objectAtIndex:1] forKey:[keyAndValues objectAtIndex:0]];
            }
            
            
            // 戻り値（アクセストークン）取得
            if ([parameters valueForKey:@"code"]) 
            {
                // authorization_codeを取得
                if ([_caller respondsToSelector:@selector(parse_authorization_code:)]) 
                {
                    [_caller parse_authorization_code:[parameters valueForKey:@"code"]];
                }
            } 
            
            if ([parameters valueForKey:@"error"]) 
            {
                
                // errorを取得
                if ([_caller respondsToSelector:@selector(parse_access_denied:)]) 
                {
                    [_caller parse_access_denied:[parameters valueForKey:@"error"]];
                    return;
                    
                }
            } 
            else if ([parameters valueForKey:@"state"]) 
            {
                // stateを取得
                if ([_caller respondsToSelector:@selector(parse_state:)]) 
                {
                    [_caller parse_state:[parameters valueForKey:@"state"]];
                }
            } 
            else if ([parameters valueForKey:@"access_token"]) 
            {
                // FBのアクセストークンを取得
                if ([_caller respondsToSelector:@selector(parse_access_token:)]) 
                {
                    [_caller parse_access_token:[parameters valueForKey:@"access_token"]];
                }
            } 
            /* else  if ([parameters valueForKey:@"oauth_verifier"]) {
             // Twitterのverifuerを取得
             if ([_caller respondsToSelector:@selector(parse_verifier:)]) {
             [_caller parse_verifier:[parameters valueForKey:@"oauth_verifier"]];
             }
             } */
        }
    }
    
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    // アクセスインジケータ停止
    //[activityIndicator stopAnimating];
    
    int loadcheck=0;
    
    // ロード終わり
    NSString* urlstring = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"*urlstring='%@'", urlstring);
    
    if ([urlstring hasPrefix:MIXI_CALLBACK_URL "?state=mixi&code="]) 
    {
        loadcheck=1;
        //////////
        // mixi
        //////////
        // URLからパラメータを取得
        [self parseQuery: urlstring sep:@"?"];
        
        // 同期通信・トークンゲット
        [(MixiTestViewController *)_caller accessTokenGet];
        
        // ログイン
        [_caller login];
        
        
        _secondViewController = [[SecondViewController alloc] 
                                 initWithNibName:@"SecondView" 
                                 bundle:nil];
        [self.navigationController pushViewController:_secondViewController 
                                             animated:YES];
    } 
    else if ([urlstring hasPrefix:FACEBOOK_REQUEST_URL "?"]) 
    {
        loadcheck=2;
        /////////////
        // facebook
        /////////////
        [self parseQuery: urlstring sep:@"?"];
    }
    else if ([urlstring hasPrefix:FACEBOOK_TOKEN_CALLBACK_URL "#"]) 
    {
        loadcheck=3;
        /////////////
        // facebook
        /////////////
        // URLからパラメータを取得
        [self parseQuery:urlstring sep:@"#"];
        
        // 同期通信・トークンゲット
        [(FBTestViewController *)_caller accessTokenGet];
        
        // ログイン
        [(FBTestViewController *)_caller login];
        
        
        _secondViewController = [[SecondViewController alloc] 
                                 initWithNibName:@"SecondView" 
                                 bundle:nil];
        [self.navigationController pushViewController:_secondViewController 
                                             animated:YES];
    }
    //#ifndef TWITTER_CALLBACK_URL                
    ////////////////
    // twitter PIN
    ////////////////
    else if ([urlstring hasPrefix:TWITTER_AUTHORIZE_URL]) 
    {
        
        // HTMLを取得
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        //      NSLog(@"---- html begin ----\r%@---- html end ----", html);
        
        
        //文字列内で、PINコード文字列を検索
        NSRange searchResult1 = [html rangeOfString:@"<code>"];
        if (searchResult1.location == NSNotFound) 
        {
            loadcheck=41;    
            
        } 
        else
        {
            NSRange searchResult2 = [html rangeOfString:@"</code>"];
            if (searchResult2.location == NSNotFound) 
            {
                
                loadcheck=42;
                
            } 
            else
            {
                loadcheck=43;
                // コード見つかった
                NSInteger begin = searchResult1.location+searchResult1.length;
                NSInteger len = searchResult2.location - begin;
                self.pin = [html substringWithRange:NSMakeRange(begin,len)];
                
                // URLからパラメータを取得
                // [self parseQuery:urlstring sep:@"?"];
                // [(TwTestViewController *)_caller parse_verifier:self.pin];
                
                //[(TwTestViewController *)_caller accessTokenGet];//もどした
                
                // ログイン
                //[(TwTestViewController *)_caller login];//もどした
                
            }
        }
        
    }
    else if ([urlstring hasPrefix:TWITTER_CALLBACK_URL]) 
    {
        loadcheck=5;
        
        // twitter Callback
        NSArray* components = [urlstring componentsSeparatedByString:@"?"];
        if ([components count] > 1) 
        {
            
            //
            [(TwTestViewController *)_caller parse_callback_param:[[components objectAtIndex:1] description]];
            
            _secondViewController = [[SecondViewController alloc] 
                                     initWithNibName:@"SecondView" 
                                     bundle:nil];
            [self.navigationController pushViewController:_secondViewController 
                                                 animated:YES];
            //[self.view removeFromSuperview];
            
        }
        
    }
    /*
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"load check"
     message: [NSString stringWithFormat:@"%d", loadcheck]
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
    
    //#endif
    
}



- (void)viewURLPage
{
    //_web_view = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    _web_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _web_view.scalesPageToFit = YES;
    _web_view.delegate = self;//(id) _webview_delegate;
    
    [self.view addSubview:_web_view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_authorize_uri]];
    [_web_view loadRequest:request];
}





- (void) changeMainSNS
{
    
    if([self getSnsLoginStatus:1] ==1 ||[self getSnsLoginStatus:2] ==1 ||[self getSnsLoginStatus:3] ==1 )
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];
        // int nowcategory = [category intValue];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        if([self getSnsLoginStatus:1]==1)
            [actionSheet addButtonWithTitle:@"twitter"];
        if([self getSnsLoginStatus:2]==1)
            [actionSheet addButtonWithTitle:@"facebook"];
        if([self getSnsLoginStatus:3]==1)
            [actionSheet addButtonWithTitle:@"mixi"];
        [actionSheet addButtonWithTitle:@"戻る"];
        
        //全部入り
        if(   [self getSnsLoginStatus:1]==1 
           && [self getSnsLoginStatus:2]==1 
           && [self getSnsLoginStatus:3]==1)
        {
            //メインを赤にする処理
            if ([MainSNS isEqualToString:@"twitter"])
                actionSheet.destructiveButtonIndex = 0; 
            else if ([MainSNS isEqualToString:@"facebook"])
                actionSheet.destructiveButtonIndex = 1; 
            else if ([MainSNS isEqualToString:@"mixi"])
                actionSheet.destructiveButtonIndex = 2; 
            
        }
        //２こずつ
        else if([self getSnsLoginStatus:1]==1 
                &&[self getSnsLoginStatus:2]==1 
                &&[self getSnsLoginStatus:3]==0)
        {
            if ([MainSNS isEqualToString:@"twitter"])
                actionSheet.destructiveButtonIndex = 0; 
            else if ([MainSNS isEqualToString:@"facebook"])
                actionSheet.destructiveButtonIndex = 1;
        }
        else if([self getSnsLoginStatus:1]==0 
                &&[self getSnsLoginStatus:2]==1 
                &&[self getSnsLoginStatus:3]==1)
        {
            if ([MainSNS isEqualToString:@"facebook"])
                actionSheet.destructiveButtonIndex = 0; 
            else if ([MainSNS isEqualToString:@"mixi"])
                actionSheet.destructiveButtonIndex = 1;
        }
        else if([self getSnsLoginStatus:1]==1
                && [self getSnsLoginStatus:2]==0 
                && [self getSnsLoginStatus:3]==1)
        {            
            if ([MainSNS isEqualToString:@"twitter"])
                actionSheet.destructiveButtonIndex = 0; 
            else if ([MainSNS isEqualToString:@"mixi"])
                actionSheet.destructiveButtonIndex = 1;
        }
        //１こ
        /*    else if([self getSnsLoginStatus:1]==0
         &&[self getSnsLoginStatus:2]==1
         &&[self getSnsLoginStatus:3]==0)
         {
         actionSheet.destructiveButtonIndex = 0; 
         }
         
         else if([self getSnsLoginStatus:1]==0 
         && [self getSnsLoginStatus:2]==0 
         && [self getSnsLoginStatus:3]==1)
         {            
         actionSheet.destructiveButtonIndex = 0; 
         }*/
        else
        {
            actionSheet.destructiveButtonIndex = 0; 
        }
        
        //赤ボタン化
        
        //        NSString* MainSNS=[defaults stringForKey:@"SNS_NAME"];
        
        //      as.destructiveButtonIndex=1
        
        
        //actionSheet.destructiveButtonIndex =3;
        
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [actionSheet showInView:self.view];
        [actionSheet release];    
    }
    
}



- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //番号別変更
    //NSLog(@"%d",buttonIndex);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([self getSnsLoginStatus:1]==1 && [self getSnsLoginStatus:2]==1)
    {   //twitter facebook
        switch (buttonIndex) {
            case 0:
                snsName=@"twitter"; 
                break;
            case 1:
                
                snsName=@"facebook"; 
                break;    
            case 2:
                snsName=@"mixi"; 
                break;
            default:break;
        }
    }
    else if([self getSnsLoginStatus:1]==0 && [self getSnsLoginStatus:2]==1 &&[self getSnsLoginStatus:3]==1)
    {//facebook mixi
        switch (buttonIndex) {
            case 0:
                snsName=@"facebook"; 
                break;
            case 1:
                
                snsName=@"mixi"; 
                break;    
            case 2:
                //   snsName=@"mixi"; 
                //  break;
            default:return;
                break;
        }
    }
    
    else if([self getSnsLoginStatus:2]==0 && [self getSnsLoginStatus:1]==1 && [self getSnsLoginStatus:3]==1)
    {//twitter mixi
        switch (buttonIndex) {
            case 0:
                snsName=@"twitter"; 
                break;
            case 1:
                
                snsName=@"mixi"; 
                break;    
            case 2:
                //   snsName=@"mixi"; 
                //   break;
            default:return;
                break;
        }
    }
    else if([self getSnsLoginStatus:1]==0 && [self getSnsLoginStatus:2]==0 && [self getSnsLoginStatus:3]==1)
    {  //mixi
        switch (buttonIndex) {
            case 0:
                snsName=@"mixi"; 
                break;
            default:return;
                break;
        }
    }
    else if([self getSnsLoginStatus:2]==1)
    {  //mixi
        switch (buttonIndex) {
            case 0:
                snsName=@"facebook"; 
                break;
            default:return;
                break;
        }
    }
    else if([self getSnsLoginStatus:1]==1)
    {  //mixi
        switch (buttonIndex) {
            case 0:
                snsName=@"twitter"; 
                break;
            default:return;
                break;
        }
    }
    
    
    
    [defaults setObject:snsName forKey:@"SNS_NAME"];
    
    
    
    
    [self nextDataLoad];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _secondViewController = [[SecondViewController alloc] 
                             initWithNibName:@"SecondView" 
                             bundle:nil];
	[self.navigationController pushViewController:_secondViewController 
										 animated:YES];
}








- (void)ShowHelp{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Version情報"
                          message:@"Meet! Dog'n Cats Iphone ver1.00"
                          delegate:nil
                          cancelButtonTitle:@"キャンセルボタン"
                          otherButtonTitles:@"他", nil];
    [alert show];
    [alert release];
}

- (void)ShowVersion{
    
    
}

- (void)ShowPolicy{
    
}

- (void)ShowSupport{
    //メール送信不可能な場合はリターン
    if ([MFMailComposeViewController canSendMail] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"メール送信エラー"
                              message:@"エラーが発生したためメールが送信できませんでした。お問い合わせは　infomdc@ilogos.jp　にメールを送信してください"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        return;
    }
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    // メール本文を設定
    [mailPicker setMessageBody:@"" isHTML:NO];
    // 題名を設定
    [mailPicker setSubject:@""];
    // 宛先を設定
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"infomdc@ilogos.jp", nil]];
    // メール送信用のモーダルビューを表示
    [self presentModalViewController:mailPicker animated:TRUE];
    [mailPicker release];
}

// メール送信処理完了時のイベント
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
        case MFMailComposeResultCancelled:  // キャンセル
            break;
        case MFMailComposeResultSaved:      // 保存
            break;
        case MFMailComposeResultSent:       // 送信成功
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"送信に成功しました"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            break;
        }
        case MFMailComposeResultFailed:     // 送信に失敗した場合
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"送信に失敗しました"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            break;
        }
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)UserImigrate{
    
    
}

- (void)Leave{
    
}



//ロード完了読み込み
- (void)viewDidAppear:(BOOL)animated
{
    
}


/*
 // エラーが起きた場合
 - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
 {
 
 // Webのロードを止める
 [self.web_view stopLoading];
 
 
 #if 0    
 if (error.code == 101 && [error.domain hasPrefix:@"WebKitErrorDomain"]) {
 // エラーの先を無理矢理替える
 NSDictionary *dic = error.userInfo;
 NSMutableString *str = [dic objectForKey:@"NSErrorFailingURLKey"];
 NSMutableString *str2 = [NSMutableString stringWithFormat:@"%@", str];
 
 // ある一定の文字列の長さ以上で、プレフィクスがmeetのものだったら
 NSString *scheme = MIXI_CALLBACK_URL_MEET;
 if (str2.length >= scheme.length && [str2 hasPrefix:MIXI_CALLBACK_URL_MEET]) {
 // 先頭を削る
 [str2 deleteCharactersInRange:NSMakeRange(0, scheme.length)];      // 先頭のスキームを削る
 [str2 insertString:MIXI_CALLBACK_URL atIndex:0];
 NSLog(@"*str2='%@'", str2);
 // 飛び先をリダイレクト
 [self webRedirect: str2];
 }
 return;
 }
 }
 // 他のエラー処理を入れる
 //
 }
 #endif
 */

-(IBAction) back_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end




