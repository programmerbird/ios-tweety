//
//  AppDelegate.m
//  Tweety
//
//  Created by Sittipon Simasanti on 10/8/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

+(AppDelegate*)shared
{
    return [[UIApplication sharedApplication] delegate];
}

-(BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter];
}

- (void)fetchHomeTimeline
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        

        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                 NSDictionary *params = @{@"include_rts": @"0",
                                          @"trim_user": @"0",
                                          @"count": @"30"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];

                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSArray *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                  NSLog(@"Timeline Response: %@\n", timelineData);
                                  [self twitterDidGetTimeline: timelineData];
                              }
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

-(void)twitterDidGetTimeline: (NSArray*)timelineData {
    NSLog(@"twitterDidGetTimeline!");
    self.timeline = timelineData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window.rootViewController performSegueWithIdentifier: @"finishLoading" sender:nil];
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // self.storyboard = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    self.accountStore = [[ACAccountStore alloc] init];
    [self fetchHomeTimeline];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
