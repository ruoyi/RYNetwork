//
//  HttpResponse.h
//  Pilgrim
//
//  Created by ruoyi on 16/6/28.
//  Copyright © 2016年 Pilgrim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYNetworkResponse : NSObject

@property (nonatomic, assign, readonly) BOOL isSuccess;

@property (nonatomic, strong) id responseData;

@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, strong) id tagObj;

- (instancetype)initWithSccess:(BOOL )aIsSuccess responseData:(id)aResponseData  error:(NSError *)aError;

@end
