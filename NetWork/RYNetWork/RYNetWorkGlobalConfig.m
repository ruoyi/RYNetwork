//
//  RYNetWorkGlobalConfig.m
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetWorkGlobalConfig.h"
#import "AFNetworking.h"

static NSLock *taskLock;
@implementation RYNetWorkGlobalConfig {
    NSMutableArray *_taskArr;
}

+ (RYNetWorkGlobalConfig *)sharedConfig {
    static RYNetWorkGlobalConfig * shareInstace = nil;
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
        _taskArr = [NSMutableArray new];
        self.maxRequest = 3;
        self.timeout = 60;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>\n{ baseURL: %@, timeout: %lu }", NSStringFromClass([self class]), self, self.hostURL,(unsigned long)self.maxRequest];
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
    [_taskArr enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSURLSessionTask class]]) {
            [obj cancel];
        }
    }];
    _taskArr = [NSMutableArray new];
    [taskLock unlock];
}


@end
