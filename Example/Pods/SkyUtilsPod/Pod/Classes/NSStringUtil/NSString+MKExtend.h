//
//  NSString+MKExtend.h
//  Pods
//
//  Created by Mark Yang on 12/4/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MKExtend)

/**
 *	@brief	根据Device Token Data转换成相应字符串
 *
 *	@param 	deviceTokenData
 *
 *	@return	Device Token String
 *
 *	Created by Mark on 2015-12-04 16:52
 */
+ (NSString *)stringWithTokenData:(NSData *)deviceTokenData;

/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *
 *  @param size 填入预留的大小
 *  @param font 字体大小
 *  @param isBold 字体是否加粗
 *
 *  @return 返回CGRect
 */
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)fontOfSize isBold:(BOOL)isBold;
@end
