//
//  RYNetworkAgent.m
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetworkAgent.h"
#import "RYNetworkConfig.h"

@interface RYNetworkHandler (Handle)

@property (nonatomic, strong, readwrite) NSURLSessionTask *task;

@property (nonatomic, weak, readonly) NSObject<RYNetworkHanderReduce> *reduceProxy;

@property (nonatomic, copy, readonly) NSDictionary *allParameters;

@property (nonatomic, copy, readonly) NSString *hostURLStr;

@property (nonatomic, copy, readonly) NSString *pathURLStr;

@property (nonatomic, assign, readonly) RYNetworkRequestMethod method;

@property (nonatomic, copy) RYAttachmentBlock attachmentBlock;

@property (nonatomic, assign, readonly) RYProgressBlock handleProgress;

- (void)handlerRequestComplete:(id  _Nullable)responseObject error:(NSError * _Nullable)error;

@end


@interface RYNetworkConfig (Handle)

- (void)deleteTask:(NSURLSessionTask *)task;

- (void)addTask:(NSURLSessionTask *)task;

@end


@interface RYNetworkAgent ()

@end

static RYNetworkAgent * shareInstace = nil;

@implementation RYNetworkAgent

+ (RYNetworkAgent *)sharedAgent {
    static dispatch_once_t onceMark;
    dispatch_once(&onceMark, ^{
        shareInstace = [[self alloc]init];
    });
    return shareInstace;
}

- (instancetype)init
{
    if (shareInstace) {
        return shareInstace;
    }
    self = [super init];
    if (self) {
        NSString *baseURL = [[RYNetworkConfig sharedConfig].hostURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet controlCharacterSet]];
        NSURL *url = [NSURL URLWithString:baseURL];
        if (baseURL) {
            self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        } else {
            self.manager = [AFHTTPSessionManager manager];
        }
    }
    return self;
}


- (void)addRequest:(RYNetworkHandler *)request{
    NSString *pathStr = @"";
    if (request.pathURLStr) {
        pathStr = request.pathURLStr;
        if (pathStr && ![pathStr hasPrefix:@"/"]) {
            pathStr = [@"/" stringByAppendingString:pathStr];
        }
    }
    
    NSString *requestStr = [request.hostURLStr stringByAppendingString:pathStr];
    if (!request.hostURLStr) {
       requestStr =  [[RYNetworkConfig sharedConfig].hostURL stringByAppendingString:pathStr];
    }
    
    for (NSString *headerKey in request.extraHeader) {
        NSString *headerValue = request.extraHeader[headerKey];
        if ([headerKey isKindOfClass:[NSString class]]&& [headerValue isKindOfClass:[NSString class]]) {
            [self.manager.requestSerializer setValue:headerValue forHTTPHeaderField:headerKey];
        }else {
            RYLog(@"Error, class of key/value in extraHeader medth must be NSString.");
        }
    }
    self.manager.requestSerializer.timeoutInterval = request.timeoutInterval;

    
    NSURLSessionTask *task;
    // request should start
    switch (request.method) {
        case RYNetworkRequestMethodGet:
            task = [self.manager GET:requestStr
                          parameters:request.allParameters
                            progress:request.handleProgress
                             success:[self requestSccess:request]
                             failure:[self requestFilure:request]];
            break;
        case RYNetworkRequestMethodPost:
            task = [self.manager POST:requestStr
                           parameters:request.allParameters
            constructingBodyWithBlock:request.attachmentBlock
                             progress:request.handleProgress
                              success:[self requestSccess:request]
                              failure:[self requestFilure:request]];
            break;
        case RYNetworkRequestMethodPut:
            task = [self.manager PUT:requestStr
                          parameters:request.allParameters
                             success:[self requestSccess:request]
                             failure:[self requestFilure:request]];
            break;
        case RYNetworkRequestMethodDelete:
            task = [self.manager DELETE:requestStr
                          parameters:request.allParameters
                             success:[self requestSccess:request]
                             failure:[self requestFilure:request]];
            break;
        default:
            break;
    }
    request.task = task;
    RYLog(@"******** Request URL ********\n%@",task.currentRequest.URL.absoluteString);
    [[RYNetworkConfig sharedConfig] addTask:task];
}

- (void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))requestSccess:(RYNetworkHandler *)request{
    return ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [[RYNetworkConfig sharedConfig] deleteTask:task];
        [request handlerRequestComplete:responseObject error:nil];
    };
}

- (void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))requestFilure:(RYNetworkHandler *)request{
    return ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[RYNetworkConfig sharedConfig] deleteTask:task];
        [request handlerRequestComplete:nil error:error];
    };
}

#pragma mark - Private
- (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        if (!_manager) {
            _manager = [AFHTTPSessionManager manager];
            _manager.securityPolicy.allowInvalidCertificates = YES;
            _manager.operationQueue.maxConcurrentOperationCount = [RYNetworkConfig sharedConfig].maxRequest;
            _manager.requestSerializer = [[RYNetworkConfig sharedConfig] requestSerializer];
            _manager.responseSerializer = [[RYNetworkConfig sharedConfig] responseSerializer];
        }
    }
    return _manager;
}

@end
