//
//  HttpResponse.h
//  Pilgrim
//
//  Created by ruoyi on 16/6/28.
//  Copyright © 2016年 Pilgrim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYNetworkResponse : NSObject

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, strong) id responseData;

@property (nonatomic, strong) NSString *errorMsg;

@property (nonatomic, strong) NSNumber *errorCode;

@property (nonatomic, strong) NSError *error;



- (instancetype)initWithSccess:(BOOL )aIsSuccess responseData:(id)aResponseData  error:(NSError *)aError;

@end
