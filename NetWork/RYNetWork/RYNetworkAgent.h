//
//  RYNetworkAgent.h
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkHandler.h"

@interface RYNetworkAgent : NSObject

@property (nonatomic, copy) AFHTTPSessionManager *manager;

+ (RYNetworkAgent *)sharedAgent;

- (void)addRequest:(RYNetworkHandler *)request;

@end
