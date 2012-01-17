//
//  CuratorViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface CuratorViewController : TopViewController <UITableViewDataSource,UITableViewDelegate>
{
@public
    IBOutlet UITableView *myTableView;
    
    NSArray* keys_;
    NSDictionary* dataSource_;
    
    UIView *curView;
    UIScrollView *curSv;
    int fid;
}



- (void)ShowActivity:(UIButton *)sender;
@end
