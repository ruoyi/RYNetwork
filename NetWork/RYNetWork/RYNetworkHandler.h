//
//  RYNetworkHander.h
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "RYNetworkResponse.h"
#import "AFNetworking.h"

@class RYNetworkHandler;

typedef void (^RYNetworkHandlerBlock)(RYNetworkResponse * _Nullable responseObj);

typedef void (^RYAttachmentBlock)(id<AFMultipartFormData> _Nonnull formData);

typedef void (^RYProgressBlock)(NSProgress *_Nonnull progress);

typedef NS_ENUM (NSUInteger, RYNetworkRequestMethod){
    RYNetworkRequestMethodGet,
    RYNetworkRequestMethodPost,
    RYNetworkRequestMethodDelete,
    RYNetworkRequestMethodPut,
};

//typedef NS_ENUM (NSUInteger, RYNetworkRequestCache){
//    RYNetworkRequestCacheNone,
//    RYNetworkRequestCacheMemoryIfAvailable,
//};
//

@protocol RYNetworkHanderProtocol <NSObject>
// Subclass Override

- (NSStringEncoding)stringEncoding;

- (NSDictionary *_Nullable)extraHeader;

- (NSDictionary *_Nullable)extraParameter;

- (NSString *_Nullable)commonHostStr;

- (NSString *_Nullable)commonPathStr;

- (NSTimeInterval)timeoutInterval;

- (void)requestWillStart;

- (void)requestDidEnd;

- (void)filterOriginalData:(RYNetworkResponse * _Nonnull)originalData;

@end

@protocol RYNetworkHanderReduce <NSObject>

- (void)reduceResponseDataBeforeHandle:(RYNetworkHandler *_Nonnull)handle responseData:(RYNetworkResponse *_Nonnull)responseData;

@end

@protocol RYRequestDelegate <NSObject>

// In order to Reduce response data direct use

///  Inform the accessory that the request is about to start.
///
///  @param request The corresponding request.
- (void)requestShouldStart:(RYNetworkHandler *_Nonnull)request;

///  Inform the accessory that the request has already stoped. This method is called
///  after executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestDidFinish:(RYNetworkHandler *_Nonnull)request;

@end

@interface RYNetworkHandler : NSObject<RYNetworkHanderProtocol>

@property (nonatomic, weak, nullable) id<RYRequestDelegate> delegate;

@property (nonatomic, strong, readonly, nonnull) RYNetworkResponse *responseObj;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(RYNetworkRequestMethod))requestMethod;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(NSString *_Nullable))hostURL;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(NSString *_Nullable))path;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(NSDictionary *_Nullable))parameters;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(RYAttachmentBlock _Nonnull))attachment;

- (RYNetworkHandler *_Nonnull(^_Nonnull)(NSObject<RYNetworkHanderReduce> * _Nullable))reduce;

/*  if requestMethod == RYNetworkRequestMethodGet progress mean download progress
    if requestMethod == RYNetworkRequestMethodPost progress mean upload progress
*/
 - (RYNetworkHandler *_Nonnull(^_Nonnull)(RYProgressBlock _Nonnull))progress;
   
- (void)handleResponse:(RYNetworkHandlerBlock _Nullable)handle;

- (void)cancelRequest;


@end
