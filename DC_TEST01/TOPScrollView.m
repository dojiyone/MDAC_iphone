//
//  TOPScrollView.m
//  DC_TEST01
//

#import "TOPScrollView.h"

@implementation TOPScrollView

//自前作成時の初期化
/*
- (id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        //背景色の指定
        self.backgroundColor=[UIColor whiteColor];
        
        //イメージの読み込み
        imgBg=[[UIImage imageNamed:@"bg.png"] retain];
        
        NSLog(@"initWithFrame");
    }
    return self;
}
*/

// xibから呼び出された時の初期化
- (id)initWithCoder:(NSCoder *)decoder 
{
    if (self=[super initWithCoder:decoder]) 
    {
        NSLog(@"initWithCoder");
        
        //背景色の指定
        self.backgroundColor=[UIColor whiteColor];
        
        //イメージの読み込み
        imgBg=[[UIImage imageNamed:@"bg.png"] retain];
        
        // スクロールエリアの決定
//        self.contentSize = imgBg.size;

    }

    return self;
}

//メモリの解放
- (void)dealloc 
{
    //イメージの解放
    [imgBg release];    //メモリの解放
    [super dealloc];
}

@end
