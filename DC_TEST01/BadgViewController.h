//
//  BadgViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;



@interface BadgViewController : TopViewController
{
    NSString *re_value;
    int re_num;
}

@property (nonatomic,retain)NSString *re_value;
@property int re_num;

- (void)ShowActivity:(UIButton *)sender;
@end
