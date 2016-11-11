//
//  ViewController.h
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <__clang_cuda_runtime_wrapper.h>
@class ViewController;

#define RYC(name) name
#define RYChainProperty(class,type)  - (class _Nonnull(^_Nonnull)(type))
#define RYVieControllwChainFunction(type) RYChainProperty(ViewController*,type)

#define RYChainFunctionType()

#define RYChainFunction(class,type) RYChainProperty(class,type) \
{\
    return ^(NSString *value){\
        return self;\
    }\
}


//#define RYChainFunction(type,name) -([self class] *_Nonnull(^_Nonnull))((type))(name)

@interface ViewController : UIViewController




@end

