//
//  MyCLController.h
//  WhatsInSeason
//
//  Created by Aylin Selcukoglu on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// This is for the location stuff, this class:
// (1) labels our class as adhering to CLLocationManagerDelegate protocol, which enables it to receive location event call backs; 
// (2) contains an instance of the CLLocationManager class — this will be used to register itself as a delegate for events and 
// to activate location updates.

#import <Foundation/Foundation.h>


@interface MyCLController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;  

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end