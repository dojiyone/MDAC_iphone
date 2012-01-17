//
//  PostViewController.m
//  DC_TEST01
//
//  Created by Digitalfrontier lab on 11/11/30.
//  Copyright (c) 2011年 CyberMuse, Inc. All rights reserved.
//

#import "PostViewController.h"
#import "DetailsPictureViewController.h"

@implementation PostViewController

@synthesize _imageView;
@synthesize _imageViewOl;

-(void) viewDidLoad
{
    
    
}
-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"postview memoryover");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------//
#pragma mark -- アクション --
//--------------------------------------------------------------//
- (IBAction)showPhotoSheet{
    // ソースタイプを決定する
    UIImagePickerControllerSourceType   sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    // 使用可能かどうかチェックする
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) 
    {    
        
        return;
    }
    
    // イメージピッカーを作る
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker autorelease];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsImageEditing = YES;
    imagePicker.delegate = self;
    
    // イメージピッカーを表示する
    [self presentModalViewController:imagePicker animated:YES];
    
}


- (IBAction)showCameraSheet
{
    
    
    // ソースタイプを決定する
    UIImagePickerControllerSourceType   sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // 使用可能かどうかチェックする
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"システムエラー"
                              message:@"カメラを起動できません"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];          return;
    }
    
    // イメージピッカーを作る
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker autorelease];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsImageEditing = YES;
    imagePicker.delegate = self;
    
    // イメージピッカーを表示する
    [self presentModalViewController:imagePicker animated:YES];
}


//--------------------------------------------------------------//
#pragma mark -- UIImagePickerControllerDelegate --
//--------------------------------------------------------------//

- (void)imagePickerController:(UIImagePickerController*)picker 
        didFinishPickingImage:(UIImage*)image 
                  editingInfo:(NSDictionary*)editingInfo
{
    // NSLog(@"画像を選択状態");
    
    
    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
    
    // オリジナル画像を取得する
    UIImage*    originalImage;
    originalImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    //クロップ
    //originalImage =[self imageByCropping:originalImage];// toRect:cropRect];
    
    
    NSLog(@"orlimg %@",originalImage);
    _imageViewOl.image=originalImage;
    _imageViewOl.tag=0;
    
    [self imageChange:10:originalImage];//10
    //  [originalImage release];
}


- (void)imageShowing:(UIImage *)img
{
    // 画像を表示する
    _imageViewOl2.image=img;
    
    NSLog(@"shottype %@",img);
    
    //クロップ
    UIImage *tempImage =[self imageByCropping:img];// toRect:cropRect];
    
    //表示用に縮小クロッピング
    /*   loadingAPI* loadingapi=[[loadingAPI alloc] init];
     UIImage *cropEnd=[loadingapi changeImageStyle:img :250:250 :2:2 :@"" :0 :0 :0:0 :0 :0:0];
     [loadingapi release];
     */   
    _imageView.image =tempImage;// cropEnd;
    //[tempImage release];
}




-(void)imageChange:(int)changeType:(UIImage*)tempImage
{
    //UIImage* originalImage=_imageViewOl.image;
    NSLog(@"img %@",tempImage);
    
    CGSize size;
    int fullsize =tempImage.size.width+tempImage.size.height;
    if(fullsize>4000)//２M超えるくらいのサイズ
    {
        //アスペクト比を維持したサイズに調整
        size =[self imageByShrinkingWithSize:tempImage];
    }
    else
    {
        size= CGSizeMake(tempImage.size.width, tempImage.size.height);    
    }
    
    // グラフィックスコンテキストを作る
    UIGraphicsBeginImageContext(size);
    
    
    // 画像を縮小して描画する
    CGRect  rect;
    rect.origin = CGPointZero;
    rect.size = size;
    [tempImage drawInRect:rect];
    
    
    
    
    // 描画した画像を取得する
    UIImage*    shrinkedImage;
    shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();//画面外に画像を定義
    UIGraphicsEndImageContext();
    
    NSLog(@"shrinkedImage %@",shrinkedImage);
    // CGImageを取得する
    CGImageRef  cgImage;
    cgImage = shrinkedImage.CGImage;
    
    // 画像情報を取得する
    size_t                  width;
    size_t                  height;
    size_t                  bitsPerComponent;
    size_t                  bitsPerPixel;
    size_t                  bytesPerRow;
    CGColorSpaceRef         colorSpace;
    CGBitmapInfo            bitmapInfo;
    bool                    shouldInterpolate;
    CGColorRenderingIntent  intent;
    width = CGImageGetWidth(cgImage);
    height = CGImageGetHeight(cgImage);
    bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    bytesPerRow = CGImageGetBytesPerRow(cgImage);
    colorSpace = CGImageGetColorSpace(cgImage);
    bitmapInfo = CGImageGetBitmapInfo(cgImage);
    shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
    intent = CGImageGetRenderingIntent(cgImage);
    // データプロバイダを取得する
    
    
    
    
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(cgImage);
    
    // ビットマップデータを取得する
    CFDataRef   data=nil;
    UInt8*      buffer=nil;
    data = CGDataProviderCopyData(dataProvider);
    //NSLog(@"data %@",data);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    //画像エフェクト切り替え
    [self changeImageEffect:changeType:buffer:bytesPerRow:width:height];
    
    
    
    // 効果を与えたデータを作成する
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを作成する
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    //NSLog(@"dataprovider");
    // 画像を作成する
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height, 
                                    bitsPerComponent, bitsPerPixel, bytesPerRow, 
                                    colorSpace, bitmapInfo, effectedDataProvider, 
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    [effectedImage autorelease];
    
    //回転角度の保持
    for(int i=0;i<_imageViewOl.tag;i++)
    {
        UIImage *ret =[self changeImage90Angle:effectedImage];
        effectedImage=ret;
    }
    
    //saveEffectType=changeType;
    //saveAngle=_imageViewOl.tag;
    [self imageShowing:effectedImage];
    
    
    // 作成したデータを解放する
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    //[tempImage release];
    //[shrinkedImage release];
    return;
}

