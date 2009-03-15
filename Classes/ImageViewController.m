//
//  ImageViewController.m
//  SimpleDrillDown
//
//  Created by Nick Doty on 2/12/09.
//  Copyright 2009 UC Berkeley, School of Information. All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

@synthesize detailItem;
@synthesize titleLabel;
@synthesize seasonInformation;
@synthesize selectionInformation;
@synthesize firstImage;
@synthesize secondImage;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"squash.jpg"]];
    //[imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	self.view = imageView;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	    [super viewDidLoad];
	
	//fill in all the generic titles and stuff here
	//we will use the detailItem dictionary here
	//NSString *test = [[NSString alloc] initWithString:@"Helloooooo"];
	
	titleLabel.text = [NSString stringWithString:[detailItem objectForKey:@"name"]];
	/*seasonInformation.text = [NSString stringWithString:[detailItem objectForKey:@"seasonInformation"]];
	selectionInformation.text = [NSString stringWithString:[detailItem objectForKey:@"selectionInformation"]];
	firstImage.image = [UIImage imageNamed:[detailItem objectForKey:@"firstImage"]];
	[firstImage setClipsToBounds:YES];
	[firstImage setAutoresizingMask:UIViewAutoresizingNone];
	secondImage.image = [UIImage imageNamed:[detailItem objectForKey:@"secondImage"]];
	[secondImage setClipsToBounds:YES];
	[secondImage setAutoresizingMask:UIViewAutoresizingNone];
	 */
	//[firstImage initWithImage:[UIImage imageNamed:[NSString stringWithString:[detailItem objectForKey:@"firstImage"]]]];
	//[test release];
}

-(IBAction)seasonReceived:(id)sender
{
	int choice = [sender selectedSegmentIndex];
	
	NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8081/vote"];
	
	NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=utf-8"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	
	NSDictionary *item = (NSDictionary*)detailItem;
	int theId = [[item objectForKey:@"id"] intValue];
	
	[postBody appendData:[[NSString stringWithFormat:@"idField=%d", theId] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[request setHTTPBody:postBody];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];  
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		NSLog(@"Response: %@", result);
		
		//here you get the response
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:result delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other"];
		//[alert show];
	}
	
	//send to web service
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[detailItem release];
	[titleLabel release];
	[seasonInformation release];
	[selectionInformation release];
	[firstImage release];
	
    [super dealloc];
}


@end
