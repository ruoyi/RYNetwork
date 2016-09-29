//
//  RYNetWorkAgent.h
//  NetWork
//
//  Created by 若懿 on 16/9/9.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetWorkHandler.h"

@interface RYNetWorkAgent : NSObject

@property (nonatomic, copy) AFHTTPSessionManager *manager;

+ (RYNetWorkAgent *)sharedAgent;

- (void)addRequest:(RYNetWorkHandler *)request withHandle:(RYNetWorkHandlerBlock)handle;

@end