//輝度式デフォルト値
//y = (77 * r + 28 * g + 151 * b) / 256;


//カラーエフェクト
-(void)changeImageEffect:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height
{
    if(effectType>=9) return;
    else if(effectType>=8)  [self changeEmbos:effectType:buffer:bytesPerRow:width:height];
    else if(effectType>=6)  [self changeSheap:effectType:buffer:bytesPerRow:width:height];
    else if(effectType>=3)  [self changeLight:effectType:buffer:bytesPerRow:width:height];
    int br=256;
    int bg=256;
    int bb=256;
    double nextR=1;
    double nextG=1;
    double nextB=1;
    //NSLog(@"effecttype %d",effectType);
    switch (effectType) 
    {
        case 0://セピア y = 0.299 * r + 0.587 * g + 0.114 * b;
            br=77;
            bg=28;
            bb=151;
            nextR=0.3;//0.4
            nextG=0.7;         
            nextB=0.9;
            break;
        case 1:////ブルー
            br=77;
            bg=28;
            bb=151;
            nextR=1;
            nextG=0.7;     
            nextB=0.4;
            //nextR=0.4;//0.4
            //nextG=0.3;         
            //nextB=0.9;
            break;
        case 2:////モノクロ
            br=77;
            bg=28;
            bb=151;
            break;
            // case 8:
        default:
            /*br=77;
             bg=28;
             bb=151;
             nextR=0.1;
             nextG=0.8;     
             nextB=0.1;*/
            return;//上記以外は処理しない
            break;
    }
    
    
    // ビットマップに効果を与える
    NSUInteger  i, j;
    for (j = 0; j < height; j++) 
    {
        for (i = 0; i < width; i++) 
        {
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            UInt8   r, g, b;
            r = *(tmp + 0);//3
            g = *(tmp + 1);//2
            b = *(tmp + 2);//1
            // if(i==100)   NSLog(@"old r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
            
            // 輝度値を計算する
            UInt8   y;
            y = (br*r + bg*g + bb*b) / 256;
            
            // 輝度の値をRGB値として設定する
            *(tmp + 0) = y*nextR;//1
            *(tmp + 1) = y*nextG;//2
            *(tmp + 2) = y*nextB;//3
            //if(i==100)   NSLog(@"new r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
        }
    }
    
    return;
}


-(void)changeLight:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height
{    
    
    double nextL=0;
    switch (effectType) 
    {
        case 3://少し暗く
            nextL=-20;
            break;
        case 4://少し明るく
            nextL=20;
            break;
        case 5://かなり明るく
            nextL=40;
            break;
            
        default:
            break;
    }
    
    
    // ビットマップに効果を与える
    NSUInteger  i, j;
    for (j = 0; j < height; j++) 
    {
        for (i = 0; i < width; i++) 
        {
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            //UInt8   r, g, b;
            int   r, g, b;
            r = *(tmp + 0);//3
            g = *(tmp + 1);//2
            b = *(tmp + 2);//1
            //  if(i==100)   NSLog(@"old r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
            
            r =r+nextL;
            if(r>253)r=253;
            if(r<2)r=2;
            g =g+nextL;
            if(g>253)g=253;
            if(g<2)g=2;
            b =b+nextL;
            if(b>253)b=253;
            if(b<2)b=2;
            
            
            // 輝度の値をRGB値として設定する
            *(tmp + 0) = r;//
            *(tmp + 1) = g;//
            *(tmp + 2) = b;//
            // if(i==100)   NSLog(@"new r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
        }
    }
    
    return;
}

