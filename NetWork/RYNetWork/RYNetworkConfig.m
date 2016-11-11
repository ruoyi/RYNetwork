//
//  RYNetworkConfig.m
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetworkConfig.h"
#import "AFNetworking.h"

static NSLock *taskLock;

@interface RYNetworkConfig ()

@property (nonatomic, copy) NSMutableSet *taskArr;


@end

@implementation RYNetworkConfig

+ (RYNetworkConfig *)sharedConfig {
    static RYNetworkConfig * shareInstace = nil;
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
        taskLock = [[NSLock alloc]init];
        _taskArr = [NSMutableSet new];
        self.maxRequest = 5;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.stringEncoding = NSUTF8StringEncoding;
    }
    return self;
}

- (void)addTask:(NSURLSessionTask *)task {
    [taskLock lock];
    if (task) {
        [_taskArr addObject:task];
    }
    [taskLock unlock];
}

- (void)deleteTask:(NSURLSessionTask *)task {
    [taskLock lock];
    if (task) {
        [_taskArr removeObject:task];
    }
    [taskLock unlock];
}
- (void)cancelAllRequests {
    [taskLock lock];
    [_taskArr enumerateObjectsUsingBlock:^(NSURLSessionTask *  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSURLSessionTask class]]) {
            [obj cancel];
        }
    }];
    _taskArr = [NSMutableSet new];
    [taskLock unlock];
}


@end
