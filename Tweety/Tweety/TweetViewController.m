//
//  TweetViewController.m
//  Tweety
//
//  Created by Sittipon Simasanti on 10/9/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "TweetViewController.h"
#import "AppDelegate.h"

@interface TweetViewController ()

@end

@implementation TweetViewController


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
    if(self.tweetEntry){
        NSDictionary *user = self.tweetEntry[@"user"];
        
        self.screenNameLabel.text = [NSString stringWithFormat: @"@%@", user[@"screen_name"]];
        self.textView.text = self.tweetEntry[@"text"];
        
        [self.textView setTextColor: [self colorFromHexString: user[@"profile_text_color"] alpha: 1.0f]];
        [self.textView setTintColor: [self colorFromHexString: user[@"profile_link_color"] alpha: 1.0f]];
        [self.screenNameLabel setTextColor: [self colorFromHexString: user[@"profile_link_color"] alpha: 1.0f]];
        
        
    }
}


-(void)viewDidAppear:(BOOL)animated {
    if(self.tweetEntry)
    {
        NSDictionary *user = self.tweetEntry[@"user"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.rootController reloadUserPicture: user];
        
        // [[AppDelegate.shared rootController] reloadUserPicture: user];
    }
}

-(UIColor*)colorFromHexString: (NSString*)stringColor alpha: (float)alpha
{
    NSUInteger red, green, blue;
    sscanf([stringColor UTF8String], "%02X%02X%02X", &red, &green, &blue);
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
