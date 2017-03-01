//
//  NSString+MKValidateRegex.m
//  Pods
//
//  Created by Mark Yang on 11/24/15.
//
//

#import "NSString+MKValidateRegex.h"

@implementation NSString (MKValidateRegex)

- (BOOL)validateMobileNumber
{
    NSString *mobileRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0,6-8])|(18[0,0-9]))\\d{8}$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    return [mobilePredicate evaluateWithObject:self];
}//

- (BOOL)isMobile
{
    /**
     * 手机号码(内容引用百度百科手机号词条)
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,145(上网卡),152,155,156,185,186
     * 电信：133,1349(卫星电话),153,180,189,181
     * 4G号段:170:[1700/1701/1702(电信)、1705(移动)、1707/1708/1709(联通)]、176(联通)、177(电信)、178(移动)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[06-8]|47)\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|47)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|45)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] ||
         [regextestcm evaluateWithObject:self] ||
         [regextestct evaluateWithObject:self] ||
         [regextestcu evaluateWithObject:self])) {
        return YES;
    }
    
    return NO;
}//

- (BOOL)validatePassword
{
    NSString *passwordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    return [passwordPredicate evaluateWithObject:self];
}//

- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}//

@end
