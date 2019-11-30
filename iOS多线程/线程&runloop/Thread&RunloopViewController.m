//
//  Thread&RunloopViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/11/26.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "Thread&RunloopViewController.h"

@interface Thread_RunloopViewController ()

@end

@implementation Thread_RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)test2
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
        // 这句代码的本质是往Runloop中添加定时器
        [self performSelector:@selector(test) withObject:nil afterDelay:.0];
        NSLog(@"3");
        
        //        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

- (void)test
{
    NSLog(@"2");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}




@end
