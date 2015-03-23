//
//  XAMemoryPluginCalabash.h
//  XAMemoryPluginCalabash
//
//  Created by Karl Krukow on 2014/03/11.
//  Copyright (c) 2014 Xamarin Inc. All rights reserved.
//

#import "XAMemoryPluginCalabash.h"

@implementation XAMemoryPluginCalabash

+(void)load {
  NSLog(@"Calabash Memory Plugin: loading...");
  [[XAMemoryPluginCalabash sharedInstance] setupNotifications];
  NSLog(@"Calabash Memory Plugin: registered for low-memory warnings");
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
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotifications
{
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(applicationDidReceiveMemoryWarning:)
   name:UIApplicationDidReceiveMemoryWarningNotification
   object:nil];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
  NSLog(@"Calabash Memory Plugin: %@", notification);

  NSLog(@"<xtc-app-event name=\"MemoryWarning\" ts=\"%@\"/>",[NSDate date]);
}

@end
