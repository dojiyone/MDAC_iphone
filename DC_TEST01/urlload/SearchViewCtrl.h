//
//  SearchViewCtrl.h
//  PFrame
//
//  Created by ntaku on 09/10/11.
//  Copyright 2009 http://d.hatena.ne.jp/ntaku/. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmlBaseCtrl.h"
#import "GADBannerViewDelegate.h"
#import <Foundation/Foundation.h>
#import "DC_TEST01AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@class TopViewController;
@class MypageViewController;
@class GADBannerView, GADRequest;

@interface SearchViewCtrl : XmlBaseCtrl <UIScrollViewDelegate,GADBannerViewDelegate>
{
@public
	UIScrollView *thumbnailView;
    TopViewController *_topViewController;
    MypageViewController *_mypageViewController;
    NSString* Category;
    int alertflag;
    
    int offset;
    int limit;
    int loadtype;
    int loadflag;
    NSString *logString;
    int logint1;
    int logint2;
    UIView *uv;
    int basey;
    NSInteger tagpage_flag;
    NSInteger nowTagNum;
    
    GADBannerView *adBanner_;
}
//@property(nonatomic, retain) NSString *accessibilityHint;
@property (nonatomic,retain)UIScrollView *thumbnailView;
- (UIImage *) changeImageStyle:(UIImage *)baseImage
                              :(int)dw :(int)dh
                              :(int)cx :(int)cy
                              :(NSString *)fmt
                              :(int)fs
                              :(float)gm
                              :(int)st :(int)sp
                              :(int)dr
                              :(int)zr :(int)zp;
@property NSInteger tagpage_flag;
@property NSInteger nowTagNum;
@property(nonatomic, retain) GADBannerView *adBanner;


-(void)showEnd;
-(void)buttonTouched:(UIButton*)button;

-(void)showImgList:(NSDictionary *)restmp:(int)pickupFlag;//:(NSString *)pickupString:(int)pickupID;
-(void)showImgPicComment:(NSDictionary *)restmp;
-(void)showRankImgList:(NSDictionary *)restmp;

- (void)getPickupPicture;//ピックアップ画像
- (void)getPostimageByNewList : (int) newoffset:(int) newlimit;
- (void)getTagLists:(NSString *)tag:(int)offset:(int)limit;
- (void)getAlbumimageList:(int)uid: (int)offset:(int)limit:(int)albumid;
- (void)getAlbumList:(int)uid;
- (void)getUsersList:(int)uid;
- (GADRequest *)createRequest;




-(void)getPostimageByEvaluationList :(int)scrollNum :(NSArray *)taglist :(int)offset :(int)limit;
-(void)getPostimageByEvaluationList2 :(NSString *)encodeString :(int)offset :(int)limit;

-(void)getSearchPostimage :(NSString *)keyword :(NSString *)sort :(int)offset :(int)limit;
-(void)bannerLoad:(TopViewController *)top;
- (void)delAd;
- (void)showAd;
@end
