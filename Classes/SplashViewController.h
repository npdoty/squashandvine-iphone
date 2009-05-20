//
//  SplashViewController.h
//  WhatsInSeason
//
//  Created by Aylin Selcukoglu on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashViewController : UIViewController {
	NSTimer *timer;
	UIImageView *splashImageView;
}

@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) UIImageView *splashImageView;

@end
