//
//  SplashViewController.m
//  WhatsInSeason
//
//  Created by Aylin Selcukoglu on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

@synthesize timer, splashImageView;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// Initialize the view
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	
	splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newSplash.png"]];
	splashImageView.frame = CGRectMake(0, 0, 320, 480);
	[self.view addSubview:splashImageView];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

- (void) fadeScreen
{
	[UIView beginAnimations:nil context:nil];	// begins animation block
	[UIView setAnimationDuration:0.75];		// sets animation duration
	[UIView setAnimationDelegate:self];			// sets delegate for this block
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];	// calls teh finishedFading
	self.view.alpha = 0.0;						// Fades the alpha channel of this view to "0." over the animation
	[UIView commitAnimations];					// commits the animation block. This Block is done.
	
}

- (void) finishedFading
{
	[UIView beginAnimations:nil context:nil];	// begins animation block
	[UIView setAnimationDuration:0.75];			// sets animation duration
	self.view.alpha = 1.0;						// fades the view to 1.0 alpha over 0.75 seconds
	//viewController.view.alpha = 1.0;
	[UIView commitAnimations];
	[splashImageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}


@end
