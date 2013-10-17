//
//  TweetViewController.h
//  Tweety
//
//  Created by Sittipon Simasanti on 10/9/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController
@property (assign) int index;

@property (nonatomic, strong) NSDictionary *tweetEntry;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *screenNameLabel;

@end
