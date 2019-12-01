//
//  OSSpinLockDemo2.m
//  Interview04-线程同步
//
//  Created by MJ Lee on 2018/6/7.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "OSSpinLockDemo2.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>


@implementation OSSpinLockDemo2

static os_unfair_lock moneyLock_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moneyLock_ = OS_UNFAIR_LOCK_INIT;
    });
}

- (void)__drawMoney
{
//    OSSpinLockLock(&moneyLock_);
    os_unfair_lock_lock(&moneyLock_);
    
    [super __drawMoney];
    
//    OSSpinLockUnlock(&moneyLock_);
    os_unfair_lock_unlock(&moneyLock_);
}

- (void)__saveMoney
{
//    OSSpinLockLock(&moneyLock_);
    os_unfair_lock_lock(&moneyLock_);
    
    [super __saveMoney];
    
//    OSSpinLockUnlock(&moneyLock_);
    os_unfair_lock_unlock(&moneyLock_);
}

- (void)__saleTicket
{
//    static NSString *str = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        str = [NSString stringWithFormat:@"123"];
//    });
    
    static os_unfair_lock ticketLock = OS_UNFAIR_LOCK_INIT;
    
//    OSSpinLockLock(&ticketLock);
    os_unfair_lock_lock(&ticketLock);
    
    [super __saleTicket];
    
//    OSSpinLockUnlock(&ticketLock);
    os_unfair_lock_unlock(&ticketLock);
}

@end
