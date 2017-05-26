//
//  ViewController.m
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "ViewController.h"
#import "RYNetworkHandler.h"

@interface ViewController ()

@end

@implementation ViewController {
    RYNetworkHandler *handle;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str1 = [NSString stringWithFormat:@""];
    NSLog(@"%p",str1);
    if (str1.length>0) {
        NSLog(@"str1.length>0");
    }
    NSString *str2 = @"";
    NSLog(@"%p",str2);

    if (str2.length>0) {
        NSLog(@"str1.length>0");
    }

    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)request:(id)sender {
    handle = [[RYNetworkHandler alloc]init];
    
    [handle.hostURL(@"http://123.56.201.242:1024/plan-new/index").requestMethod(RYNetworkRequestMethodPost).path(nil).parameters(@{
                                                                              @"r":@"city/view",
                                                                              @"id":@"93",
                                                                              }) handleResponse:^(RYNetworkResponse *object) {
        if (object.isSuccess) {
            
        }

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
