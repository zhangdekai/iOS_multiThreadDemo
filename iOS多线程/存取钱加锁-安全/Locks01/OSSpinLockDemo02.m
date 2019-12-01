//
//  OSSpinLockDemo2.m
//  Interview04-线程同步
//
//  Created by MJ Lee on 2018/6/7.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "OSSpinLockDemo02.h"
#import <libkern/OSAtomic.h>

@implementation OSSpinLockDemo02

static OSSpinLock moneyLock_;
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moneyLock_ = 0;
    });
}

- (void)__drawMoney
{
    OSSpinLockLock(&moneyLock_);
    
    [super __drawMoney];
    
    OSSpinLockUnlock(&moneyLock_);
}

- (void)__saveMoney
{
    OSSpinLockLock(&moneyLock_);
    
    [super __saveMoney];
    
    OSSpinLockUnlock(&moneyLock_);
}

- (void)__saleTicket
{
//    static NSString *str = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        str = [NSString stringWithFormat:@"123"];
//    });
    
    static OSSpinLock ticketLock = OS_SPINLOCK_INIT;
    
    OSSpinLockLock(&ticketLock);
    
    [super __saleTicket];
    
    OSSpinLockUnlock(&ticketLock);
}

@end
