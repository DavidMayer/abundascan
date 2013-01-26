//
//  DAMAppDelegate.m
//  BarcodeScanner
//
//  Created by David Mayer on 8/15/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import "DAMAppDelegate.h"
#import "DAMViewController.h"


@implementation DAMAppDelegate

@synthesize spinner;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.spinner = [[loadingSpinner alloc] initWithFrame:CGRectMake((bounds.size.width - 200) / 2, (bounds.size.height - 100) / 2, 200, 100)];
    [_window addSubview:self.spinner];
    
    //DAMViewController *vc = [[DAMViewController alloc] initWithNibName:@"DAMViewController" bundle:nil];
    UIViewController *vc;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            vc = [[DAMViewController alloc] initWithNibName:@"DAMViewController" bundle:nil];
        }
        if(result.height == 568)
        {
            vc = [[DAMViewController alloc] initWithNibName:@"DAMViewController-5" bundle:nil];
        }
    }
    
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
    
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
