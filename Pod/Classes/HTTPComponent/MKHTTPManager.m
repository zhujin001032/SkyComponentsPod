//
//  MKHTTPManager.m
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import "MKHTTPManager.h"
static CGFloat kTimeoutInterval = 30;   // unit : second

@interface MKHTTPManager ()

//@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

#pragma mark -

@implementation MKHTTPManager

+ (MKHTTPManager *)manager
{
    static MKHTTPManager *__sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[MKHTTPManager alloc] init];
    });
    
    return __sharedManager;
}//

- (id)init
{
    self = [super init];
    if (self) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_operationManager.requestSerializer setTimeoutInterval:kTimeoutInterval];
        [_operationManager.requestSerializer setValue:@"application/json;form-data; charset=utf-8"
                                   forHTTPHeaderField:@"Content-Type"];
        [_operationManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }
    
    return self;
}//

#pragma mark -

- (BOOL)requestWithType:(HTTPRequestType)requestType
             withParams:(NSDictionary *)dicParams
            withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self requestWithType:requestType
                         withURL:_strDefaultURL
                      withParams:dicParams
                     withSuccess:success
                     withFailure:failure];
}//

- (BOOL)requestWithType:(HTTPRequestType)requestType
                withURL:(NSString *)strURL
             withParams:(NSDictionary *)dicParams
            withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (strURL.length < 1) {
        return NO;
    }
    
    switch (requestType) {
        // GET参数也是key-value, 已通过测试
        case HTTPRequestType_GET: {
            [_operationManager GET:strURL
                        parameters:dicParams
                           success:success
                           failure:failure];
            
            break;
        }
        case HTTPRequestType_POST: {
            [_operationManager POST:strURL
                         parameters:dicParams
                            success:success
                            failure:failure];
            break;
        }
        case HTTPRequestType_PUT: {
            [_operationManager PUT:strURL
                        parameters:dicParams
                           success:success
                           failure:failure];
            
//            [_operationManager CirlerPUT:strURL
//                        parameters:dicParams
//                           success:success
//                        failure:failure];

            break;
        }
            
        case HTTPRequestType_PATCH: {
            
            [_operationManager PATCH:strURL
                          parameters:dicParams
                             success:success
                             failure:failure];
            break;
        }

        case HTTPRequestType_DELETE: {
            [_operationManager DELETE:strURL
                           parameters:dicParams
                              success:success
                              failure:failure];
            break;
        }
        default:
            break;
    }
    
    
    return YES;
}//

- (BOOL)requestWithURL:(NSString *)strURL
          withBodyData:(NSData *)postBody
           withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_operationManager POST:strURL
                 parameters:nil
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      if (postBody) {
          formData = (id)postBody;
      }
  }
                    success:success
                    failure:failure];
    
    return YES;
}//

- (BOOL)uploadFileWithFileData:(NSData *)fileData
                       withURL:(NSString *)strURL
                    withParams:(NSDictionary *)dicParams
                   withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_operationManager POST:strURL
                 parameters:dicParams
  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//      [formData appendPartWithFormData:fileData name:@"FileContent"];
      if (fileData) {
          [formData appendPartWithFileData:fileData
                                      name:@"profile_image"
                                  fileName:@"profile_image.png"
                                  mimeType:@"image/png"];
      }
  }
                    success:success
                    failure:failure];
    
    
    return YES;
}//

- (BOOL)uploadFileWithFileData:(NSData *)fileData
                       withURL:(NSString *)strURL
                    withParams:(NSDictionary *)dicParams
                  withfileName:(NSString *)fileName
                  withMimeType:(NSString *)mimeType
                   withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_operationManager POST:strURL
                 parameters:dicParams
  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      //      [formData appendPartWithFormData:fileData name:@"FileContent"];
      if (fileData) {
          [formData appendPartWithFileData:fileData
                                      name:@"FileContent"
                                  fileName:fileName
                                  mimeType:mimeType];
      }
  }
                    success:success
                    failure:failure];
    
    
    return YES;
}//
#pragma mark -
#pragma mark Add Request Header Field

- (void)setRequestHeader:(NSDictionary *)dicHeader
{
    for (NSString *key in dicHeader) {
        // 必须stringWithFormat, 预防NSNumber导致crash.
        [_operationManager.requestSerializer setValue:[NSString stringWithFormat:@"%@", dicHeader[key]]
                                   forHTTPHeaderField:key];
    }
}//

- (NSDictionary *)requestHeader
{
    return [_operationManager.requestSerializer HTTPRequestHeaders];
}//

@end
