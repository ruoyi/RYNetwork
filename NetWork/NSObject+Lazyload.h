//
//  NSObject+Lazyload.h
//  Network
//
//  Created by 若懿 on 16/10/20.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@protocol LazyloadObect <NSObject>

@optional
- (NSArray *)ry_lazyloadObect;

@end



@interface ViewController (Lazyload)<LazyloadObect>

+ (BOOL)ry_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

- (void)ry_layloadKey:(NSString *)propertyStr;

- (void)ry_layloadKeys:(NSSet *)propertyStrs;

@end
