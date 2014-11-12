//
//  Draw2DView.m
//  QuartzSpielerei
//
//  Created by Arkadius Miska on 29.07.14.
//  Copyright (c) 2014 Arkadius Miska. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "Draw2DView.h"


@implementation Draw2DView

@synthesize hours = _hours;
@synthesize minutes = _minutes;
@synthesize clockTimer = _clockTimer;
@synthesize radiusMax = _radiusMax;

@synthesize lbl_hours = _lbl_hours;
@synthesize lbl_time = _lbl_time;


-(id)initClockWithFrame:(CGRect)frame andHours: (uint)hours andMiuntes:(uint)minutes {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    _hours = hours;
    _minutes = minutes;
    
    _radiusMax = (self.frame.size.width <= self.frame.size.height) ? self.frame.size.width/2 : self.frame.size.height/2;
    
    _lbl_time = [[UILabel alloc] initWithFrame:CGRectMake(_radiusMax*0.77, _radiusMax*1.3, _radiusMax*0.45, _radiusMax*0.09)];
    _lbl_hours = [[UILabel alloc] initWithFrame:CGRectMake(_radiusMax*0.77, _radiusMax*1.3+_radiusMax*0.09, _radiusMax*0.45, _radiusMax*0.09)];
    
    [_lbl_time setFont:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.1]];
    [_lbl_hours setFont:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.09]];
    
    [_lbl_time setTextAlignment:NSTextAlignmentCenter];
    [_lbl_hours setTextAlignment:NSTextAlignmentCenter];
    
    
    if (_hours < 10) {
        
        if (_minutes < 10) {
            [_lbl_time setText:[NSString stringWithFormat:@"0%i : 0%i ",_hours, _minutes]];
        } else {
            [_lbl_time setText:[NSString stringWithFormat:@"0%i : %i ",_hours, _minutes]];
        }
        
        
    } else {
        if (_minutes < 10) {
            [_lbl_time setText:[NSString stringWithFormat:@"%i : 0%i ",_hours, _minutes]];
        } else {
            [_lbl_time setText:[NSString stringWithFormat:@"%i : %i ",_hours, _minutes]];
        }
    }
    
    [_lbl_hours setText:@"Stunden"];
    
    [self addSubview:_lbl_hours];
    [self addSubview:_lbl_time];
    

    
    return self;
    
}


// Override drawRect to perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    // The Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Anti-Aliasing
    CGContextSetAllowsAntialiasing(context, true);

    // Draw
    [self drawClockWithContext:context];
  
}


/* Draw the filled hour-items and then trigger the method to draw the empty hour-items */
- (void) drawFilledHourswithContext: (CGContextRef) mycontext {
    
    CGFloat hourRadius = _radiusMax / 2.5;
    CGPoint startPoint = CGPointMake(_radiusMax, _radiusMax);
    CGFloat coverage = 2 * M_PI * hourRadius;
    CGFloat lineWidth = _radiusMax * 0.18;
    
    uint itemsCount = (_hours%12 == 0) ? 24 : (12-_hours)*2;
    
    
    CGFloat paddings = coverage/4 * 0.084;
    CGFloat segPadding = (coverage/4 * 0.084) / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,
                                     [UIColor colorWithRed:0.949 green:0.647 blue:0.506 alpha:1].CGColor);
    
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.x);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-hourRadius,startPoint.y, startPoint.x-hourRadius,startPoint.y+hourRadius, hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-hourRadius,startPoint.y+(2*hourRadius), startPoint.x,startPoint.y+(2*hourRadius), hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+hourRadius,startPoint.y+(2*hourRadius), startPoint.x+hourRadius,startPoint.y+hourRadius, hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+hourRadius,startPoint.y, startPoint.x,startPoint.y, hourRadius);
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding;
    }
    
    if (!(_hours == 12 || _hours == 0)) {
        uint filledItems = (itemsCount-1)/2;
        dashArray[itemsCount-1] = coverage-((filledItems*segPadding)+(filledItems*segWidth));
        
    } else {
        
        if (_hours == 0) {
            dashArray[itemsCount-1] = segPadding;
        }
        
        
    }
    
    CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
    CGContextStrokePath(mycontext);

    
    

    
}


