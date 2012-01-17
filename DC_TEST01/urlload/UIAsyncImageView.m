
#import <QuartzCore/QuartzCore.h>
#import "UIAsyncImageView.h"

@implementation UIAsyncImageView

/*-(void)loadImage:(NSString *)url
{
	[self abort];
	self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];	
	data = [[NSMutableData alloc] initWithCapacity:0];

	NSURLRequest *req = [NSURLRequest 
						 requestWithURL:[NSURL URLWithString:url] 
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
						 timeoutInterval:30.0];
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}*/

- (void) changeImageStyle:(UIImage *)baseImage
                              :(int)dw :(int)dh
                              :(int)cx :(int)cy
                              :(NSString *)fmt
                              :(int)fs
                              :(float)gm
                              :(int)st :(int)sp
                              :(int)dr
                              :(int)zr :(int)zp
{
    //?sr.dw=100&sr.dh=100サイズ変換
    NSString *type1=@"";
    type1=[NSString stringWithFormat:@"&sr.dw=%d&sr.dh=%d",dw,dh];
    
    //?sr.cx=2&sr.cy=2中央クロップ
    NSString *type2=@"";
    if(cx!=0)
        type2=[NSString stringWithFormat:@"&sr.cx=%d&sr.cy=%d",cx,cy];
    
    //?sr.fmt=JPEG JPG変換
    NSString *type3=@"";
    if(fmt!=@"")
        type3=[NSString stringWithFormat:@"&sr.fmt=%@",fmt];
    
    //?sr.fs=800ファイルサイズ上限（バイト）
    NSString *type4=@"";
    if(cx!=0)
        type4=[NSString stringWithFormat:@"&sr.fs=%d",fs];
    
    //?sr.gm=0.5ガンマ補正（float）    
    NSString *type5=@"";
    if(cx!=0)
        type5=[NSString stringWithFormat:@"&sr.gm=%f",gm];
    
    //?sr.st=1&sr.sp=3スタンプ合成
    NSString *type6=@"";
    if(st!=0)
        type6=[NSString stringWithFormat:@"&sr.st=%d&sr.sp=%d",st,sp];
    
    //?sr.dr=80サイズ比率変更（％）
    NSString *type7=@"";
    if(dr!=0)
        type7=[NSString stringWithFormat:@"&sr.dr=%d",dr];
    
    //?sr.zr=300&sr.zp=5拡大変換（100=1倍）
    NSString *type8=@"";
    if(zr!=0)
        type8=[NSString stringWithFormat:@"&sr.zr=%d&sr.zp=%d",zr,zp];
    
    
    NSString *url = [NSString stringWithFormat:CV_SERVER_URL "%@?%@%@%@%@%@%@%@%@",baseImage,type1,type2,type3,type4,type5,type6,type7,type8];
    
    
    
    //URLリクエスト
	[self abort];
	self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];	
	data = [[NSMutableData alloc] initWithCapacity:0];
    
	NSURLRequest *req = [NSURLRequest 
						 requestWithURL:[NSURL URLWithString:url] 
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
						 timeoutInterval:30.0];
    // イメージの回転
    //CGAffineTransform rotate = CGAffineTransformMakeRotation(3.0f * (M_PI / 180.0f));
    //[img2 setTransform:rotate];
    
    
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata{
	[data appendData:nsdata];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self abort];
}

//ロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//self.contentMode = UIViewContentModeScaleAspectFit;
    //self.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight;		

	self.image = [UIImage imageWithData:data];
	//[self addCorner];
	
	[self abort];
}

-(void)abort{
	if(conn != nil){
		[conn cancel];
		[conn release];
		conn = nil;
	}
	if(data != nil){
		[data release];
		data = nil;
	}
}

- (void)dealloc {
	[conn cancel];
    [conn release];
    [data release];
    [super dealloc];
}



//かどをまるめる
/*- (void)addCorner
{	

	CALayer *layer = self.layer;
	layer.masksToBounds = YES;
	
	CGFloat bg_rgba[] = { 1.0, 0.0, 0.0, 0.7 };
	CGFloat border_rgba[] = { 0.0, 0.0, 0.0, 0.2 };
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef bgColor = CGColorCreate(colorSpace, bg_rgba);
	layer.backgroundColor = bgColor;
	CGColorRelease(bgColor);
	
	CGColorRef borderColor = CGColorCreate(colorSpace, border_rgba);
	layer.borderColor = borderColor;
	layer.borderWidth = 1;
	CGColorRelease(borderColor);
	
	CGColorSpaceRelease(colorSpace);
	
	layer.cornerRadius = 3;	
}*/

@end
