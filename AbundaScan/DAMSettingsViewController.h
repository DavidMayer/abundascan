//
//  DAMSettingsViewController.h
//  AbundaScan
//
//  Created by David Mayer on 2/9/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISwitch *myAutoScanSwitch;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property BOOL shouldAutoScan;

- (IBAction)toggleMyAutoScanSwitch:(id)sender;
- (IBAction)clickMyLogoutButton:(id)sender;

@end
