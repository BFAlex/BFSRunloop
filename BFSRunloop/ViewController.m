//
//  ViewController.m
//  BFSRunloop
//
//  Created by 刘玲 on 2019/2/14.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import "ViewController.h"
#import "BFSRunloopAssistant.h"

@interface ViewController ()
@property (nonatomic, strong) BFSRunloopAssistant *runloopAssistant;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testInfo];
//    [self createObserve];
//    [self addTimerToRunloopOfSubThread];
    [self addTimerToRunloopOfMainThread];
}


- (void)testInfo {
    NSLog(@"current runloop: %@", [NSRunLoop currentRunLoop]);
}

- (void)createObserve {
    NSLog(@"thread: %@", [NSThread currentThread]);
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"cur thread: %@", [NSThread currentThread]);
        NSLog(@"----------- (%@)%zd", CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()), activity);
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}

- (void)addTimerToRunloopOfSubThread {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [self createObserve];
        
        __block int time = 0;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"current thread info(%d): %@, currentMode:%@", time++, [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
//        __block int time2 = 0;
//        NSTimer *timer2 = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            NSLog(@"current thread info2(%d): %@", time2++, [NSThread currentThread]);
//        }];
//        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
        NSLog(@"I am sub thread(%@): %@", [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
    });
}

- (void)addTimerToRunloopOfMainThread {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    [self createObserve];
    
    __block int time = 0;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"current thread info(%d): %@, currentMode:%@", time++, [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    NSLog(@"I am main thread: %@(%@)", [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
}

@end
