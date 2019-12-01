//
//  OSSpinLockDemo.m
//  Interview04-线程同步
//
//  Created by MJ Lee on 2018/6/7.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>

@interface OSSpinLockDemo()
@property (assign, nonatomic) os_unfair_lock moneyLock;
@property (assign, nonatomic) os_unfair_lock ticketLock;
@end

@implementation OSSpinLockDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;//OS_SPINLOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;//OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney
{
//    OSSpinLockLock(&_moneyLock);
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
//    OSSpinLockUnlock(&_moneyLock);
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__saveMoney
{
//    OSSpinLockLock(&_moneyLock);
    os_unfair_lock_lock(&_moneyLock);

    
    [super __saveMoney];
    
//    OSSpinLockUnlock(&_moneyLock);
    os_unfair_lock_unlock(&_moneyLock);

}

- (void)__saleTicket
{
//    OSSpinLockLock(&_ticketLock);
    os_unfair_lock_lock(&_ticketLock);

    
    [super __saleTicket];
    
//    OSSpinLockUnlock(&_ticketLock);
    os_unfair_lock_unlock(&_ticketLock);

}

@end
