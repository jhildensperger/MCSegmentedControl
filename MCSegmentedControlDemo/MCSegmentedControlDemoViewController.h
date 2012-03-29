//
//  MCSegmentedControlDemoViewController.h
//  MCSegmentedControlDemo
//
//  Created by Matteo Caldari on 13/02/11.
//  Copyright 2011 Matteo Caldari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSegmentedControl.h"

@interface MCSegmentedControlDemoViewController : UIViewController {
	
	UILabel *_testLabel;
    IBOutlet MCSegmentedControl *segmentedControl;
}

@property (nonatomic, retain) IBOutlet UILabel *testLabel;

- (IBAction)segmentedControlDidChange:(MCSegmentedControl *)sender; 

@end
