//
//  AppSettingViewController.h
//  InAppSettingsDemo
//
//  Created by 吕 勇 on 13-1-8.
//  Copyright (c) 2013年 吕 勇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IASKAppSettingsViewController.h"

@interface AppSettingViewController : UIViewController <IASKSettingsDelegate, UITextViewDelegate> {
    IASKAppSettingsViewController *appSettingsViewController;
}

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;


@end
