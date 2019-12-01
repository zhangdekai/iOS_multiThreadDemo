//
//  SafeQuestionLockViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/11/30.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "SafeQuestionLockViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import "MJBaseDemo.h"
#import "OSSpinLockDemo2.h"


@interface SafeQuestionLockViewController ()

@property (assign, nonatomic) int money;
@property (assign, nonatomic) int ticketsCount;

//@property (assign, nonatomic) OSSpinLock lock;
//@property (assign, nonatomic) OSSpinLock lock1;//10.0废弃

@property (assign, nonatomic)os_unfair_lock lock;
@property (assign, nonatomic)os_unfair_lock lock1;

@property (strong, nonatomic) MJBaseDemo *demo;


@end

@implementation SafeQuestionLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化锁
    
    //    self.lock = OS_SPINLOCK_INIT;
    //    self.lock1 = OS_SPINLOCK_INIT;
    
    self.lock = OS_UNFAIR_LOCK_INIT;
    self.lock1 = OS_UNFAIR_LOCK_INIT;
    
    
    [self ticketTest];
    [self moneyTest];
    

    [self testMJLOCK];
}

/**
 存钱、取钱演示
 */
- (void)moneyTest
{
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self drawMoney];
        }
    });
}

/**
 存钱
 */
- (void)saveMoney
{
    // 加锁
    //        OSSpinLockLock(&_lock1);
    os_unfair_lock_lock(&_lock1);
    
    
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    
    // 解锁
    os_unfair_lock_unlock(&_lock1);
    
    //        OSSpinLockUnlock(&_lock1);
}

/**
 取钱
 */
- (void)drawMoney
{
    // 加锁
    //        OSSpinLockLock(&_lock1);
    os_unfair_lock_lock(&_lock1);
    
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    // 解锁
    //        OSSpinLockUnlock(&_lock1);
    os_unfair_lock_unlock(&_lock1);
}

/*
 thread1：优先级比较高
 
 thread2：优先级比较低
 
 thread3
 
 线程的调度，10ms
 
 时间片轮转调度算法（进程、线程）
 线程优先级
 */

/**
 卖1张票
 */
- (void)saleTicket
{
    //    if (OSSpinLockTry(&_lock)) {
    //        int oldTicketsCount = self.ticketsCount;
    //        sleep(.2);
    //        oldTicketsCount--;
    //        self.ticketsCount = oldTicketsCount;
    //        NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
    //
    //        OSSpinLockUnlock(&_lock);
    //    }
    
    // 加锁
    //    OSSpinLockLock(&_lock);
    
    os_unfair_lock_lock(&_lock);
    
    int oldTicketsCount = self.ticketsCount;
    sleep(.2);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
    
    // 解锁
    //    OSSpinLockUnlock(&_lock);
    os_unfair_lock_unlock(&_lock);
    
}

/**
 卖票演示
 */
- (void)ticketTest
{
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
}

//存取钱、买票 优化。
- (void)testMJLOCK {
    
    MJBaseDemo *demo = [[OSSpinLockDemo2 alloc] init];
    [demo ticketTest];
    [demo moneyTest];
    
    for (int i = 0; i < 10; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (int)test
{
    int a = 10;
    int b = 20;
    
    NSLog(@"%p", self.demo);
    
    int c = a + b;
    return c;
}


@end
