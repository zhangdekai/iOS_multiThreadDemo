//
//  ViewController.m
//  iOS多线程
//
//  Created by zhang dekai on 2019/11/26.
//  Copyright © 2019 zhang dekai. All rights reserved.
//

#import "ViewController.h"
#import "Sync&ASyncViewController.h"
#import "DispatchBarrierViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_dispatch_apply];
    
}

- (void)test_dispatch_apply {
    
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
    
    dispatch_apply(array.count, main, ^(size_t index) {//同步 阻塞主线程
        
        NSLog(@"queue 串行——Thread：%@",[NSThread currentThread]);

        
        NSLog(@"元素：%@----第%ld次", array[index],index);

    });
    
    NSLog(@"----4");

    

}





- (IBAction)jumpToSync:(id)sender {
    
    Sync_ASyncViewController *vc = [[Sync_ASyncViewController alloc]init];
    
    [self presentViewController:vc animated:true completion:nil];
}

- (IBAction)jumpTosignalTest:(id)sender {
    
    DispatchBarrierViewController *vc = [[DispatchBarrierViewController alloc]init];
    
    [self presentViewController:vc animated:true completion:nil];
}


@end
