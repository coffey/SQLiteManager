//
//  AppDelegate.m
//  SQLiteManager
//
//  Created by wuyj on 14-10-20.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "ResultListView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setFrame:CGRectMake(0, 0, 800, 600) display:YES];
    
    ResultListView *listView = [[ResultListView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [self.window.contentView addSubview:listView];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
