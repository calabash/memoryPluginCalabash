//
//  SRScreenRecorder.m
//  ScreenRecorder
//
//  Created by kishikawa katsumi on 2012/12/26.
//  Copyright (c) 2012年 kishikawa katsumi. All rights reserved.
//

#import "XAMemoryPluginCalabash.h"


@implementation XAMemoryPluginCalabash {
}
+(void)load {
  [[XAMemoryPluginCalabash sharedInstance] setupNotifications];
}

+ (XAMemoryPluginCalabash *)sharedInstance
{
    static XAMemoryPluginCalabash *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[XAMemoryPluginCalabash alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
  NSLog(@"good");
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
  NSLog(@"Calabash Memory Plugin: %@", notification);

  NSLog(@"<xtc-app-event name=\"MemoryWarning\" ts=\"%@\"/>",[NSDate date]);
}

@end