/* Draw the empty hour-items */
- (void) drawHoursWithContext: (CGContextRef) mycontext {
    
    CGFloat hourRadius = _radiusMax / 2.5;
    CGPoint startPoint = CGPointMake(_radiusMax, _radiusMax);
    CGFloat coverage = 2 * M_PI * hourRadius;
    CGFloat lineWidth = _radiusMax * 0.18;
    
    uint itemsCount = (_hours%12 == 0) ? 24 : _hours*2;
    
    CGFloat paddings = coverage/4 * 0.084;
    CGFloat segPadding = (coverage/4 * 0.084) / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,color_color_gray_lighten.CGColor); /*#eeeeee*/
    
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.y);
    CGContextAddArcToPoint(mycontext, startPoint.x+hourRadius,startPoint.y, startPoint.x+hourRadius,startPoint.y+hourRadius, hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+hourRadius,startPoint.y+(2*hourRadius), startPoint.x,startPoint.y+(2*hourRadius), hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-hourRadius,startPoint.y+(2*hourRadius), startPoint.x-hourRadius,startPoint.y+hourRadius, hourRadius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-hourRadius,startPoint.y, startPoint.x,startPoint.y, hourRadius);
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding;
    }
    
    if (!(_hours == 12 || _hours == 0)) {
        
        uint filledItems = (itemsCount-1)/2;
        dashArray[itemsCount-1] = coverage-((filledItems*segPadding)+(filledItems*segWidth));
        
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
        
    } else {
        
        if (_hours == 12) {
            dashArray[itemsCount-1] = segPadding;
            CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
            CGContextStrokePath(mycontext);
        }
        
    }

    
    
    
    
}




- (void)drawFilledMiutes: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledMiutes: (uint) minutes {
    
    uint itemsCount = minutes * 2;
    
    
    CGFloat coverage = 2 * M_PI * r;
    CGFloat lineWidth = _radiusMax * 0.2;
    
    CGFloat paddings = coverage/4 * 0.06; // 0.06 Padding-Big
    CGFloat segPadding = paddings / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    CGFloat segPadding_min = (segWidth * 0.084) / 4;  // 0.084 Padding-Big_min
    segWidth = segWidth - (segPadding_min*4);
    
    uint segWidthCount = 0;
    uint segPaddingCount = 0;
    uint segPadding_minCount = 0;
    
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,
                                     [UIColor colorWithRed:0.937 green:0.694 blue:0.439 alpha:1].CGColor);
    CGContextTranslateCTM(mycontext, 0, -(_radiusMax*0.68 - _radiusMax/2.5));
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.y);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-r,startPoint.y, startPoint.x-r,startPoint.y+r, r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-r,startPoint.y+(2*r), startPoint.x,startPoint.y+(2*r), r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+r,startPoint.y+(2*r), startPoint.x+r,startPoint.y+r, r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+r,startPoint.y, startPoint.x,startPoint.y, r);
    
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth/5;
        segWidthCount++;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding_min;
        segPadding_minCount++;
    }
    
    for (int k = 9; k < itemsCount; k=k+10) {
        dashArray[k] = segPadding;
        segPaddingCount++;
    }
   
    
    if (minutes != 60) {
        
        if (segPaddingCount == 0) {
            segPaddingCount = 1;
        }
        
        CGFloat rest = coverage-(((segPadding_minCount-1) * segPadding_min) + ((segWidthCount-1) * segWidth/5) + ((segPaddingCount-1) * segPadding));
        dashArray[itemsCount-1] = rest;
        
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
        
        
        
    } else {
        dashArray[itemsCount-1] = segPadding;
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
    }
    
    
}




