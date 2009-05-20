//
//  LoadingViewController.h
//  WhatsInSeason
//
//  Created by Aylin Selcukoglu on 5/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController {
	NSTimer *timer;
	UIImageView *loadingImageView;
}

@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) UIImageView *loadingImageView;

@end