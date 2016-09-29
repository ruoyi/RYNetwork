//
//  RYNetWorkHander.m
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//
#import "RYNetWorkGlobalConfig.h"

#import "RYNetWorkHandler.h"
#import "RYNetWorkAgent.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

@interface RYNetWorkHandler ()

// it`s become nil when request finish,in order to prevent a circular reference

@property (nonatomic, strong, readwrite) NSURLSessionTask *task;

@property (nonatomic, weak, readonly) NSObject<RYNetWorkHanderReduce> *reduceProxy;

@property (nonatomic, copy, readonly) NSDictionary *allParameters;

@property (nonatomic, copy, readonly) NSString *hostURLStr;

@property (nonatomic, copy, readonly) NSString *pathURLStr;

@property (nonatomic, assign, readonly) RYNetworkRequestMethod method;

@property (nonatomic, copy) RYAttachmentBlock attachmentBlock;

@property (nonatomic, assign) BOOL cacheRequest;

@end

@interface RYNetWorkGlobalConfig (Handle)

- (void)deleteTask:(NSURLSessionTask *)task;

@end

@implementation RYNetWorkHandler

-(RYNetWorkHandler *(^)(RYNetworkRequestMethod))requestMethod {
    return ^(RYNetworkRequestMethod value){
        _method = value;
        return self;
    };
}

- (RYNetWorkHandler *(^)(NSDictionary *))parameters {
    return ^(NSDictionary *value){
        _allParameters = value;
        return self;
    };
}


- (RYNetWorkHandler *(^)(NSString *))hostURL {
    return ^(NSString *value){
        _hostURLStr = value;
        return self;
    };
}

- (RYNetWorkHandler *(^)(NSString *))path {
    return ^(NSString *value){
        _pathURLStr = value;
        return self;
    };
}

- (RYNetWorkHandler *(^)(NSObject<RYNetWorkHanderReduce> *))reduce {
    return ^(NSObject<RYNetWorkHanderReduce> *value){
        _reduceProxy = value;
        return self;
    };
}

- (RYNetWorkHandler *(^)(RYAttachmentBlock))attachment {
    return ^(RYAttachmentBlock value){
        _attachmentBlock = value;
        return self;
    };
}

- (RYNetWorkHandler *(^)(BOOL ))needCache {
    return ^(BOOL value) {
        _cacheRequest = value;
        return self;
    };

}

- (void)_initRequestData {
    if (!_hostURLStr) {
        _hostURLStr = self.commonHostStr;
    }
    if (!_pathURLStr) {
        _pathURLStr = self.commonPathStr;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic addEntriesFromDictionary:self.commonParameter];
    [dic addEntriesFromDictionary:_allParameters];
    _allParameters = [dic copy];
}

- (void)handleResponse:(void (^)(RYNewWorkResponse *object))handle {
    [self _initRequestData];
    [[RYNetWorkAgent sharedAgent] addRequest:self withHandle:handle];
}


- (void)cancelRequest {
    [[RYNetWorkGlobalConfig sharedConfig]deleteTask:self.task];
    [self.task cancel];
}

- (void)dealloc {
    [self cancelRequest];
}

#pragma mark - RYNetWorkHanderConfigProtocol

- (NSDictionary *)commonParameter {
    return nil;
}

- (NSString *)commonHostStr {
    return nil;
}

- (NSString *)commonPathStr {
    return nil;
}


- (NSDictionary *)extraHeader {
    return nil;
}

//- (AFHTTPResponseSerializer *)responseSerializer {
//    return [AFHTTPResponseSerializer serializer];
//}
//
//- (AFHTTPRequestSerializer *)requestSerializer {
//    return [AFHTTPRequestSerializer serializer];
//}


- (id)filterOriginalData:(id)originalData {
    return originalData;
}

- (NSTimeInterval)timeout {
    return 60;
}


- (void)requestWillStart {

}

- (void)requestDidEnd {

}


@end
