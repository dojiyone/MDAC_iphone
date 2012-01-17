//
//  FollowlistViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface FollowlistViewController : TopViewController
{
    int Uid;
    NSString *re_value;
    int re_num;
}

@property (nonatomic,retain)NSString *re_value;
@property int re_num;

@end
