//
//  DAMViewController.m
//  BarcodeScanner
//
//  Created by David Mayer on 8/15/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import "DAMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "loadingSpinner.h"
#import "DAMAppDelegate.h"

@interface DAMViewController ()

@end


@implementation DAMViewController
@synthesize myResultImageView;
@synthesize myResultTextView;
@synthesize apiConnection;
@synthesize apiData;
@synthesize myResultUPCLabel;
@synthesize myResultTitleLabel;
@synthesize myResultPriceLabel;
@synthesize myScanButton;
@synthesize originalImageViewFrame;
@synthesize noImageLabel;
@synthesize myNavigationBar;
@synthesize myNavigationTitle;
@synthesize roundedRectView;
@synthesize infoView;
@synthesize iphone4View;
@synthesize iphone5View;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            //iphone4View.hidden = NO;
            //iphone5View.hidden = YES;
            roundedRectView = [[UIView alloc]initWithFrame:CGRectMake(14, 52, 292, 244)];
            iphone4View.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [iphone4View addSubview:roundedRectView];
            [iphone4View sendSubviewToBack:roundedRectView];
        }
        if(result.height == 568)
        {
            // iPhone 5
            //iphone4View.hidden = YES;
            //iphone5View.hidden = NO;
            roundedRectView = [[UIView alloc]initWithFrame:CGRectMake(14, 62, 292, 244)];
            self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [self.view addSubview:roundedRectView];
            [self.view sendSubviewToBack:roundedRectView];
        }
    }
    
    originalImageViewFrame = myResultImageView.frame;
    myNavigationBar.tintColor = UIColorFromRGB(0x005796);
    noImageLabel.hidden = YES;
    myScanButton.titleLabel.textColor = [UIColor darkGrayColor];
    roundedRectView.layer.backgroundColor = [UIColor whiteColor].CGColor;//UIColorFromRGB(0x005796).CGColor;
    roundedRectView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    roundedRectView.layer.borderWidth = 2;
    roundedRectView.layer.cornerRadius = 10;
    
}

- (void)viewDidUnload
{
    [self setMyResultImageView:nil];
    [self setMyResultTextView:nil];
    [self setMyResultTitleLabel:nil];
    [self setMyResultUPCLabel:nil];
    [self setMyResultPriceLabel:nil];
    [self setMyScanButton:nil];
    [self setMyScanButton:nil];
    [self setNoImageLabel:nil];
    [self setMyNavigationBar:nil];
    [self setMyNavigationTitle:nil];
    [self setInfoView:nil];
    [self setIphone5View:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)clickMyScanButton:(id)sender {
    noImageLabel.hidden = YES;
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    roundedRectView.layer.backgroundColor = UIColorFromRGB(0x005796).CGColor;
    infoView.hidden = YES;
    
    // [reader release];
    
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    //  myResultImageView.image =[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    // EXAMPLE: do something useful with the barcode data
    myResultTextView.text = symbol.data;
    [self getProductFromServerWithNumber:symbol.data];
    
}

-(void)getProductFromServerWithNumber: (NSString *)productNumber{
    
    
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    NSNumber *myNumericChecker = [format numberFromString:productNumber];
    if (myNumericChecker == nil) {
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please scan a valid UPC code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else{
        NSString *urlString = [@"http://abundatrade.com/trade/process/request.php?product_code=" stringByAppendingString:productNumber];
        
        myResultUPCLabel.text = productNumber;
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner startWithMessage:@"loading information..."];
        
        if (self.apiConnection)
        {
            [self.apiConnection cancel];
        }
        
        self.apiData = [NSMutableData dataWithCapacity:1000];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        self.apiConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    }
}


#pragma mark -NSURL Connections

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.apiConnection == connection)
    {
        [self.apiData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We encountered a loading error. Please make sure you have service, then try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        
        if ([apiData length])
        {
            NSString *stringDataFromServer = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
            NSLog(@"data from server: %@", stringDataFromServer);
            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:apiData options:NSJSONReadingMutableLeaves error:nil];
            myResultTitleLabel.text = [myDict objectForKey:@"title"];
            myResultPriceLabel.text = [@"$ " stringByAppendingString:(NSString *) [myDict objectForKey:@"price"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[myDict objectForKey:@"imagel"]]];
            UIImage *myImage = [UIImage imageWithData:imageData];
            
            [self sizeImageView:myResultImageView AndPlaceImage:myImage];
            
            
        }
    }
}

-(void)sizeImageView:(UIImageView *)view AndPlaceImage: (UIImage *)image{
    
    myResultImageView.frame = originalImageViewFrame;
    
    NSLog(@"Original Frame height: %f", myResultImageView.frame.size.height);
    NSLog(@"Original Frame width: %f", myResultImageView.frame.size.width);
    
    if (!image) {
        //display default no image text
        noImageLabel.hidden = NO;
        
    }
    else{
        
        if (image.size.height >= image.size.width) {
            double ratio = view.frame.size.height / image.size.height;
            double newHeight = view.frame.size.height;
            double newWidth = image.size.width * ratio;
            view.frame = CGRectMake( view.frame.origin.x + ( myResultImageView.frame.size.width - newWidth )/2, view.frame.origin.y, newWidth, newHeight);
        }
        else{
            double ratio = view.frame.size.width / image.size.width;
            double newWidth = view.frame.size.width;
            double newHeight = image.size.height * ratio;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + (myResultImageView.frame.size.height - newHeight )/2, newWidth, newHeight);
        }
    }
    
    NSLog(@"image frame height: %f", image.size.height);
    NSLog(@"image frame width: %f", image.size.width);
    NSLog(@"Final Frame height: %f", view.frame.size.height);
    NSLog(@"Final Frame width: %f", view.frame.size.width);
    
    myResultImageView.image = image;
    
}
@end
