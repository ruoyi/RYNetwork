//
//  NSObject+Lazyload.m
//  Network
//
//  Created by 若懿 on 16/10/20.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "NSObject+Lazyload.h"
#import <objc/runtime.h>

@interface _NSObjectObserver : NSObject

@end

@implementation _NSObjectObserver



@end

@implementation ViewController (Lazyload)

+ (BOOL)ry_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

- (void)ry_layloadKey:(NSString *)propertyStr {
    if ([propertyStr isKindOfClass:[NSString class]]&& propertyStr.length > 0) {
        
    }
}

- (void)ry_layloadKeys:(NSSet *)propertyStrs {
    
}



@end
