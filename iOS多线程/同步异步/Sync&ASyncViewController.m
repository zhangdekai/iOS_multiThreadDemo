//
//  Sync&ASyncViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/11/26.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "Sync&ASyncViewController.h"

@interface Sync_ASyncViewController ()

@end

@implementation Sync_ASyncViewController

// dispatch_sync和dispatch_async用来控制是否要开启新的线程

/**
 队列的类型，决定了任务的执行方式（并发、串行）
 1.并发队列
 2.串行队列
 3.主队列（也是一个串行队列）
 */

- (void)interview01
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{//立马同步到主线程，死锁
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    
    // dispatch_sync立马在当前线程同步执行任务
}

- (void)interview02
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    
    // dispatch_async不要求立马在当前线程同步执行任务
}

- (void)interview03
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
    
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

- (void)interview04
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue2, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

- (void)interview05
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
     
    
//    [self interview05];
    
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue3 = dispatch_queue_create("queu3", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue4 = dispatch_queue_create("queu4", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue5 = dispatch_queue_create("queu5", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"%p %p %p %p %p", queue1, queue2, queue3, queue4, queue5);
}




@end
