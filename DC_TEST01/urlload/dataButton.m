#import "dataButton.h"


@implementation dataButton
@synthesize data = _data;
@synthesize data2 = _data2;
@synthesize data3 = _data3;
@synthesize data4 = _data4;
@synthesize dataint = _dataint;
@synthesize dataint2 = _dataint2;
@synthesize dataint3 = _dataint3;
@synthesize dataint4 = _dataint4;


-(id)initWithTitle:(NSString*)title data:(NSString*)data 
{
    if (self = [super init]) 
    {
        self.data = data;
        
        //self.frame = CGRectMake(50, 100, 100, 37);
        // [self setTitle:title forState:UIControlStateNormal];
        
        // ここでデザインとかを自由に変更できます
        // 今回は黒地に赤文字というセンス０なデザインでいきます
        // [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // self.alpha = 0.75f;
        // [self setBackgroundColor:[UIColor blackColor]];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code
    // ここでもデザインを変更できます。
}


- (void)dealloc 
{
    [_data release];
    [super dealloc];
}
@end
