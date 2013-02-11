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
@synthesize myTableView;

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
    myTableView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    myTableView.scrollEnabled = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
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
    [self setMyTableView:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Auto-Scan Mode";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            [myAutoScanSwitch setFrame:CGRectMake(0, 0, myAutoScanSwitch.frame.size.width, myAutoScanSwitch.frame.size.height)];
            [cell.contentView addSubview: myAutoScanSwitch];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        case 1:
            cell.textLabel.text = @"Sign Out";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            break;
        
        case 1:
            [self clickMyLogoutButton:nil];
            
        default:
            break;
    }
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
