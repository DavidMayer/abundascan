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

#pragma mark - TableView Delegate Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
        return 3;
    else
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Auto-Scan Mode";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                [myAutoScanSwitch setFrame:CGRectMake(215, 16, myAutoScanSwitch.frame.size.width, myAutoScanSwitch.frame.size.height)];
                [cell.contentView addSubview: myAutoScanSwitch];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = @"Instructions";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
                
            case 2:
                cell.textLabel.text = @"Sign Out";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
                
            default:
                break;
        }
    }
    else{
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Instructions";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                myAutoScanSwitch.hidden = YES;
                break;
                
            case 1:
                cell.textLabel.text = @"Sign In";
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
                
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        switch (indexPath.row) {
            case 0:
                break;
                
            case 1:
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                //[self tableView:myTableView cellForRowAtIndexPath:indexPath].selected = NO;
                [[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"You can scan any CD, DVD, Video Game, or Book and get a real time offer from AbundaTrade.com.  Simply hold your phone about 4 inches from any barcode and wait a couple seconds for the value to be captured.  If you like the value and want to add it to your list to submit to AbundaTrade.com simply hit the + button and it will populate your list for sale on your account at AbundaTrade.com.  Please contact us at Trade@AbundaTrade.com if you have any further questions."delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                break;
                
            case 2:
                [self clickMyLogoutButton:nil];
                
            default:
                break;
        }
    }
    else{
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        DAMLoginViewController *loginVC = [[DAMLoginViewController alloc] initWithNibName:@"DAMLoginViewController" bundle:nil];
        
        switch (indexPath.row) {
                
            case 0:
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                [[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"You can scan any CD, DVD, Video Game, or Book and get a real time offer from AbundaTrade.com.  Simply hold your phone about 4 inches from any barcode and wait a couple seconds for the value to be captured.  If you like the value and want to add it to your list to submit to AbundaTrade.com simply hit the + button and it will populate your list for sale on your account at AbundaTrade.com.  Please contact us at Trade@AbundaTrade.com if you have any further questions."delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                break;
                
            case 1:

                [appDelegate.navController pushViewController:loginVC animated:NO];
                appDelegate.navController.navigationBarHidden = YES;
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)toggleMyAutoScanSwitch:(id)sender {
    shouldAutoScan = !shouldAutoScan;
    [[NSUserDefaults standardUserDefaults] setBool:shouldAutoScan forKey:@"autoscan"];
    NSLog(@"Autoscan status = %c", [[NSUserDefaults standardUserDefaults]boolForKey:@"autoscan"]);
}

- (IBAction)clickMyLogoutButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:FALSE forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:FALSE forKey:@"autoscan"];
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    DAMLoginViewController *loginVC = [[DAMLoginViewController alloc]initWithNibName:@"DAMLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
    appDelegate.navController.navigationBarHidden = YES;
    // [self.navigationController popToRootViewControllerAnimated:NO];
    
}
@end
