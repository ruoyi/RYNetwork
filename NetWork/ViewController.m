//
//  ViewController.m
//  NetWork
//
//  Created by 若懿 on 16/9/8.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "ViewController.h"
#import "RYNetWorkHandler.h"

@interface ViewController ()

@end

@implementation ViewController {
    RYNetWorkHandler *handle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)request:(id)sender {
    handle = [[RYNetWorkHandler alloc]init];

    [handle.hostURL(@"http://192.168.1.109:8000").path(nil).parameters(@{
                                                                              @"r":@"city/view",
                                                                              @"id":@"93",
                                                                              }) handleResponse:^(RYNewWorkResponse *object) {
        if (object.isSuccess) {
            
        }
//        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:object.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSString *string = [[NSString alloc] initWithData:object.responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",string);

//        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:object.responseData];

    }];
    [handle cancelRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
