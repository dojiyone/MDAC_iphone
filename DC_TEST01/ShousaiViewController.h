//
//  ShousaiViewController.h
//  DC_TEST01
//
//  Created by 泰三 佐藤 on 11/11/21.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShousaiViewController : UIViewController{
    
    //上ラベル
    IBOutlet UIButton *back_btn;
    //上タブ
    IBOutlet UIButton *shashin_btn;
    IBOutlet UIButton *shousai_btn;
    IBOutlet UIButton *comment_btn;
    IBOutlet UIButton *sns_btn;
    //下タブ
    IBOutlet UIButton *tsuho_btn;
    IBOutlet UIButton *kensaku_btn;
    IBOutlet UIButton *satsuei_btn;
    IBOutlet UIButton *mypage_btn;
    IBOutlet UIButton *settei_btn;
    
}

//上ラベル
-(IBAction) back_btn_down:(id)sender;
//上タブ
-(IBAction) shashin_btn_down:(id)sender;
-(IBAction) shousai_btn_down:(id)sender;
-(IBAction) comment_btn_down:(id)sender;
-(IBAction) sns_btn_down:(id)sender;
//下タブ
-(IBAction) tsuho_btn_down:(id)sender;
-(IBAction) kensaku_btn_down:(id)sender;
-(IBAction) satsuei_btn_down:(id)sender;
-(IBAction) mypage_btn_down:(id)sender;
-(IBAction) settei_btn_down:(id)sender;



@end