-(void)changeSheap:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height
{   
    
    double nextL=0;
    switch (effectType) 
    {
        case 6://ソフト
            nextL=-0.3;
            break;
        case 7://シャープ
            nextL=0.4;
            break;
        default:
            return;
            break;
    }
    
    
    // ビットマップに効果を与える
    NSUInteger  i, j;
    for (j = 0; j < height; j++) 
    {
        for (i = 0; i < width; i++) 
        {
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            //UInt8   r, g, b;
            int   r, g, b;
            r = *(tmp + 0);//3
            g = *(tmp + 1);//2
            b = *(tmp + 2);//1
            // if(i==100)   NSLog(@"old r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
            
            if(r<128-10)        r =r-(nextL*(128-r));
            else if(r>128+10)   r =r+(nextL*(128-r));
            if(g<128-10)        g =g-(nextL*(128-g));
            else if(g>128+10)   g =g+(nextL*(128-g));
            if(b<128-10)        b =b-(nextL*(128-b));
            else if(b>128+10)   b =b+(nextL*(128-b));
            
            
            
            if(r>253)r=253;
            if(r<2)r=2;
            if(g>253)g=253;
            if(g<2)g=2;
            if(b>253)b=253;
            if(b<2)b=2;
            
            
            // 輝度の値をRGB値として設定する
            *(tmp + 0) = r;//
            *(tmp + 1) = g;//
            *(tmp + 2) = b;//
            // if(i==100)   NSLog(@"new r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
        }
    }
    
    
}



-(void)changeEmbos:(int)effectType:(UInt8 *)buffer:(size_t)bytesPerRow:(size_t)width:(size_t)height
{   
    double nextL=1.2;//0.7
    
    double br=77;
    double bg=28;
    double bb=151;
    
    double nextR=0.5;//0.7
    double nextG=0.5;     
    double nextB=0.5;
    
    // ビットマップに効果を与える
    NSUInteger  i, j;
    for (j = 0; j < height; j++) 
    {
        for (i = 0; i < width; i++) 
        {
            
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            UInt8   r, g, b;
            r = *(tmp + 0);//3
            g = *(tmp + 1);//2
            b = *(tmp + 2);//1
            // if(i==100)   NSLog(@"old r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
            
            // 輝度値を計算する
            UInt8   y;
            y = (br*r + bg*g + bb*b) / 256;
            
            // 輝度の値をRGB値として設定する
            r = y*nextR;
            g = y*nextG;
            b = y*nextB;
            
            
            if(r<128-10)        r =r-(nextL*(128-r));
            else if(r>128+10)   r =r+(nextL*(128-r));
            if(g<128-10)        g =g-(nextL*(128-g));
            else if(g>128+10)   g =g+(nextL*(128-g));
            if(b<128-10)        b =b-(nextL*(128-b));
            else if(b>128+10)   b =b+(nextL*(128-b));
            
            *(tmp + 0) = r;
            *(tmp + 1) = g;
            *(tmp + 2) = b;
            
            
            //if(i==100)   NSLog(@"new r%d g%d b%d",*(tmp + 2),*(tmp + 1),*(tmp + 0));
        }
    }
    
}

//画像サイズの変換と取得
- (CGSize)imageByShrinkingWithSize:(UIImage *)originImg
{
    
    
    //NSLog(@"imagesize %d",originImg.size);
    int limitWidth=2048;//262//300
    int limitHeight=1536;//262//400
    
    CGFloat widthRatio  = limitWidth  / originImg.size.width;
    CGFloat heightRatio = limitHeight / originImg.size.height;
    
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    /*if (ratio >= 1.0) 
     {
     newSize = CGSizeMake(originImg.size.width, originImg.size.height);
     }
     else
     {*/
    float newWidth =limitWidth;//originImg.size.width*widthRatio;
    float newHeight=limitHeight;//originImg.size.height*heightRatio;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    //}
    // NSLog(@"%f %f",newSize.width,newSize.height);
    return newSize;
}


