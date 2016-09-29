//
//  RYNetWorkHander.h
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNewWorkResponse.h"
#import "AFNetworking.h"

@class AFHTTPRequestSerializer,AFHTTPResponseSerializer,RYNetWorkHandler;

typedef void (^RYNetWorkHandlerBlock)(RYNewWorkResponse *responseObj);

typedef void (^RYAttachmentBlock)(id<AFMultipartFormData> formData);

typedef NS_ENUM (NSUInteger, RYNetworkRequestMethod){
    RYNetworkRequestMethodGet,
    RYNetworkRequestMethodPost,
    RYNetworkRequestMethodDelete,
    RYNetworkRequestMethodPut,
};

@protocol RYNetWorkHanderConfigProtocol <NSObject>
// Subclass Override

- (NSDictionary *)extraHeader;

- (NSDictionary *)commonParameter;

- (NSString *)commonHostStr;

- (NSString *)commonPathStr;

- (NSTimeInterval)timeout;

//- (AFHTTPResponseSerializer *)responseSerializer;
//
//- (AFHTTPRequestSerializer *)requestSerializer;

- (void)requestWillStart;

- (void)requestDidEnd;

- (id)filterOriginalData:(id)originalData;

@end

@protocol RYNetWorkHanderReduce <NSObject>

- (id)reduceResponseDataBeforeHandle:(RYNetWorkHandler *)handle responseData:(id)responseData;

@end

@protocol RYRequestDelegate <NSObject>

// In order to Reduce response data direct use

///  Inform the accessory that the request is about to start.
///
///  @param request The corresponding request.
- (void)requestShouldStart:(RYNetWorkHandler *)request;

///  Inform the accessory that the request has already stoped. This method is called
///  after executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestDidFinish:(RYNetWorkHandler *)request;

@end

@interface RYNetWorkHandler : NSObject<RYNetWorkHanderConfigProtocol>

@property (nonatomic, weak) id<RYRequestDelegate> delegate;

@property (nonatomic, strong) RYNewWorkResponse *responseObj;

- (RYNetWorkHandler *(^)(RYNetworkRequestMethod))requestMethod;

- (RYNetWorkHandler *(^)(NSDictionary *))parameters;

- (RYNetWorkHandler *(^)(NSString *))hostURL;

- (RYNetWorkHandler *(^)(NSString *))path;

- (RYNetWorkHandler *(^)(RYAttachmentBlock))attachment;

- (RYNetWorkHandler *(^)(BOOL ))needCache;

- (RYNetWorkHandler *(^)(NSObject<RYNetWorkHanderReduce> *))reduce;

- (void)handleResponse:(RYNetWorkHandlerBlock)handle;

- (void)cancelRequest;

@end
