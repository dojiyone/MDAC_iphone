//
//  AlubumIconViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface AlubumIconViewController : TopViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITextField* textView;
    int loadTextView;
    
    UITableView *tableView;
    
    NSArray* keys_;
    NSDictionary* dataSource_;
    
    UIImage *iconImg[30];
    NSInteger *img_id[30];
    NSInteger *count;
    NSInteger *select_id;
}
-(IBAction)add_album_btn:(UIButton *)sender;
-(void)reload_view;
-(void)showAlbumList;
@end
