//
//  DAMSettingsViewController.h
//  AbundaScan
//
//  Created by David Mayer on 2/9/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *myAutoScanSwitch;
- (IBAction)toggleMyAutoScanSwitch:(id)sender;
- (IBAction)clickMyLogoutButton:(id)sender;

@end
