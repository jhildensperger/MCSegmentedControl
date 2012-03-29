//
//  MCSegmentedControl.m
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//

#import "MCSegmentedControl.h"

#define kCornerRadius  7.0f

@interface MCSegmentedControl ()
@property (nonatomic, retain, readwrite) NSMutableArray *items;
- (BOOL)_mustCustomize;
@end


@implementation MCSegmentedControl

#pragma mark - Object life cycle

- (void)awakeFromNib
{
	NSMutableArray *ar = [NSMutableArray arrayWithCapacity:self.numberOfSegments];

	for (int i = 0; i < self.numberOfSegments; i++) {
		NSString *aTitle = [self titleForSegmentAtIndex:i];
		if (aTitle) {
			[ar addObject:aTitle];
		} else {
			UIImage *anImage = [self imageForSegmentAtIndex:i];
			if (anImage) {
				[ar addObject:anImage];
			}
		}
	}
	
	self.items = ar;
	[self setNeedsDisplay];
}

- (id)initWithItems:(NSArray *)array
{
	self = [super initWithItems:array];
	if (self) {
		if (array) {
			NSMutableArray *mutableArray = [array mutableCopy];
			self.items = mutableArray;
			[mutableArray release];
		} else {
			self.items = [NSMutableArray array];
		}
	}
	
	return self;
}

- (void)dealloc
{
	self.items                  = nil;
	self.font                   = nil;
	self.selectedItemColor      = nil;
	self.unselectedItemColor    = nil;
    self.selectedSegmentColor   = nil;
	self.unselectedSegmentColor = nil;
	
    [super dealloc];
}

- (BOOL)_mustCustomize
{
	return self.segmentedControlStyle == UISegmentedControlStyleBordered
		|| self.segmentedControlStyle == UISegmentedControlStylePlain;
}

#pragma mark - Custom accessors

- (UIFont *)font
{
	if (_font == nil) {
		self.font = [UIFont boldSystemFontOfSize:18.0f];
	}
	return _font;
}

