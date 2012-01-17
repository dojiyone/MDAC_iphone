//  NSString+Encode.m
 
@implementation NSString (encoding)

- (NSString *)encodeString:(NSStringEncoding)encoding
{
    return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
                                                                NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                                CFStringConvertNSStringEncodingToEncoding(encoding));
}  

-(NSString *)stringByURLEncoding:(NSStringEncoding)encoding
{
	NSArray *escapeChars = [NSArray arrayWithObjects:
							@";" ,@"/" ,@"?" ,
							@":" ,@"@" ,/*@"&" ,*/
							/*@"=" ,*/@"+" ,@"$" ,
							@"," ,@"[" ,@"]" ,
							@"#" ,@"!" ,@"'" ,
							@"(" ,@")" ,@"*" ,
							nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:
							 @"%3B" ,@"%2F" ,@"%3F" ,
							 @"%3A" ,@"%40" ,/*@"%26" ,*/
							 /*@"%3D" ,*/@"%2B" ,@"%24" ,
							 @"%2C" ,@"%5B" ,@"%5D" ,
							 @"%23" ,@"%21" ,@"%27" ,
							 @"%28" ,@"%29" ,@"%2A" ,
							 nil];
	
	NSMutableString *encodedString = [[[self stringByAddingPercentEscapesUsingEncoding:encoding] mutableCopy] autorelease];
	
	for(int i=0; i<[escapeChars count]; i++) {
		[encodedString replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
									   withString:[replaceChars objectAtIndex:i]
										  options:NSLiteralSearch
											range:NSMakeRange(0, [encodedString length])];
	}
	
	return [NSString stringWithString: encodedString];
}
//
-(NSString *)stringByURLEncoding1:(NSStringEncoding)encoding
{
	NSArray *escapeChars = [NSArray arrayWithObjects:
							@";" ,@"/" ,@"?" ,
							@":" ,@"@" ,@"&" ,
							@"=" ,@"+" ,@"$" ,
							@"," ,@"[" ,@"]" ,
							@"#" ,@"!" ,@"'" ,
							@"(" ,@")" ,@"*" ,
							nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:
							 @"%3B" ,@"%2F" ,@"%3F" ,
							 @"%3A" ,@"%40" ,@"%26" ,
							 @"%3D" ,@"%2B" ,@"%24" ,
							 @"%2C" ,@"%5B" ,@"%5D" ,
							 @"%23" ,@"%21" ,@"%27" ,
							 @"%28" ,@"%29" ,@"%2A" ,
							 nil];
	
	NSMutableString *encodedString = [[[self stringByAddingPercentEscapesUsingEncoding:encoding] mutableCopy] autorelease];
	
	for(int i=0; i<[escapeChars count]; i++) {
		[encodedString replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
									   withString:[replaceChars objectAtIndex:i]
										  options:NSLiteralSearch
											range:NSMakeRange(0, [encodedString length])];
	}
	
	return [NSString stringWithString: encodedString];
}
//
-(NSString *)stringByURLEncoding2:(NSStringEncoding)encoding
{
	NSArray *escapeChars = [NSArray arrayWithObjects:
							@";" ,@"/" ,@"?" ,
							@":" ,@"@" ,/*@"&" ,*/
							@"=" ,@"+" ,@"$" ,
							@"," ,@"[" ,@"]" ,
							@"#" ,@"!" ,@"'" ,
							@"(" ,@")" ,@"*" ,
							nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:
							 @"%3b" ,@"%2f" ,@"%3f" ,
							 @"%3a" ,@"%40" ,/*@"%26" ,*/
							 @"%3d" ,@"%2b" ,@"%24" ,
							 @"%2c" ,@"%5b" ,@"%5d" ,
							 @"%23" ,@"%21" ,@"%27" ,
							 @"%28" ,@"%29" ,@"%2a" ,
							 nil];
	
	NSMutableString *encodedString = [[[self stringByAddingPercentEscapesUsingEncoding:encoding] mutableCopy] autorelease];
	
	for(int i=0; i<[escapeChars count]; i++) {
		[encodedString replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
									   withString:[replaceChars objectAtIndex:i]
										  options:NSLiteralSearch
											range:NSMakeRange(0, [encodedString length])];
	}
	
	return [NSString stringWithString: encodedString];
}

@end
