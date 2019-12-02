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
    // Do any additional setup after loading the view.
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
