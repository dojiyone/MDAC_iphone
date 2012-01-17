#import "XmlBaseCtrl.h"

@implementation XmlBaseCtrl

- (void)start:(NSString *)urlString:(int)showType
{
    _showType=showType;
	[self abort];
	data = [[NSMutableData alloc] initWithCapacity:0];
    
    //NSData *jsonData = [urlString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    
    NSURLRequest *req = [NSURLRequest 
						 requestWithURL:[NSURL URLWithString:urlString] 
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
						 timeoutInterval:30.0];
    //[req setHTTPBody:[url dataUsingEncoding:NSUTF8StringEncoding]];
    
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];//非同期アクセス}
}
//ヘッダー応答
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[data setLength:0];
}

//非同期通信ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata
{
	[data appendData:nsdata];		
}
//エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self abort];
}

//ダウソ完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self parseDidEnd:data:_showType];
	[self abort];
}

-(void)abort
{
	if(conn != nil){
		[conn cancel];
		[conn release];
		conn = nil;
	}
	if(data != nil)
    {
        [data release];
		data = nil;
    }
}

- (void)parseDidEnd:(NSMutableData *)data:(int)showType
{
}

- (void)dealloc
{
	[conn cancel];
    [conn release];
    [data release];
    
    [super dealloc];
}

@end
