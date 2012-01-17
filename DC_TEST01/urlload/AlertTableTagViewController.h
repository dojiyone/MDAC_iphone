//
//  AlertTableTagViewController.h
//  DC_TEST01
//
//  Created by ケンスケ スズキ on 11/12/26.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TageditViewController.h"

@interface AlertTableTagViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
@public
    TageditViewController *ted;
    
    PostEditViewController *ped;
    
    NSString *tagString[8];
    IBOutlet UITableView *tagTable;
    
    NSMutableArray* dataSource_;    //table
    NSString *select_text;
}
@property (nonatomic,retain)    NSString *select_text;
@end
