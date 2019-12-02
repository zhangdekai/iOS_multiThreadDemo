//
//  SafeReadWriteViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/12/2.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "SafeReadWriteViewController.h"
#import <pthread.h>

@interface SafeReadWriteViewController ()

@property (nonatomic, strong)dispatch_queue_t queue;

@property (nonatomic, assign)pthread_rwlock_t rwLock;


@end

@implementation SafeReadWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self testRWByBarrier];
    
    [self testRWByPthread];
    
    
}
- (void)testRWByPthread {
        
    pthread_rwlock_init(&_rwLock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read1];
        });
        dispatch_async(queue, ^{
            [self write1];
        });
    }
    
    
}

- (void)testRWByBarrier {
    
    self.queue = dispatch_queue_create("safe_rw", DISPATCH_QUEUE_CONCURRENT);

    
    for (int i = 0; i < 10; i++) {
        dispatch_async(self.queue, ^{
            [self read];
            NSLog(@"1");
        });
        
        dispatch_async(self.queue, ^{
            [self read];
            NSLog(@"2");

        });
        
        dispatch_async(self.queue, ^{
            [self read];
            NSLog(@"3");
        });
        
        dispatch_barrier_async(self.queue, ^{
            [self write];
            NSLog(@"4");
        });
    }
}

- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write
{
    sleep(1);
    NSLog(@"write");
}


- (void)read1 {
    
    
    pthread_rwlock_rdlock(&_rwLock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_rwLock);
}

- (void)write1
{
    pthread_rwlock_wrlock(&_rwLock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_rwLock);
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_rwLock);//需要销毁
}


@end
