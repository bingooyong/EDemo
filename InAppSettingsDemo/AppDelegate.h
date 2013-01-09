//
//  AppDelegate.h
//  InAppSettingsDemo
//
//  Created by 吕 勇 on 13-1-8.
//  Copyright (c) 2013年 吕 勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IBOutlet UITabBarController *tabBarController;

@end