- (void)setFont:(UIFont *)aFont
{
	if (_font != aFont) {
		[_font release];
		_font = [aFont retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)selectedItemColor
{
	if (_selectedItemColor == nil) {
		self.selectedItemColor = [UIColor whiteColor];
	}
	return _selectedItemColor;
}

- (void)setSelectedItemColor:(UIColor *)aColor
{
	if (aColor != _selectedItemColor) {
		[_selectedItemColor release];
		_selectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)unselectedItemColor
{
	if (_unselectedItemColor == nil) {
		self.unselectedItemColor = [UIColor grayColor];
	}
	return _unselectedItemColor;
}

- (void)setUnselectedItemColor:(UIColor *)aColor
{
	if (aColor != _unselectedItemColor) {
		[_unselectedItemColor release];
		_unselectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)selectedSegmentColor
{
	if (_selectedSegmentColor == nil) {
		self.selectedSegmentColor = [UIColor whiteColor];
	}
	return _selectedSegmentColor;
}

- (void)setSelectedSegmentColor:(UIColor *)aColor
{
	if (aColor != _selectedSegmentColor) {
		[_selectedSegmentColor release];
		_selectedSegmentColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)unselectedSegmentColor
{
	if (_unselectedSegmentColor == nil) {
		self.unselectedSegmentColor = [UIColor grayColor];
	}
	return _unselectedSegmentColor;
}

- (void)setUnselectedSegmentColor:(UIColor *)aColor
{
	if (aColor != _unselectedSegmentColor) {
		[_unselectedSegmentColor release];
		_unselectedSegmentColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (NSMutableArray *)items
{
	return _items;
}

- (void)setItems:(NSMutableArray *)array
{
	if (_items != array) {
		[_items release];
		_items = [array retain];
	}
}

#pragma mark - Overridden UISegmentedControl methods

- (void)layoutSubviews
{
	for (UIView *subView in self.subviews) {
		[subView removeFromSuperview];
	}
}

- (NSUInteger)numberOfSegments
{
	if (!self.items || ![self _mustCustomize]) {
		return [super numberOfSegments];
	} else {
		return self.items.count;
	}
}

- (void)drawRect:(CGRect)rect
{
	
	// Only the bordered and plain style are customized
	if (![self _mustCustomize]) {
		[super drawRect:rect];
		return;
	}
    
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(c); 
	
	
	// Rect with radius, will be used to clip the entire view
	CGFloat minx = CGRectGetMinX(rect) + 1, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) + 1, midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
	
	
	// Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
	CGContextMoveToPoint(c, minx - .5, midy - .5);
	CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
	CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
	CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
	CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
	CGContextClosePath(c);
	
	CGContextClip(c);
	
	
	// Background gradient for non selected items
	CGFloat components[8] = { 
		 255/255.0, 255/255.0, 255/255.0, 1.0, 
		 200/255.0, 200/255.0, 200/255.0, 1.0
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
	CGContextDrawLinearGradient(c, gradient, CGPointZero, CGPointMake(0, rect.size.height), kCGGradientDrawsBeforeStartLocation);
	CFRelease(gradient);
	
	for (int i = 0; i < self.numberOfSegments; i++) 
    {
		id item = [self.items objectAtIndex:i];
        CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), rect.size.height);
		
		CGRect itemBgRect = CGRectMake(i * itemSize.width, 
									   0.0f,
									   itemSize.width,
									   rect.size.height);
		
        // Background gradient is composed of two gradients, one on the top, another rounded on the bottom
        CGContextSaveGState(c);
        CGContextClipToRect(c, itemBgRect);
        
        // JH: factor < 0 = lighter color on bottom and vice versa
        float factor  = .8f; // multiplier applied to the first color of the gradient to obtain the second
        float mfactor = .82f; // multiplier applied to the color of the first gradient to obtain the bottom gradient
        
        
        int red = 55, green = 111, blue = 214; // default blue color
        
        if(self.selectedSegmentIndex == i)
        {
            if (self.selectedSegmentColor != nil) {
                const CGFloat *components = CGColorGetComponents(self.selectedSegmentColor.CGColor);
                size_t numberOfComponents = CGColorGetNumberOfComponents(self.selectedSegmentColor.CGColor);
                
                if (numberOfComponents == 2) {
                    red = green = blue = components[0] * 255;
                } else if (numberOfComponents == 4) {
                    red   = components[0] * 255;
                    green = components[1] * 255;
                    blue  = components[2] * 255;
                }
            }
        }   
        else
        {
            if (self.unselectedSegmentColor != nil) {
                const CGFloat *components = CGColorGetComponents(self.unselectedSegmentColor.CGColor);
                size_t numberOfComponents = CGColorGetNumberOfComponents(self.unselectedSegmentColor.CGColor);
                
                if (numberOfComponents == 2) {
                    red = green = blue = components[0] * 255;
                } else if (numberOfComponents == 4) {
                    red   = components[0] * 255;
                    green = components[1] * 255;
                    blue  = components[2] * 255;
                }
            }
        }
        
        // Top gradient
        CGFloat top_components[16] = { 
            red / 255.0f,         green / 255.0f,         blue/255.0f          , 1.0f,
            (red*mfactor)/255.0f, (green*mfactor)/255.0f, (blue*mfactor)/255.0f, 1.0f
        };
        
        CGFloat top_locations[2] = {
            0.0f, .75f
        };
        
        CGGradientRef top_gradient = CGGradientCreateWithColorComponents(colorSpace, top_components, top_locations, 2);
        CGContextDrawLinearGradient(c, 
                                    top_gradient, 
                                    itemBgRect.origin, 
                                    CGPointMake(itemBgRect.origin.x, 
                                                itemBgRect.size.height), 
                                    kCGGradientDrawsBeforeStartLocation);
        CFRelease(top_gradient);
        CGContextRestoreGState(c);
        
        
        // Bottom gradient
        // It's clipped in a rect with the left corners rounded if segment is the first,
        // right corners rounded if segment is the last, no rounded corners for the segments inbetween
		
        CGRect bottomGradientRect = CGRectMake(itemBgRect.origin.x, 
                                               itemBgRect.origin.y + round(itemBgRect.size.height / 2), 
                                               itemBgRect.size.width, 
                                               round(itemBgRect.size.height / 2));
        
        CGFloat gradient_minx = CGRectGetMinX(bottomGradientRect) + 1;
        CGFloat gradient_midx = CGRectGetMidX(bottomGradientRect);
        CGFloat gradient_maxx = CGRectGetMaxX(bottomGradientRect);
        CGFloat gradient_miny = CGRectGetMinY(bottomGradientRect) + 1;
        CGFloat gradient_maxy = CGRectGetMaxY(bottomGradientRect);
        
        CGContextSaveGState(c);
        
        CGContextMoveToPoint(c, gradient_minx - .5f, gradient_miny - .5f);
        CGContextAddArcToPoint(c, gradient_minx - .5f, gradient_miny - .5f, gradient_midx - .5f, gradient_miny - .5f, kCornerRadius);
        
        CGContextAddLineToPoint(c, gradient_maxx, gradient_miny);
        CGContextAddLineToPoint(c, gradient_maxx, gradient_maxy);

        CGContextAddLineToPoint(c, gradient_minx, gradient_maxy);

        CGContextClosePath(c);
        
        CGContextClip(c);
        CGFloat bottom_components[16] = {
            (red*factor)        /255.0f, (green*factor)        /255.0f, (blue*factor)/255.0f,         1.0f,
            (red*factor*mfactor)/255.0f, (green*factor*mfactor)/255.0f, (blue*factor*mfactor)/255.0f, 1.0f
        };
        
        CGFloat bottom_locations[2] = {
            0.0f, 1.0f
        };
        
        CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(colorSpace, bottom_components, bottom_locations, 2);
        CGContextDrawLinearGradient(c, 
                                    bottom_gradient, 
                                    bottomGradientRect.origin, 
                                    CGPointMake(bottomGradientRect.origin.x, 
                                                bottomGradientRect.origin.y + bottomGradientRect.size.height), 
                                    kCGGradientDrawsBeforeStartLocation);
        CFRelease(bottom_gradient);
        CGContextRestoreGState(c);
        
        // JH: This is setting the shadow inside of the selected segment
        if(self.selectedSegmentIndex == i)
        {
            // Inner shadow
            int blendMode = kCGBlendModeDarken;
            
            // Right and left inner shadow 
            CGContextSaveGState(c);
            CGContextSetBlendMode(c, blendMode);
            CGContextClipToRect(c, itemBgRect);
            
            CGFloat inner_shadow_components[16] = {
                0.0f, 0.0f, 0.0f, .25f,
                0.0f, 0.0f, 0.0f, 0.0f,
                0.0f, 0.0f, 0.0f, 0.0f,
                0.0f, 0.0f, 0.0f, .25f
            };
            
            
            CGFloat locations[4] = {
                0.0f, .1f, .9f, 1.0f
            };
            CGGradientRef inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, inner_shadow_components, locations, 4);
            CGContextDrawLinearGradient(c, 
                                        inner_shadow_gradient, 
                                        itemBgRect.origin, 
                                        CGPointMake(itemBgRect.origin.x + itemBgRect.size.width, 
                                                    itemBgRect.origin.y), 
                                        kCGGradientDrawsAfterEndLocation);
            CFRelease(inner_shadow_gradient);
            CGContextRestoreGState(c);
            
            
            
            // Top inner shadow 
            CGContextSaveGState(c);
            CGContextSetBlendMode(c, blendMode);
            CGContextClipToRect(c, itemBgRect);
            CGFloat top_inner_shadow_components[8] = { 
                0.0f, 0.0f, 0.0f, 0.25f,
                0.0f, 0.0f, 0.0f, 0.0f
            };
            CGFloat top_inner_shadow_locations[2] = {
                0.0f, .10f
            };
            CGGradientRef top_inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, top_inner_shadow_components, top_inner_shadow_locations, 2);
            CGContextDrawLinearGradient(c, 
                                        top_inner_shadow_gradient, 
                                        itemBgRect.origin, 
                                        CGPointMake(itemBgRect.origin.x, 
                                                    itemBgRect.size.height), 
                                        kCGGradientDrawsAfterEndLocation);
            CFRelease(top_inner_shadow_gradient);
            CGContextRestoreGState(c);
        }
        
        		if ([item isKindOfClass:[UIImage class]]) {
			CGImageRef imageRef = [(UIImage *)item CGImage];
			CGFloat imageScale  = [(UIImage *)item scale];
			CGFloat imageWidth  = CGImageGetWidth(imageRef)  / imageScale;
			CGFloat imageHeight = CGImageGetHeight(imageRef) / imageScale;
			
			CGRect imageRect = CGRectMake(round(i * itemSize.width + (itemSize.width - imageWidth) / 2), 
										  round((itemSize.height - imageHeight) / 2),
										  imageWidth,
										  imageHeight);
			
			if (i == self.selectedSegmentIndex) {
				
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, rect.size.height);
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextClipToMask(c, imageRect, imageRef);
				CGContextSetFillColorWithColor(c, [self.selectedItemColor CGColor]);
				
				CGContextFillRect(c, imageRect);
				CGContextRestoreGState(c);
			} 
			else {
				
				// 1px shadow
				//CGContextSaveGState(c);
				//CGContextTranslateCTM(c, 0, itemBgRect.size.height);  
				//CGContextScaleCTM(c, 1.0, -1.0);  
				
				//CGContextClipToMask(c, CGRectOffset(imageRect, 0, -1), imageRef);
				//CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
				//CGContextFillRect(c, CGRectOffset(imageRect, 0, -1));
				//CGContextRestoreGState(c);
				
				// Image drawn as a mask
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, itemBgRect.size.height);  
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextClipToMask(c, imageRect, imageRef);
				CGContextSetFillColorWithColor(c, [self.unselectedItemColor CGColor]);
				CGContextFillRect(c, imageRect);
				CGContextRestoreGState(c);
			}
			
		}
		else if ([item isKindOfClass:[NSString class]]) {
			
			NSString *string = (NSString *)[_items objectAtIndex:i];
			CGSize stringSize = [string sizeWithFont:self.font];
			CGRect stringRect = CGRectMake(i * itemSize.width + (itemSize.width - stringSize.width) / 2, 
										   (itemSize.height - stringSize.height) / 2,
										   stringSize.width,
										   stringSize.height);
			
			if (self.selectedSegmentIndex == i) 
            {
				[self.selectedItemColor setFill];	
				[self.selectedItemColor setStroke];	
				[string drawInRect:stringRect withFont:self.font];
			}
            
            else 
            {
                [self.unselectedItemColor setFill];
				[string drawInRect:stringRect withFont:self.font];
			}
		}
		
		// JH: Draw the Separator for each tab
		if (i > 0){
			CGContextSaveGState(c);
			
			CGContextMoveToPoint(c, itemBgRect.origin.x + .5, itemBgRect.origin.y);
			CGContextAddLineToPoint(c, itemBgRect.origin.x + .5, itemBgRect.size.height);
			
			CGContextSetLineWidth(c, 1.0f);
			CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
			CGContextStrokePath(c);
			
			CGContextRestoreGState(c);
		}
		
	}
	
	CGContextRestoreGState(c);
	
	if (self.segmentedControlStyle ==  UISegmentedControlStyleBordered) {
		CGContextMoveToPoint(c, minx - .5, midy - .5);
		CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetStrokeColorWithColor(c,[UIColor blackColor].CGColor);
		CGContextSetLineWidth(c, 1.0f);
		CGContextStrokePath(c);
	} else {
		CGContextSaveGState(c);
		
		CGRect bottomHalfRect = CGRectMake(0, 
										   rect.size.height - kCornerRadius + 7,
										   rect.size.width,
										   kCornerRadius);
		CGContextClearRect(c, CGRectMake(0, 
										 rect.size.height - 1,
										 rect.size.width,
										 1));
		CGContextClipToRect(c, bottomHalfRect);
		
		CGContextMoveToPoint(c, minx + .5, midy - .5);
		CGContextAddArcToPoint(c, minx + .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx + .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetBlendMode(c, kCGBlendModeLighten);
		CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:255/255.0 alpha:1.0].CGColor);
		CGContextSetLineWidth(c, .5f);
		CGContextStrokePath(c);
		
		CGContextRestoreGState(c);
		midy--, maxy--;
		CGContextMoveToPoint(c, minx - .5, midy - .5);
		CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetBlendMode(c, kCGBlendModeMultiply);
		CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:30/255.0 alpha:.9].CGColor);
		CGContextSetLineWidth(c, .5f);
		CGContextStrokePath(c);
	}

	
	CFRelease(colorSpace);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (![self _mustCustomize]) {
		[super touchesBegan:touches withEvent:event];
	} else {
		CGPoint point = [[touches anyObject] locationInView:self];
		int itemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
		self.selectedSegmentIndex = itemIndex;
		
		[self setNeedsDisplay];
	}
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
	if (selectedSegmentIndex == self.selectedSegmentIndex) return;
	
	[super setSelectedSegmentIndex:selectedSegmentIndex];
	
