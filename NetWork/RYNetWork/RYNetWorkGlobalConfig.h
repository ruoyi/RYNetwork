//
//  RYNetWorkGlobalConfig.h
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


static inline NSString *StringValue(id obj) {
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
@interface RYNetWorkGlobalConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (RYNetWorkGlobalConfig *)sharedConfig;


@property (nonatomic, assign) NSTimeInterval timeout;

@property (nonatomic, strong) NSString *hostURL;
// define is 60s
@property (nonatomic, assign) NSUInteger maxRequest;

@property (nonatomic, assign) NSUInteger maxCacheSize;

@property (nonatomic, assign) NSTimeInterval maxCacheTime;

@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

- (void)cancelAllRequests;

@end
