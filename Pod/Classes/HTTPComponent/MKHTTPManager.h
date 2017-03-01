//
//  MKHTTPManager.h
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, HTTPRequestType) {
    HTTPRequestType_GET = 0,
    HTTPRequestType_POST,
    HTTPRequestType_PUT,
    HTTPRequestType_DELETE,
    HTTPRequestType_PATCH,//add by Jason 11.9
    HTTPRequestType_COUNT,
};

#pragma mark -

@interface MKHTTPManager : NSObject

@property (nonatomic, strong) NSString *strDefaultURL;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

#pragma mark -

+ (MKHTTPManager *)manager;

#pragma mark -

/**
 *	@brief	根据相应参数发起默认Host URL HTTP请求(异步)
 *
 *	@param 	requestType     请求类型(HTTPRequestType -> GET, POST等)
 *	@param 	dicParams       请求参数(key-value format)
 *	@param 	success         请求成功Handle Block
 *	@param 	failure         请求失败Handle Block
 *
 *	@return 是否成功发起请求
 *
 *	Created by Mark on 2015-11-19 14:41
 */
- (BOOL)requestWithType:(HTTPRequestType)requestType
             withParams:(NSDictionary *)dicParams
            withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *	@brief	根据相应参数发起HTTP请求(异步)
 *
 *	@param 	requestType 	请求类型(HTTPRequestType -> GET, POST等)
 *	@param 	strURL      待请求的HTTP URL
 *	@param 	dicParams 	请求参数(key-value format)
 *	@param 	success 	请求成功Handle Block
 *	@param 	failure 	请求失败Handle Block
 *
 *	@return	是否成功发起请求
 *
 *	Created by Mark on 2015-11-19 14:23
 */
- (BOOL)requestWithType:(HTTPRequestType)requestType
                withURL:(NSString *)strURL
             withParams:(NSDictionary *)dicParams
            withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (BOOL)requestWithURL:(NSString *)strURL
          withBodyData:(NSData *)postBody
           withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (BOOL)uploadFileWithFileData:(NSData *)fileData
                       withURL:(NSString *)strURL
                    withParams:(NSDictionary *)dicParams
                   withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  @author Jason He, 16-10-18
 *
 *  @brief 支持指定文件类型参数上传相应的附件
 *
 *  @param fileData  <#fileData description#>
 *  @param strURL    <#strURL description#>
 *  @param dicParams <#dicParams description#>
 *  @param fileName  <#fileName description#>
 *  @param mimeType  <#mimeType description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)uploadFileWithFileData:(NSData *)fileData
                       withURL:(NSString *)strURL
                    withParams:(NSDictionary *)dicParams
                  withfileName:(NSString *)fileName
                  withMimeType:(NSString *)mimeType
                   withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)setRequestHeader:(NSDictionary *)dicHeader;

- (NSDictionary *)requestHeader;

@end
