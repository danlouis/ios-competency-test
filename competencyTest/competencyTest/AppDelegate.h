//
//  AppDelegate.h
//  competencyTest
//
//  Created by Dolpin on 10/31/14.
//  Copyright (c) 2014 com.ios.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *selectedID;
+(AppDelegate *)sharedAppDelegate;
@end
