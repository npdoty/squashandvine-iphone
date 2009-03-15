//
//  ImageViewController.h
//  SimpleDrillDown
//
//  Created by Nick Doty on 2/12/09.
//  Copyright 2009 UC Berkeley, School of Information. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewController : UIViewController {

	UILabel *titleLabel;
	UITextView *seasonInformation;
	UITextView *selectionInformation;
	UIImageView *firstImage;
	UIImageView *secondImage;
	NSDictionary *detailItem;
	
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *seasonInformation;
@property (nonatomic, retain) IBOutlet UITextView *selectionInformation;
@property (nonatomic, retain) IBOutlet UIImageView *firstImage;
@property (nonatomic, retain) IBOutlet UIImageView *secondImage;

@property (nonatomic, retain) NSDictionary *detailItem;

-(IBAction)seasonReceived:(id)sender;

@end
