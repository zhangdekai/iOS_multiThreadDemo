//
//  DispatchBarrierViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/12/1.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "DispatchBarrierViewController.h"

@interface DispatchBarrierViewController ()

@end

@implementation DispatchBarrierViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testBarrier];
    [self testDispatchApply];
    [self testSignl];
    
}


- (void)testBarrier {
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"task - A");
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"task - B");
    });
    
    NSLog(@"before barrier");
    
    dispatch_barrier_sync(queue, ^{//同步阻塞，先执行前边的任务，也可以通过别的同步手段处理
        NSLog(@"task - new");
    });
    
    NSLog(@"after barrier");
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"task - C");
    });
    
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"task - D");
    });
    
    /*
     before barrier
     task - B
     task - A
     task - new
     after barrier
     task - D
     task - C
     */
}

- (void)testDispatchApply {
    
    //dispatch_apply:是同步的,可以在主线程走任务,如果想异步可以在外面包一层
    
    NSLog(@"----1");
    NSArray *array = @[@"1",@"2",@"3",@"4"];
    
    dispatch_apply(array.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
           
           NSLog(@"queue 并行 ——Thread：%@",[NSThread currentThread]);

           NSLog(@"元素：%@----第%ld次", array[index],index);
           
       });
    
    NSLog(@"----2");

    
    dispatch_queue_t queue = dispatch_queue_create("com.iosmuti.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_apply(array.count, queue, ^(size_t index) {
        
        NSLog(@"queue 串行——Thread：%@",[NSThread currentThread]);

        
        NSLog(@"元素：%@----第%ld次", array[index],index);

    });
    
    NSLog(@"----3");
    
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_apply(array.count, main, ^(size_t index) {//ps:同步 阻塞主线程
        
        NSLog(@"queue 串行——Thread：%@",[NSThread currentThread]);

        
        NSLog(@"元素：%@----第%ld次", array[index],index);

    });
    
    NSLog(@"----4");

    
    /*
     queue 并行 ——Thread：<NSThread: 0x600000eb72c0>{number = 6, name = (null)}
     2019-12-10 12:11:34.638541+0800 iOS多线程[4170:118583] queue 并行 ——Thread：<NSThread: 0x600000eb8940>{number = 5, name = (null)}
     2019-12-10 12:11:34.638538+0800 iOS多线程[4170:118579] queue 并行 ——Thread：<NSThread: 0x600000eb2300>{number = 3, name = (null)}
     2019-12-10 12:11:34.638565+0800 iOS多线程[4170:118478] queue 并行 ——Thread：<NSThread: 0x600000ef1cc0>{number = 1, name = main}
     2019-12-10 12:11:34.638668+0800 iOS多线程[4170:118579] 元素：4----第3次
     2019-12-10 12:11:34.638668+0800 iOS多线程[4170:118578] 元素：2----第1次
     2019-12-10 12:11:34.638669+0800 iOS多线程[4170:118583] 元素：3----第2次
     2019-12-10 12:11:34.638758+0800 iOS多线程[4170:118478] 元素：1----第0次
     2019-12-10 12:11:34.639054+0800 iOS多线程[4170:118478] queue 串行——Thread：<NSThread: 0x600000ef1cc0>{number = 1, name = main}
     2019-12-10 12:11:34.639259+0800 iOS多线程[4170:118478] 元素：1----第0次
     2019-12-10 12:11:34.639471+0800 iOS多线程[4170:118478] queue 串行——Thread：<NSThread: 0x600000ef1cc0>{number = 1, name = main}
     2019-12-10 12:11:34.639667+0800 iOS多线程[4170:118478] 元素：2----第1次
     2019-12-10 12:11:34.639881+0800 iOS多线程[4170:118478] queue 串行——Thread：<NSThread: 0x600000ef1cc0>{number = 1, name = main}
     2019-12-10 12:11:34.640097+0800 iOS多线程[4170:118478] 元素：3----第2次
     2019-12-10 12:11:34.640322+0800 iOS多线程[4170:118478] queue 串行——Thread：<NSThread: 0x600000ef1cc0>{number = 1, name = main}
     2019-12-10 12:11:34.640526+0800 iOS多线程[4170:118478] 元素：4----第3次
     */

    
}

- (void)testSignl {//可实现类似 dispatch enter的功能。
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(3);
            NSLog(@"完成1");
            dispatch_semaphore_signal(semaphore);
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            NSLog(@"完成2");
            dispatch_semaphore_signal(semaphore);
        });
    });
    
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"全部完成");
    });
    
    // 完成2  完成1 全部完成
    
}

- (void)testSignalDependence {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t semaphore0 = dispatch_semaphore_create(0);
    dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(0);
    
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"完成1");
            dispatch_semaphore_signal(semaphore0);
        });
    });
    
    dispatch_group_async(group, queue, ^{
        
        //等待semaphore0的任务先完成，线程依赖（需要创建多个信号量），略有啰嗦。
        dispatch_semaphore_wait(semaphore0,DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"完成2");
            dispatch_semaphore_signal(semaphore1);
        });
    });
    
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
        NSLog(@"全部完成");
    });
    // 完成1 完成2 全部完成
}

@end
