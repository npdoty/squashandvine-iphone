/*

File: SimpleDrillDownAppDelegate.m
Abstract: Application delegate that sets up the navigation controller and the
root view controller.

Version: 2.6

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "SimpleDrillDownAppDelegate.h"
#import "RootViewController.h"
#import "DataController.h"
#import "SplashViewController.h"
#import "LoadingViewController.h"

@implementation SimpleDrillDownAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize rootViewController;
@synthesize dataController;
@synthesize locationController;
@synthesize viewController;
@synthesize loadingViewController;

@synthesize latitude;
@synthesize longitude;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    // Start grabbing the location, which we need before we decide on data
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
	
	//loading screen stuff
	loadingViewController = [[LoadingViewController alloc] init];
	//Override point for customization after app launch
	[window addSubview:[loadingViewController view]];
		
	//splash screen stuff
	viewController = [[SplashViewController alloc] init];
	//Override point for customization after app launch
	[window addSubview:[viewController view]];
	
	[window makeKeyAndVisible];
}

- (void)dealloc {
    [navigationController release];
	[rootViewController release];
	[viewController release];
	[loadingViewController release];
    [window release];
    [dataController release];
    [super dealloc];
}

// This protocol is used to send the text for location updates back to the app delegate
//@protocol MyCLControllerDelegate <NSObject>
-(void)newLocationLat:(double)lat Lon:(double)lon
{
	printf("App Delegate Received Location: %f, %f", lat, lon);
	latitude = lat;
	longitude = lon;
	
	// Create the data controller
    DataController *controller = [[DataController alloc] initForLat:lat Lon:lon];
    self.dataController = controller;
    [controller release];
    
	rootViewController.dataController = dataController;	
	
	// Configure the window with its navigationController and then show it
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];	
}
-(void)newError:(NSString *)text
{
	//uh oh.
	NSLog(@"Error: %@", text);
}

@end
