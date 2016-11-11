//
//  HttpResponse.m
//  Pilgrim
//
//  Created by ruoyi on 16/6/28.
//  Copyright © 2016年 Pilgrim. All rights reserved.
//

#import "RYNetworkResponse.h"

@implementation RYNetworkResponse

- (instancetype)initWithSccess:(BOOL )aIsSuccess responseData:(id)aResponseData  error:(NSError *)aError {
    self = [super init];
    if (!self) {
        return nil;
    }
    _isSuccess = aIsSuccess;
    _responseData = aResponseData;
    _error = aError;
    return self;
}

@end