#ifdef __IPHONE_5_0
	if ([self respondsToSelector:@selector(apportionsSegmentWidthsByContent)]
		&& [self _mustCustomize]) 
	{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
#endif
}

- (void)setSegmentedControlStyle:(UISegmentedControlStyle)aStyle
{
	[super setSegmentedControlStyle:aStyle];
	if ([self _mustCustomize]) {
		[self setNeedsDisplay];
	}
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
	if (![self _mustCustomize]) {
		[super setTitle:title forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:title];
		[self setNeedsDisplay];
	}
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
	if (![self _mustCustomize]) {
		[super setImage:image forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:image];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (![self _mustCustomize]) {
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments && segment != 0) return;
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
		[self.items insertObject:title atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (![self _mustCustomize]) {
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments) return;
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
		[self.items insertObject:image atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (![self _mustCustomize]) {
		[super removeSegmentAtIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments) return;
		[self.items removeObjectAtIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void) setMCSegmentedControlWithTintColor: (UIColor *)tintColor
                         SelectedSegmentColor: (UIColor *)selectedSegmentColor
                       UnselectedSegmentColor: (UIColor *)unselectedSegmentColor
                            SelectedItemColor: (UIColor *)selectedItemColor
                          UnselectedItemColor: (UIColor *)unselectedItemColor;
{
    [self setTintColor:tintColor];
    [self setSelectedSegmentColor:selectedSegmentColor];
    [self setUnselectedSegmentColor:unselectedSegmentColor];
    [self setSelectedItemColor:selectedItemColor];
    [self setUnselectedItemColor:unselectedItemColor];
}

// JH: These need to be implemented so that each segment's size can be customizable
- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment
{
    
}

- (void)setContentOffset:(CGSize)offset forSegmentAtIndex:(NSUInteger)segment
{
    
}

@end
