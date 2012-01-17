//
//  PopularTagViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/29.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface PopularTagViewController : TopViewController
{
    IBOutlet UILabel *followtest;
    IBOutlet UILabel *bglabel;
}

-(int) checkCenterStrCount:(NSString *)tagString:(int)nowCenterCount:(int)strlenPxMae:(int)strScale;
- (int) strLength :(NSString *) aValue :(int)strlen;
-(void) nextDataLoadPopular;
//-(UIButton *)tagButtonPressed:(id)sender;//:(int)test;
@end
