//
//  RYNetworkHander.m
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetworkHandler.h"
#import "RYNetworkAgent.h"
#import "RYNetworkConfig.h"

@interface RYNetworkHandler ()

// it`s become nil when request finish,in order to prevent a circular reference

@property (nonatomic, strong, readwrite) NSURLSessionTask *task;

@property (nonatomic, weak, readonly) NSObject<RYNetworkHanderReduce> *reduceProxy;

@property (nonatomic, copy, readonly) NSDictionary *allParameters;

@property (nonatomic, copy, readonly) NSString *hostURLStr;

@property (nonatomic, copy, readonly) NSString *pathURLStr;

@property (nonatomic, assign, readonly) RYNetworkRequestMethod method;

@property (nonatomic, copy, readonly) RYAttachmentBlock attachmentBlock;

@property (nonatomic, copy, readonly) RYProgressBlock handleProgress;

@property (nonatomic, copy, readonly) RYNetworkHandlerBlock handleBlock;

@end

@interface RYNetworkConfig (Handle)

- (void)deleteTask:(NSURLSessionTask *)task;

@end

@implementation RYNetworkHandler

-(RYNetworkHandler *(^)(RYNetworkRequestMethod))requestMethod {
    return ^(RYNetworkRequestMethod value){
        _method = value;
        return self;
    };
}

- (RYNetworkHandler *(^)(NSDictionary *))parameters {
    return ^(NSDictionary *value){
        _allParameters = [value copy];
        return self;
    };
}


- (RYNetworkHandler *(^)(NSString *))hostURL {
    return ^(NSString *value){
        _hostURLStr = [value copy];
        return self;
    };
}

- (RYNetworkHandler *(^)(NSString *))path {
    return ^(NSString *value){
        _pathURLStr = [value copy];
        return self;
    };
}

- (RYNetworkHandler *(^)(NSObject<RYNetworkHanderReduce> *))reduce {
    return ^(NSObject<RYNetworkHanderReduce> *value){
        _reduceProxy = value;
        return self;
    };
}

- (RYNetworkHandler *(^)(RYAttachmentBlock))attachment {
    return ^(RYAttachmentBlock value){
        _attachmentBlock = [value copy];
        return self;
    };
}

- (RYNetworkHandler *_Nonnull(^_Nonnull)(RYProgressBlock _Nonnull))progress {
    return ^(RYProgressBlock value) {
        _handleProgress = [value copy];
        return self;
    };
}


- (void)_initRequestData {
    if (!_hostURLStr) {
        _hostURLStr = [self.commonHostStr copy];
    }
    if (!_pathURLStr) {
        _pathURLStr = [self.commonPathStr copy];
    }
    if (_pathURLStr) {
        if (![_pathURLStr hasPrefix:@"/"]) {
            _pathURLStr = [NSString stringWithFormat:@"/%@",[_pathURLStr stringByAppendingString:@"/"]];
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic addEntriesFromDictionary:[self.extraParameter copy]];
    [dic addEntriesFromDictionary:[_allParameters copy]];
    _allParameters = [dic copy];
}

- (void)handleResponse:(RYNetworkHandlerBlock _Nullable)handle {
    [self _initRequestData];
    _handleBlock = handle;
    [self requestWillStart];
    if ([self.delegate respondsToSelector:@selector(requestShouldStart:)]) {
        [self.delegate requestShouldStart:self];
    }
    [[RYNetworkAgent sharedAgent] addRequest:self];
}

- (void)cancelRequest {
    [self _clearBlock];
    [[RYNetworkConfig sharedConfig] deleteTask:self.task];
    [self.task cancel];
}


- (void)handlerRequestSuccess{
    [self filterOriginalData:self.responseObj];
    if ([self.reduceProxy respondsToSelector:@selector(reduceResponseDataBeforeHandle:responseData:)]) {
        [self.reduceProxy reduceResponseDataBeforeHandle:self responseData:self.responseObj];
    }
    
}

- (void)handlerRequestFailure{
    
    //    handle(resposnseData);
}

- (void)handlerRequestComplete:(id  _Nullable)responseObject error:(NSError * _Nullable)error{
    _responseObj = [[RYNetworkResponse alloc]initWithSccess:(responseObject != nil) responseData:responseObject error:error];
    if (_responseObj.isSuccess) {
        [self handlerRequestSuccess];
    }else {
        [self handlerRequestFailure];
    }
    if (self.handleBlock) {
        self.handleBlock(self.responseObj);
    }
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
    [self requestDidEnd];
    [self _clearBlock];
}

- (void)_clearBlock {
    _handleBlock = nil;
    _attachmentBlock = nil;
    _handleProgress = nil;
}

- (void)dealloc {
    [self cancelRequest];
}

#pragma mark - RYNetworkHanderConfigProtocol

- (NSStringEncoding)stringEncoding {
    return NSUTF8StringEncoding;
}

- (NSURLRequestCachePolicy)cachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (NSString *)commonHostStr {
    return nil;
}

- (NSString *)commonPathStr {
    return nil;
}

- (NSDictionary *)extraParameter {
    return nil;
}

- (NSDictionary *)extraHeader {
    return nil;
}

- (NSTimeInterval)timeoutInterval {
    return 15;
}

- (void)filterOriginalData:(RYNetworkResponse *)originalData {
    
}

- (void)requestWillStart {

}

- (void)requestDidEnd {

}


@end
