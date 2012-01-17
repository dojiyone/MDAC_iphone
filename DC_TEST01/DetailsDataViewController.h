//
//  DetailsDataViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/07.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class TopViewController;

@interface DetailsDataViewController : TopViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UINavigationController *nabi;
    NSString *image_id;
    NSString *re_value;
    NSString *uid;
    int fanpage_uid;
    int from_album;
    int albumSheetCount;
    
    NSString *Conmment;
    NSString *Date;
    NSString *post_image_name;
    NSString *name;
    NSString *access_count;
    NSString *ref_album_count;
    NSString *ref_access_count;
    NSString *category;
    NSString *str;
    NSString *accessCount;
    NSString *category_text;
    
    IBOutlet UILabel *taglabel;
    IBOutlet UITableView *tableView;
    IBOutlet NSMutableArray *dataSource_;
    
    UIScrollView *detail_data_scrollView;
    
    UILabel *deletaLabel;
    int titletable_height;
    UIImage *icon_image;
}
@property (nonatomic,retain)NSString *re_value;
@property (nonatomic,retain)NSString *image_id;
@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)UINavigationController *nabi;
@property (nonatomic,retain)IBOutlet UIScrollView *detail_data_scrollView;

@property (nonatomic,retain)UILabel *deletaLabel;

- (int) strLength :(NSString *) aValue:(int)strlen;

//- (void)tagButtonPressed:(NSString *)tag;

//-(UIButton *)tagStringPressed:(id)sender;
-(IBAction) add_album_btn_down:(id)sender;

- (void)details_info_load;
-(void)tag_load;
@end
