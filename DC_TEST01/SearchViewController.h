//
//  SearchViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/12/04.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface SearchViewController : TopViewController
{
}

- (void)getSearchData:(NSString *)searchText;
- (void)showImgListSearch:(NSDictionary *)restmp;

- (void)nextDataLoadSearch;
@end
