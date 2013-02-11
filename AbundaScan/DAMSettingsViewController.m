//
//  DAMSettingsViewController.m
//  AbundaScan
//
//  Created by David Mayer on 2/9/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import "DAMSettingsViewController.h"
#import "DAMAppDelegate.h"
#import "DAMLoginViewController.h"
#import "DAMViewController.h"

@interface DAMSettingsViewController ()

@end

@implementation DAMSettingsViewController

@synthesize myAutoScanSwitch;
@synthesize shouldAutoScan;

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
    self.title = @"Settings";
    self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"autoscan"]) {
        myAutoScanSwitch.on = YES;
        shouldAutoScan = YES;
    }
    else {
        myAutoScanSwitch.on = NO;
        shouldAutoScan = NO;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyAutoScanSwitch:nil];
    [super viewDidUnload];
}
- (IBAction)toggleMyAutoScanSwitch:(id)sender {
    shouldAutoScan = !shouldAutoScan;
    [[NSUserDefaults standardUserDefaults] setBool:shouldAutoScan forKey:@"autoscan"];
    NSLog(@"Autoscan status = %c", [[NSUserDefaults standardUserDefaults]boolForKey:@"autoscan"]);
}

- (IBAction)clickMyLogoutButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:FALSE forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:NO forKey:@"autoscan"];
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    DAMLoginViewController *loginVC = [[DAMLoginViewController alloc]initWithNibName:@"DAMLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
    appDelegate.navController.navigationBarHidden = YES;
   // [self.navigationController popToRootViewControllerAnimated:NO];
    
}
@end
