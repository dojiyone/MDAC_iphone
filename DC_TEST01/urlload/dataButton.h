
//ボタン用継承クラス
@interface dataButton : UIButton 
{
@public
    NSString *_data;
    NSString *_data2;
    NSString *_data3;
    NSString *_data4;
    
    int dataint;
    int dataint2;
    int dataint3;
    int dataint4;
}
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *data2;
@property (nonatomic, retain) NSString *data3;
@property (nonatomic, retain) NSString *data4;

@property int *dataint;
@property int *dataint2;
@property int *dataint3;
@property int *dataint4;

-(id)initWithTitle:(NSString*)title data:(NSString*)data;

@end
