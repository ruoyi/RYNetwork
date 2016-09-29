//
//  RYNetWorkAgent.m
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetWorkAgent.h"
#import "AFNetworking.h"
#import "RYNetWorkGlobalConfig.h"

@interface RYNetWorkHandler (Handle)

@property (nonatomic, strong, readwrite) NSURLSessionTask *task;

@property (nonatomic, weak, readonly) NSObject<RYNetWorkHanderReduce> *reduceProxy;

@property (nonatomic, copy, readonly) NSDictionary *allParameters;

@property (nonatomic, copy, readonly) NSString *hostURLStr;

@property (nonatomic, copy, readonly) NSString *pathURLStr;

@property (nonatomic, assign, readonly) RYNetworkRequestMethod method;

@property (nonatomic, copy) RYAttachmentBlock attachmentBlock;

@end

@interface RYNetWorkGlobalConfig (Handle)

- (void)deleteTask:(NSURLSessionTask *)task;

- (void)addTask:(NSURLSessionTask *)task;

@end

@interface RYNetWorkAgent ()

@end

@implementation RYNetWorkAgent

+ (RYNetWorkAgent *)sharedAgent {
    static RYNetWorkAgent * shareInstace = nil;
    static dispatch_once_t onceMark;
    dispatch_once(&onceMark, ^{
        shareInstace = [[self alloc]init];
    });
    return shareInstace;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *baseURL = [[RYNetWorkGlobalConfig sharedConfig].hostURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet controlCharacterSet]];
        NSURL *url = [NSURL URLWithString:baseURL];
        if (baseURL) {
            self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        } else {
            self.manager = [AFHTTPSessionManager manager];
        }
    }
    return self;
}


- (void)addRequest:(RYNetWorkHandler *)request withHandle:(void (^)(RYNewWorkResponse *object))handle{
    NSString *requestStr = [NSString stringWithFormat:@"%@%@",request.hostURLStr,StringValue(request.pathURLStr)];
    if (!request.hostURLStr) {
        requestStr = [NSString stringWithFormat:@"%@%@",[RYNetWorkGlobalConfig sharedConfig].hostURL,StringValue(request.pathURLStr)];
    }
    for (NSString *headerKey in request.extraHeader) {
        NSString *headerValue = request.extraHeader[headerKey];
        if ([headerKey isKindOfClass:[NSString class]]&& [headerValue isKindOfClass:[NSString class]]) {
            [_manager.requestSerializer setValue:headerValue forHTTPHeaderField:headerKey];
        }else {
            RYLog(@"Error, class of key/value in extraHeader medth must be NSString.");
        }
    }
    NSURLSessionTask *task;
    [request requestWillStart];
    if ([request.delegate respondsToSelector:@selector(requestShouldStart:)]) {
        [request.delegate requestShouldStart:request];
    }
    switch (request.method) {
        case RYNetworkRequestMethodGet:
            task = [self.manager GET:requestStr
                          parameters:request.allParameters
                            progress:nil
                             success:[self requestSccess:request handle:handle]
                             failure:[self requestFilure:request handle:handle]];
            break;
        case RYNetworkRequestMethodPost:
            task = [self.manager POST:requestStr
                           parameters:request.allParameters
            constructingBodyWithBlock:request.attachmentBlock
                             progress:nil
                              success:[self requestSccess:request handle:handle]
                              failure:[self requestFilure:request handle:handle]];
            request.attachmentBlock = nil;
            break;
        case RYNetworkRequestMethodPut:
            task = [self.manager PUT:requestStr
                          parameters:request.allParameters
                             success:[self requestSccess:request handle:handle]
                             failure:[self requestFilure:request handle:handle]];
            break;
        case RYNetworkRequestMethodDelete:
            task = [self.manager DELETE:requestStr
                          parameters:request.allParameters
                             success:[self requestSccess:request handle:handle]
                             failure:[self requestFilure:request handle:handle]];
            break;
        default:
            break;
    }
    request.task = task;
    [[RYNetWorkGlobalConfig sharedConfig]addTask:task];
}

- (void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))requestSccess:(RYNetWorkHandler *)request handle:(void (^)(RYNewWorkResponse *object))handle{
    RYNewWorkResponse *resposnseData = [RYNewWorkResponse new];
    return ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [[RYNetWorkGlobalConfig sharedConfig] deleteTask:task];
        resposnseData.isSuccess = YES;
        resposnseData.responseData = responseObject;
        id tempData = [request filterOriginalData:responseObject];
        if ([request.reduceProxy respondsToSelector:@selector(reduceResponseDataBeforeHandle:responseData:)]) {
            tempData = [request.reduceProxy reduceResponseDataBeforeHandle:request responseData:tempData];
        }
        resposnseData.responseData = tempData;
        [request requestDidEnd];
        if ([request.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [request.delegate requestDidFinish:request];
        }
        handle(resposnseData);
    };
}

- (void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))requestFilure:(RYNetWorkHandler *)request handle:(void (^)(RYNewWorkResponse *object))handle {
    RYNewWorkResponse *resposnseData = [RYNewWorkResponse new];
    return ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[RYNetWorkGlobalConfig sharedConfig] deleteTask:task];
        RYLog(@"Error\r%@",error);
        resposnseData.isSuccess = NO;
        resposnseData.error = error;
        [request requestDidEnd];
        if ([request.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [request.delegate requestDidFinish:request];
        }
        handle(resposnseData);
    };
}



#pragma mark - Private
- (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        if (!_manager) {
            _manager = [AFHTTPSessionManager manager];
            // 设置允许同时最大并发数量，过大容易出问题
        }
        _manager.responseSerializer = [[RYNetWorkGlobalConfig sharedConfig] responseSerializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
        _manager.requestSerializer = [[RYNetWorkGlobalConfig sharedConfig] requestSerializer];
        _manager.requestSerializer.timeoutInterval = [RYNetWorkGlobalConfig sharedConfig].timeout;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.operationQueue.maxConcurrentOperationCount = [RYNetWorkGlobalConfig sharedConfig].maxRequest;
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        [_manager setSecurityPolicy:securityPolicy];
    }
    return _manager;
}

@end
