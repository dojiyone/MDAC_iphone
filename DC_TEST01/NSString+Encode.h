//  NSString+Encode.h

@interface NSString (encoded)
- (NSString *)encodeString:(NSStringEncoding)encoding;
- (NSString *)stringByURLEncoding:(NSStringEncoding)encoding;
- (NSString *)stringByURLEncoding1:(NSStringEncoding)encoding;
- (NSString *)stringByURLEncoding2:(NSStringEncoding)encoding;
@end

@interface NSString (DCEncode)
+ (NSString*)stringEncodedWithBase64:(NSString*)str;
@end
