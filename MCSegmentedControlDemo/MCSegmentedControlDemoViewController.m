//
//  MCSegmentedControlDemoViewController.m
//  MCSegmentedControlDemo
//
//  Created by Matteo Caldari on 13/02/11.
//  Copyright 2011 Matteo Caldari. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "MCSegmentedControlDemoViewController.h"
#import "MCSegmentedControl.h"
#import "UIColor-Expanded.h"
@class MCSegmentedControl;

@implementation MCSegmentedControlDemoViewController

@synthesize testLabel = _testLabel;

- (void)dealloc
{
	self.testLabel = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [segmentedControl setMCSegmentedControlWithTintColor:[UIColor colorWithHexString:@"e0e0e0"]
                                      SelectedSegmentColor:[UIColor colorWithHexString:@"931317"] 
                                    UnselectedSegmentColor:[UIColor colorWithHexString:@"595959"] 
                                         SelectedItemColor:[UIColor colorWithHexString:@"e0e0e0"] 
                                       UnselectedItemColor:[UIColor colorWithHexString:@"181818"]];
    
    segmentedControl.font = [UIFont fontWithName:@"Helvetica" size:20];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segmentedControlDidChange:(MCSegmentedControl *)sender 
{
	_testLabel.text = [NSString stringWithFormat:@"%@ %d", _testLabel.text, [sender selectedSegmentIndex]];
	NSLog(@"%d", [sender selectedSegmentIndex]);
}



@end