- (void)drawEmptyMiutes: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledMiutes: (uint) minutes {
    
    
    
    uint itemsCount = minutes * 2;
    
    
    CGFloat coverage = 2 * M_PI * r;
    CGFloat lineWidth = _radiusMax * 0.2;
    
    CGFloat paddings = coverage/4 * 0.06; // 0.06 Padding-Big
    CGFloat segPadding = paddings / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    CGFloat segPadding_min = (segWidth * 0.084) / 4;  // 0.084 Padding-Big_min
    segWidth = segWidth - (segPadding_min*4);
    
    uint segWidthCount = 0;
    uint segPaddingCount = 0;
    uint segPadding_minCount = 0;
    
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,
                                     [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1].CGColor);
    
    
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.y);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+r,startPoint.y, startPoint.x+r,startPoint.y+r, r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+r,startPoint.y+(2*r), startPoint.x,startPoint.y+(2*r), r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-r,startPoint.y+(2*r), startPoint.x-r,startPoint.y+r, r);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-r,startPoint.y, startPoint.x,startPoint.y, r);
    
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth/5;
        segWidthCount++;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding_min;
        segPadding_minCount++;
    }
    
    for (int k = 9; k < itemsCount; k=k+10) {
        dashArray[k] = segPadding;
        segPaddingCount++;
    }
    if (segPaddingCount == 0) {
        segPaddingCount = 1;
    }
    
    
    if (minutes != 60) {
        
        CGFloat rest = coverage-(((segPadding_minCount-1) * segPadding_min) + ((segWidthCount-1) * segWidth/5) + ((segPaddingCount-1) * segPadding));
        dashArray[itemsCount-1] = rest;
        
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
        
        
    } else {
        dashArray[itemsCount-1] = segPadding;
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
    }
    
    
    
}


- (void) setInnerTextNumbersWithRadius: (CGFloat) radius andContext: (CGContextRef) context {
    NSArray *myLetters = [NSArray arrayWithObjects:@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",nil];
    
    for (int i = 0; i < 12; i++)
    {
        NSString *letter = [myLetters objectAtIndex:i];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.05]}];
        
        CGPoint center = CGPointMake(_radiusMax, _radiusMax+_radiusMax*0.68);
        
        CGFloat theta = M_PI - i * (2 * M_PI / 12.0);
        CGFloat x = center.x + (radius) * sin(theta) - letterSize.width / 2.0;
        CGFloat y = center.y + (radius) * cos(theta) - letterSize.height / 2.0;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.05]}];
    }
}


- (void) setOuterTextNumbersWithRadius: (CGFloat) radius andContext: (CGContextRef) context {
    NSArray *myLetters_big = [NSArray arrayWithObjects:@"60",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];
    
    for (int i = 0; i < 12; i++)
    {
        NSString *letter = [myLetters_big objectAtIndex:i];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.07]}];
        
        CGPoint center = CGPointMake(_radiusMax, _radiusMax+_radiusMax*0.68);
        
        CGFloat theta = M_PI - i * (2 * M_PI / 12.0);
        CGFloat x = center.x + (radius) * sin(theta) - letterSize.width / 2.0;
        CGFloat y = center.y + (radius) * cos(theta) - letterSize.height / 2.0;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo-Medium" size:_radiusMax*0.07]}];
    }
}





- (void) drawClockWithContext:(CGContextRef) context {
    
    
    [self drawHoursWithContext:context];
    [self drawFilledHourswithContext:context];
    
    if (_minutes == 0) {
        [self drawFilledMiutes:context withStartPoint:CGPointMake(_radiusMax, _radiusMax) radius:_radiusMax*0.68 andFilledMiutes:60];
        
    } else {
        [self drawFilledMiutes:context withStartPoint:CGPointMake(_radiusMax, _radiusMax) radius:_radiusMax*0.68 andFilledMiutes:60-_minutes];
        
        [self drawEmptyMiutes:context withStartPoint:CGPointMake(_radiusMax, _radiusMax) radius:_radiusMax*0.68 andFilledMiutes:_minutes];
    }

    
    [self setInnerTextNumbersWithRadius:_radiusMax/1.9 andContext:context];
    [self setOuterTextNumbersWithRadius:_radiusMax/1.19 andContext:context];
    
    
//    [@"Stunden" drawAtPoint:CGPointMake(134, (_radiusMax*1.57)+14.0) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo-Medium" size:15.0]}];
    
}






@end
