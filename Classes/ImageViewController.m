//
//  ImageViewController.m
//  SimpleDrillDown
//
//  Created by Nick Doty on 2/12/09.
//  Copyright 2009 UC Berkeley, School of Information. All rights reserved.
//

#import "ImageViewController.h"
#import "SimpleDrillDownAppDelegate.h"

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
		
	NSString *vegetableName = [NSString stringWithString:[detailItem objectForKey:@"name"]];
	
	titleLabel.text = vegetableName;
	
	NSString *lowercaseString = [[[vegetableName stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
	
	UIImage *image = [UIImage imageNamed:[lowercaseString stringByAppendingString:@".jpg"]];
	
	if (image != nil)
	{
		firstImage.image = image;
		[firstImage setClipsToBounds:YES];
		[firstImage setAutoresizingMask:UIViewAutoresizingNone];
	}
	
	NSString *selectionText = [detailItem objectForKey:@"selection"];
	if (selectionText != nil)
	{
		selectionInformation.text = [NSString stringWithString:selectionText];
	}
	else {
		selectionInformation.text = @"";
	}
}

-(IBAction)seasonReceived:(id)sender
{
	int choice = [sender selectedSegmentIndex];
	float latitude = [[UIApplication sharedApplication].delegate latitude];
	float longitude = [[UIApplication sharedApplication].delegate longitude];
	
	NSURL *url = [[NSURL alloc] initWithString:@"http://whatsinseason.appspot.com/vote"];
	
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
	[postBody appendData:[[NSString stringWithFormat:@"&lat=%f", latitude] dataUsingEncoding:NSUTF8StringEncoding]];	
	[postBody appendData:[[NSString stringWithFormat:@"&lon=%f", longitude] dataUsingEncoding:NSUTF8StringEncoding]];	
	
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



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		return YES;
	if (interfaceOrientation == UIInterfaceOrientationPortrait)
		return YES;
	else
		return NO;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		//portraitView = self.view;
		//[portraitView retain];	//hold onto the view because we're going to use it again later, otherwise it'll get released when it's replaced
		
		//UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
		[[UIApplication sharedApplication] setStatusBarHidden:true animated:true];
	}
	else if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
	{
		[[UIApplication sharedApplication] setStatusBarHidden:false animated:true];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (fromInterfaceOrientation == UIInterfaceOrientationPortrait)
	{
		[self.navigationController setNavigationBarHidden:true animated:false];
		NSString *vegetableName = [NSString stringWithString:[detailItem objectForKey:@"name"]];
		NSString *lowercaseString = [[[vegetableName stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
		
		UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lowercaseString stringByAppendingString:@".jpg"]]];
		
		//these properties (autoresizingMask, contentMode and frame) are pure nonsense.  their interactions are completely random.
		[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		view.contentMode = UIViewContentModeCenter|UIViewContentModeScaleAspectFill;//|UIViewContentModeRedraw;
		view.frame = [UIScreen mainScreen].bounds;
		[view setNeedsLayout];
		[view setNeedsDisplay];
		
		landscapeView = view;
		
		self.view = landscapeView;
		[landscapeView release];		
	}
	else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		[self.navigationController setNavigationBarHidden:false animated:true];
		
		NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil];
		self.view = [nibViews objectAtIndex: 1];
		[self viewDidLoad];
	}
}

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
