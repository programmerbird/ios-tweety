//
//  RootViewController.m
//  Tweety
//
//  Created by Sittipon Simasanti on 10/8/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "AppDelegate.h"
#import "TweetViewController.h"
#import "RootViewController.h"
#import <CoreImage/CoreImage.h>

@interface RootViewController ()


@end


@implementation RootViewController



-(IBAction)returnToTweet:(UIStoryboardSegue *)segue {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)reloadUserPicture: (NSDictionary *)user {
    
    NSString *cacheFileName = [NSString stringWithFormat: @"%@.png",  user[@"screen_name"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cachePath = [documentsDirectory stringByAppendingPathComponent: cacheFileName];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath: cachePath]){
        
        UIImage *image = [UIImage imageWithContentsOfFile: cachePath];
        [self fadeUserPicture: image];
        
    }else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *profileImageString = [user[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal." withString:@"."];
            NSURL *profileImageUrl = [NSURL URLWithString: profileImageString];
            NSData *urlData = [NSData dataWithContentsOfURL: profileImageUrl];
            [urlData writeToFile:cachePath atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithContentsOfFile: cachePath];
                [self fadeUserPicture: image];
            });
        });
    }
}

-(void)fadeUserPicture: (UIImage*)image
{
    [self.profileBackView setImage: self.profileForeView.image];
    [self.profileForeView setAlpha: 0.0f];
    [self.profileForeView setImage: image];
    
    [UIView animateWithDuration:0.8f
                     animations:^{
                         [self.profileForeView setAlpha: 1.0f];
                     }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setRootController: self];
    
	// Do any additional setup after loading the view. Configure the page view controller and add it
    // as a child view controller.
    UIPageViewController *pageController = [[UIPageViewController alloc]
                                            initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll
                                            navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal
                                            options: nil];
    
    TweetViewController *firstPage = [self tweetControllerAtIndex: 0];
    NSArray *pages = @[firstPage];
    [pageController setViewControllers: pages
                             direction: UIPageViewControllerNavigationDirectionForward
                              animated: NO
                            completion: nil];
    [self addChildViewController: pageController];
    [self.view addSubview: pageController.view];
    [self.view sendSubviewToBack: pageController.view];
    [self.view sendSubviewToBack: self.overlayView];
    [self.view sendSubviewToBack: self.profileForeView];
    [self.view sendSubviewToBack: self.profileBackView];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around
    // the edges of the pages.
    [pageController.view setFrame: self.view.bounds];
    
    [pageController setDelegate: self];
    [pageController setDataSource: self];
    [pageController didMoveToParentViewController: self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that
    // the gestures are started more easily.
    [self.view setGestureRecognizers: pageController.view.gestureRecognizers];
    self.pageController = pageController;        
}

-(TweetViewController*)tweetControllerAtIndex: (int)index
{
    AppDelegate *appDeleage = [[UIApplication sharedApplication] delegate];
    NSArray *timeline = [appDeleage timeline];
    if(0 <= index && index < [timeline count])
    {
        TweetViewController *tweetController = [self.storyboard instantiateViewControllerWithIdentifier:
                                                @"TweetViewController"];
        [tweetController setTweetEntry: [timeline objectAtIndex: index]];
        [tweetController setIndex: index];
        return tweetController;
    }
    return nil;
}


-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    TweetViewController *tweetController = (TweetViewController*)viewController;
    return [self tweetControllerAtIndex: tweetController.index + 1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    TweetViewController *tweetController = (TweetViewController*)viewController;
    return [self tweetControllerAtIndex: tweetController.index - 1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
