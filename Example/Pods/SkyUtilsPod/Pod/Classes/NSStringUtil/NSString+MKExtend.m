//
//  NSString+MKExtend.m
//  Pods
//
//  Created by Mark Yang on 12/4/15.
//
//

#import "NSString+MKExtend.h"

@implementation NSString (MKExtend)

+ (NSString *)stringWithTokenData:(NSData *)deviceTokenData
{
    NSMutableString *deviceID = [NSMutableString string];
    unsigned char *ptr = (unsigned char *)[deviceTokenData bytes];
    for (NSInteger i = 0; i < 32; i++) {
        [deviceID appendString:[NSString stringWithFormat:@"%02x", ptr[i]]];
    }
    
    return [deviceID copy];
}//

/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *
 *  @param size 填入预留的大小
 *  @param font 字体大小
 *  @param isBold 字体是否加粗
 *
 *  @return 返回CGRect
 */
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)fontOfSize isBold:(BOOL)isBold{
    NSDictionary * attributes;
    if (isBold) {
        attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontOfSize]};
    }else{
        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize]};
    }
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
}

@end