//画像のクロッピング
- (UIImage*)imageByCropping:(UIImage *)imageToCrop// toRect:(CGRect)rect
{
    
    int startX=0;
    int startY=0;
    int newWidth= imageToCrop.size.width;
    int newHeight=imageToCrop.size.height;
    // NSLog(@"oldx %d",newWidth);
    // NSLog(@"oldy %d",newHeight);
    
    //クロップ
    if(newWidth>newHeight)
    {
        int clopSize=newWidth-newHeight;
        startX=clopSize/2;
        newWidth-=clopSize;//これはこれで
        // NSLog(@"width sx%d nw%d nh%d cs%d",startX,newWidth,newHeight,clopSize);
    }
    else if(newHeight>newWidth) 
    {
        
        int clopSize=newHeight-newWidth;
        startY=clopSize/2;
        newHeight-=clopSize;
        
        
        // int clopSize=newHeight-newWidth;
        //  startY=clopSize/2;
        //newHeight-=startY/2;//clopSize
        //NSLog(@"height sy%d nw%d nh%d cs%d",startY,newWidth,newHeight,clopSize);
    }
    // NSLog(@"newx %d",newWidth);
    // NSLog(@"newy %d",newHeight);
    
    CGRect rect= CGRectMake(startX, startY, newWidth,newHeight);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(
                                                       [imageToCrop CGImage], rect);
    UIImage *cropped =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // NSLog(@"Picker");
    
    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
}



