//
//  TagpageViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/11.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface TagpageViewController : TopViewController
{
    NSString *re_value;
    IBOutlet UILabel *title_lbl;
    IBOutlet UIScrollView *scrollViewTag;
    NSInteger nowTagNum;
}

@property (nonatomic,retain)IBOutlet UILabel *title_lbl;
@property (nonatomic,retain)NSString *re_value;
@property NSInteger nowTagNum;

-(void)nextDataLoadTagpage;

@end
