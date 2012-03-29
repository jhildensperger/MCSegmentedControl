//
//  MCSegmentedControl.h
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCSegmentedControl : UISegmentedControl {

	NSMutableArray *_items;
	
	UIFont  *_font;
    UIColor *_selectedItemColor;
	UIColor *_unselectedItemColor;
	UIColor *_selectedSegmentColor;
	UIColor *_unselectedSegmentColor;
}

// JH: Font for the segments with title Default is sysyem bold 18points
@property (nonatomic, retain) UIFont  *font;

// JH: Color of the item in the selected segment
@property (nonatomic, retain) UIColor *selectedItemColor;
@property (nonatomic, retain) UIColor *unselectedItemColor;

// JH: Applied to text and images
@property (nonatomic, retain) UIColor *selectedSegmentColor;
@property (nonatomic, retain) UIColor *unselectedSegmentColor;

- (void) setMCSegmentedControlWithTintColor: (UIColor *)tintColor
                         SelectedSegmentColor: (UIColor *)selectedSegmentColor
                       UnselectedSegmentColor: (UIColor *)unselectedSegmentColor
                            SelectedItemColor: (UIColor *)selectedItemColor
                          UnselectedItemColor: (UIColor *)unselectedItemColor;

@end
