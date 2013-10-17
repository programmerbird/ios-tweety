//
//  RootViewController.h
//  Tweety
//
//  Created by Sittipon Simasanti on 10/8/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) IBOutlet UIImageView *overlayView;
@property (nonatomic, strong) IBOutlet UIImageView *profileForeView;
@property (nonatomic, strong) IBOutlet UIImageView *profileBackView;
@property (nonatomic, strong) IBOutlet UIPageViewController *pageController;

-(IBAction)returnToTweet:(UIStoryboardSegue *)segue;
-(void)reloadUserPicture: (NSDictionary *)user;

@end
