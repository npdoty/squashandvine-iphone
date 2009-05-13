//
//  MyCLController.m
//  WhatsInSeason
//
//  Created by Aylin Selcukoglu on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// Class that can receive location updates
// didUpdateToLocation and didFailWithError are the callback methods that will be triggered by location events. 
// For now, they just add output to the console/log.

#import "MyCLController.h"

@implementation MyCLController

@synthesize delegate, locationManager;

//  this method (1) initializes the location manager and 
// (2) tells the location manager to send updates to this class.
- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	
	// prints the latitude and longitude to the console
	printf(" this is our stuff: ");
	printf("%+.6f, %+.6f\n",
		   newLocation.coordinate.latitude,
		   newLocation.coordinate.longitude);
	
	// Disables future updates to save power.
	// Disabling event delivery gives the receiver the option of disabling the appropriate hardware (and thereby saving power) 
	// when no clients need location data. You can always restart the generation of location updates by calling the 
	// startUpdatingLocation method again.
    [manager stopUpdatingLocation];
	
	[delegate newLocationLat:newLocation.coordinate.latitude Lon:newLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
	[delegate newError:[error description]];
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}

@end
