

#import <UIKit/UIKit.h>


@interface XmlBaseCtrl : UIViewController 
{
	
@public
	NSURLConnection *conn;
	NSMutableData *data;
    int _showType;
}

- (void)start:(NSString *)urlString:(int)showType;
- (void)parseDidEnd:(NSMutableData *)data:(int)showType;
- (void)abort;

@end