-(IBAction) reload_btn_down:(id)sender;
{
    
    if(_imageView.image==nil){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"写真を選択して下さい"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    // [imagePicker release];
    //NSLog(@"コメント投稿ページへ");
    
    
    
    //本体の画像に同じ加工処理を施す
    //_imageViewOl.tag=saveAngle;
    //[self imageChange:saveEffectType:_imageViewOl.image];
    
    NSLog(@"_imageViewOl2 %@",_imageViewOl2.image);
    
    
    //画像をいったん別に生成///////////////////////////////////////
    CGSize sz1 = CGSizeMake(_imageView.image.size.width,
                            _imageView.image.size.height);
    UIGraphicsBeginImageContext(sz1);
    
    [_imageView.image drawInRect:CGRectMake(0, 0, sz1.width, sz1.height)];
    UIImage *img_ato1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    
    CGSize sz2 = CGSizeMake(_imageViewOl2.image.size.width,
                            _imageViewOl2.image.size.height);
    UIGraphicsBeginImageContext(sz2);
    
    [_imageViewOl2.image drawInRect:CGRectMake(0, 0, sz2.width, sz2.height)];
    UIImage *img_ato2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    /////////////////////////////////////////////////////////////
    
    /*
    _imageView.image=nil;
    _imageViewOl.image=nil;
    _imageViewOl2.image=nil;
    
    */
    
    
    _postEditViewController = [[PostEditViewController alloc]initWithNibName:@"PostEditViewController" 
                                                                      bundle:nil];
	[self.navigationController pushViewController:_postEditViewController 
										 animated:YES];
    //[self release];
    
    
    //生成したものを渡す（クラス内のポインタは渡さない）
    _postEditViewController._img.image =img_ato1;// _imageView.image;//
    _postEditViewController._imgOl.image=img_ato2;//_imageViewOl2.image;//
    
    
    //[img_ato1 release];
    //[img_ato2 release];
    
    
    /*
     [_imageView release];
     [_imageViewOl release];
     [_imageViewOl2 release];
     
     [imagePicker release];
     */
    
    // [self ShowImageChange];
    /*
     _curatorViewController = [[CuratorViewController alloc]initWithNibName:@"CuratorViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_curatorViewController 
     animated:YES];
     */
    /*
     _tageditViewController = [[TageditViewController alloc]initWithNibName:@"TageditViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_tageditViewController 
     animated:YES];
     */
    /*
     _rankingViewController = [[RankingViewController alloc]initWithNibName:@"RankingViewController" 
     bundle:nil];
     [self.navigationController pushViewController:_rankingViewController 
     animated:YES];
     */
    
    //[super dealloc];
}
/*
 -(IBAction) back_btn_down:(id)sender;
 {
 
 NSLog(@"topへ戻る");
 
 }*/

/*
 - (void)ShowImageChange
 {
 
 //半透明の黒背景背景
 loadingView = [[UIView alloc] initWithFrame:[[self view] bounds]];
 [loadingView setBackgroundColor:[UIColor blackColor]];
 [loadingView setAlpha:0.5];
 [[self view] addSubview:loadingView];
 
 //スクロールビューを定義
 sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
 sv.backgroundColor = [UIColor clearColor];
 
 //チュートリアル画像を追加
 img = [UIImage imageNamed:@"tutorial_jp.png"];
 iv = [[UIImageView alloc] initWithImage:img];
 iv.center = CGPointMake(160, 500);
 
 sv.contentSize = iv.bounds.size;
 
 //スクロールを描画
 [self.view addSubview:sv];
 //チュートリアルを描画
 [sv addSubview:iv];
 
 UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
 btn.hidden =NO;
 btn.frame = CGRectMake(275, 18, 30, 30);
 [btn setTitle:@"" forState:UIControlStateNormal];
 [btn setImage:[UIImage imageNamed:@"close2.png"] forState:UIControlStateNormal]; 
 [btn addTarget:self action:@selector(hoge:)forControlEvents:UIControlEventTouchDown];
 
 [sv addSubview:btn];
 
 }*/


//90度回転
-(IBAction) changeImage90_btn_down:(id)sender
{
    
    if(_imageViewOl.image==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"確認"
                              message:@"加工する写真を指定してください"
                              delegate:nil
                              cancelButtonTitle:@"とじる"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //回転角の保持
    _imageViewOl.tag++;
    if(_imageViewOl.tag>=4)
    {
        _imageViewOl.tag=0;
    }
    //saveAngle=_imageViewOl.tag;
    
    UIImage *img=_imageView.image;
    
    UIImage *ret =[self changeImage90Angle:img];
    
    [self imageShowing:ret];
}

-(UIImage *)changeImage90Angle:(UIImage *)img
{
    //NSLog(@"angle %d",_imageViewOl.tag);
    
    
    //int angle=90;
    // NSLog(@"changeImage90_btn_down %@",_imageView.image);
    
    CGImageRef imgRef =[img CGImage];
    CGContextRef context;
    
    /*    switch (angle) {
     case 90:
     UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
     context = UIGraphicsGetCurrentContext();
     CGContextTranslateCTM(context, img.size.height, img.size.width);
     CGContextScaleCTM(context, 1.0, -1.0);
     CGContextRotateCTM(context, M_PI/2.0);
     break;
     case 180:
     UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
     context = UIGraphicsGetCurrentContext();
     CGContextTranslateCTM(context, img.size.width, 0);
     CGContextScaleCTM(context, 1.0, -1.0);
     CGContextRotateCTM(context, -M_PI);
     break;
     case 270:*/
    UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, -M_PI/2.0);
    /*           break;
     default:
     NSLog(@"you can select an angle of 90, 180, 270");
     return nil;
     }  */
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret= UIGraphicsGetImageFromCurrentImageContext();  
    
    UIGraphicsEndImageContext();
    
    //_imageView.image = img;
    return ret;
}




//アクションシート
-(IBAction) changeImageSelect_btn_down:(id)sender
{
    
    if(_imageViewOl.image==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"確認"
                              message:@"加工する写真を指定してください"
                              delegate:nil
                              cancelButtonTitle:@"とじる"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    // NSLog(@"changeImageSelect_btn_down");
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"やめる"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"セピア(Sepia)",
                                  @"ブルー(Blue)",
                                  @"モノクロ(Black&White)",
                                  @"少し暗く(Little dark)",
                                  @"少し明るく(Bright)",
                                  @"もっと明るく(More bright)",
                                  @"もふもふソフト(Softly)",
                                  @"くっきりシャープ(Sharp)",
                                  @"エンボス(Embossing)",
                                  nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:sender];
    [actionSheet release];
    
    
}

- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==9) return;
    //番号別変更
    
    [self imageChange:buttonIndex:_imageViewOl.image];    
    //    NSLog(@"%d",buttonIndex);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    //NSLog(@"alert");
    switch (buttonIndex) {
        case 1:
            break;
        case 0:
            _imageViewOl.tag=0;
            [self imageChange:10:_imageViewOl.image];    
            break;
    }
    
}


-(IBAction) resetImageSelect_btn_down:(id)sender
{
    //NSLog(@"resetImageSelect_btn_down");
    
    if(_imageViewOl.image==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"確認"
                              message:@"加工する写真を指定してください"
                              delegate:nil
                              cancelButtonTitle:@"とじる"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"確認"
                          message:@"編集を取り消しますか？"
                          delegate:self
                          cancelButtonTitle:@"はい"
                          otherButtonTitles:@"いいえ", nil];
    [alert show];
    [alert release];
    
    
}

-(IBAction) img_btn_down:(id)sender;
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _detailsPictureViewController = [[DetailsPictureViewController alloc] 
                                     initWithNibName:@"DetailsPictureViewController" 
                                     bundle:nil];
    _detailsPictureViewController.post_image = _imageViewOl.image;
    [self.navigationController pushViewController:_detailsPictureViewController 
                                         animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

@end
