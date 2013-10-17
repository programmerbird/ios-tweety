//
//  SettingViewController.m
//  Tweety
//
//  Created by Sittipon Simasanti on 10/9/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController


-(IBAction)returnToSettings:(UIStoryboardSegue *)segue {
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    long section = indexPath.section;
    long row = indexPath.row;
    if(section == 0){
        if(row == 0){
        
            // tell friends
            NSString *shareText = [NSString stringWithFormat: @"Check this out, twitter client with one tweet at a time on iPhone! http://extends.cc/"];
            UIActivityViewController *controller = [[UIActivityViewController alloc]
                                                    initWithActivityItems:@[shareText]
                                                    applicationActivities:nil];
            [controller setExcludedActivityTypes: @[
                                                    UIActivityTypeCopyToPasteboard,
                                                    UIActivityTypePrint,
                                                    UIActivityTypeAssignToContact,
                                                    UIActivityTypeSaveToCameraRoll
                                                    ]];
            
            [controller setCompletionHandler: ^(NSString *activity, BOOL done){
            }];
            [self presentViewController:controller animated:YES completion:NULL];

            
        }else if(row == 1){
            // email support
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", @"support@extends.cc"]]];
            
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
