//
//  AppDelegate.h
//  Tweety
//
//  Created by Sittipon Simasanti on 10/8/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ACAccountStore *accountStore;

@property (weak, nonatomic) RootViewController *rootController;
@property (strong, nonatomic) NSArray *timeline;

@end
