//
//  TelephonyManager.h
//  Pods
//
//  Created by Mark Yang on 8/9/15.
//
//

#import <Foundation/Foundation.h>

struct CTServerConnection {
    int a;
    int b;
    CFMachPortRef myport;
    int c;
    int d;
    int e;
    int f;
    int g;
    int h;
    int i;
};

struct CTResult {
    int flag;
    int a;
};

//struct CTServerConnection *_CTServerConnectionCreate(CFAllocatorRef, void *, int *);
//void _CTServerConnectionCopyMobileIdentity(struct CTResult *, struct CTServerConnection *, NSString **);

#pragma mark -

@interface TelephonyManager : NSObject

/**
 *	@brief	Mobile Phone Card IMEI
 *
 *	@return	IMEI String
 *
 *	Created by Mark on 2015-08-09 13:33
 */
//+ (NSString *)IMEI;

@end
