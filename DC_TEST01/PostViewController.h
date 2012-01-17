//
//  PostViewController.h
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/30.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopViewController.h"
#import "PostEditViewController.h"

@class TopViewController;


@interface PostViewController : TopViewController 
<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView*   _imageView;
    IBOutlet UIImageView*   _imageViewOl;
    IBOutlet UIImageView*   _imageViewOl2;
    
    //UIImagePickerController*    imagePicker;
    // int saveEffectType;
    // int saveAngle;
}
- (UIImage*)imageByCropping:(UIImage *)imageToCrop;// toRect:(CGRect)rect;
- (CGSize)imageByShrinkingWithSize:(UIImage *)originImg;
- (IBAction)showCameraSheet;
- (IBAction)showPhotoSheet;
//- (void)ShowImageChange;


-(void)changeImageEffect:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height;//セピア
-(void)changeLight:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height;
-(void)changeSheap:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height;
-(void)changeEmbos:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height
;


-(void)imageChange:(int)changeType:(UIImage *)originalImage;

- (void)imageShowing:(UIImage *)img;
-(IBAction) changeImage90_btn_down:(id)sender;
-(UIImage *)changeImage90Angle:(UIImage *)img;
-(IBAction) img_btn_down:(id)sender;

-(IBAction) changeImageSelect_btn_down:(id)sender;
-(IBAction) resetImageSelect_btn_down:(id)sender;
@property (nonatomic,retain) IBOutlet UIImageView *_imageView;
@property (nonatomic,retain) IBOutlet UIImageView *_imageViewOl;


@end
