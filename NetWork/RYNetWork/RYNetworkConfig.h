//
//  RYNetworkConfig.h
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define RYLog(FORMAT, ...) fprintf(stderr,"\t%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define RYLog(FORMAT, ...) nil
#endif

static inline NSString *RY_StringValue(id obj) {
    if([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [(NSNumber *)obj stringValue];
    }
    return @"";
}


@class AFHTTPRequestSerializer,AFHTTPResponseSerializer;
@interface RYNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (RYNetworkConfig *)sharedConfig;

@property (nonatomic, strong) NSString *hostURL;
// define is 60s
@property (nonatomic, assign) NSUInteger maxRequest;


@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

@property (nonatomic, strong, readonly) AFHTTPRequestSerializer *requestSerializer;

- (void)cancelAllRequests;

@end

