//
//  AppSettingViewController.m
//  InAppSettingsDemo
//
//  Created by 吕 勇 on 13-1-8.
//  Copyright (c) 2013年 吕 勇. All rights reserved.
//

#import "AppSettingViewController.h"


#import "IASKSpecifierValuesViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "IASKSettingsStoreUserDefaults.h"


@interface AppSettingViewController ()

@end

@implementation AppSettingViewController

@synthesize appSettingsViewController;

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		appSettingsViewController.delegate = self;
	}
	return appSettingsViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 注册通知处理函数
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSettingValueChanged:)
                                                 name:kIASKAppSettingChanged object:nil];
}


// 函数实现，通过key来区分
- (void)handleSettingValueChanged:(NSNotification *)notify
{
    NSLog(@"key: %@", notify.object);
    NSLog(@"val: %@", [notify.userInfo objectForKey:notify.object]);
    NSString* key = notify.object;
    NSNumber* value = [notify.userInfo objectForKey:notify.object];
    if ([key isEqualToString:@"toggleSwitch"]) {
        
        
        NSString *myValue;
        if([value isEqualToNumber:[NSNumber numberWithInteger:0]]){
            myValue = [[NSString stringWithFormat: @"不接收消息"] autorelease];
        }
        else{
            myValue =[[NSString stringWithFormat:@"接收消息" ] autorelease];
            
        }
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:myValue message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key {
	if ([key isEqualToString:@"systemUpgrade"]) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"系统升级" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}
    else if([key isEqualToString:@"updateAreaCache"]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"区域升级" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
    }
    else {
		NSString *newTitle = [[[NSUserDefaults standardUserDefaults] objectForKey:key] isEqualToString:@"Logout"] ? @"Login" : @"Logout";
		[[NSUserDefaults standardUserDefaults] setObject:newTitle forKey:key];
	}
}


@end
