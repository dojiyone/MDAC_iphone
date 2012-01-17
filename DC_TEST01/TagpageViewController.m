//
//  TagpageViewController.m
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/11.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "TagpageViewController.h"
#import "SearchViewCtrl.h"

@implementation TagpageViewController

@synthesize title_lbl;
@synthesize re_value;
@synthesize nowTagNum;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    //詳細はどこをを経由したか？YES
    //0 = top 1 = ranking 2=mypage 3 = search 4=tagedit
    
    int pass_ranking = 4;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:pass_ranking forKey:@"PASS_RANKING"];
    NSLog(@"deteails back%d",pass_ranking);
    
    NSLog(@"re_value %@",re_value);
    [self nextDataLoadTagpage];
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)nextDataLoadTagpage
{
    NSString *tag=re_value;
    NSLog(@"tag %@",tag);
    NSLog(@"nowTagNum %d",nowTagNum);

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int category=[[defaults stringForKey:@"MDAC_CATEGORY"] intValue];
    
	SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] initWithNibName:nil bundle:nil];
    searchViewCtrl.tagpage_flag=1;
    searchViewCtrl.nowTagNum = nowTagNum;
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [scrollViewTag addSubview:uv];
    
    int offset=0;
    int limit=100;
    

    
    [scrollViewTag addSubview:searchViewCtrl.view];
    
    
    //
    
    NSString *kiriTag = [[tag componentsSeparatedByString:@"／"]objectAtIndex:0];
    NSLog(@"tagpage %@",kiriTag);
    
    [searchViewCtrl getTagLists:kiriTag :offset:limit];//オフセット、読み込み数

    //[scrollViewTag setContentSize:searchViewCtrl.view.bounds.size];  

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

@end
