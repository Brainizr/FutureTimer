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

@synthesize h = _h;
@synthesize m = _m;

@synthesize clockTimer = _clockTimer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    // Drawing code:
    ////////////////
    // In order to draw a line on an iPhone screen using Quartz 2D we first need to obtain the graphics context for the view:
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Anti-Aliasing
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextSetLineWidth(context, 2.0);
    
    
    // Next need to create a color reference. We can do this by specifying the RGBA components of the required color:
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    
    // Using the color reference and the context we can now specify that the color is to be used when drawing the line:
    CGContextSetStrokeColorWithColor(context, color);
    
    // Draw
    [self drawClockWithContext:context hoursLeft:self.h andMinutesLeft:self.m];
  
}


/* Draw the filled hour-items and then trigger the method to draw the empty hour-items */
- (void) drawFilledHours: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) radius andFilledHours: (uint) hours {
    
    
    CGFloat coverage = 2 * M_PI * radius;
    CGFloat lineWidth = 30.0;
    
    uint itemsCount = (hours * 2);
    
    
    CGFloat paddings = coverage/4 * 0.084;
    CGFloat segPadding = (coverage/4 * 0.084) / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,
                                     [UIColor colorWithRed:0.949 green:0.647 blue:0.506 alpha:1].CGColor);
    
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.x);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-radius,startPoint.y, startPoint.x-radius,startPoint.y+radius, radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-radius,startPoint.y+(2*radius), startPoint.x,startPoint.y+(2*radius), radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+radius,startPoint.y+(2*radius), startPoint.x+radius,startPoint.y+radius, radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+radius,startPoint.y, startPoint.x,startPoint.y, radius);
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding;
    }
    
    if (hours != 12) {
        uint filledItems = (itemsCount-1)/2;
        dashArray[itemsCount-1] = coverage-((filledItems*segPadding)+(filledItems*segWidth));
        
        
    } else {
        dashArray[itemsCount-1] = segPadding;
    }

    CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
    CGContextStrokePath(mycontext);

    
}


/* Draw the filled hour-items */
- (void) drawEmptyHours: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) radius andEmptyHours: (uint) hours {
    
    
    CGFloat coverage = 2 * M_PI * radius;
    CGFloat lineWidth = 30.0;
    
    uint itemsCount = (hours * 2);
    
    
    CGFloat paddings = coverage/4 * 0.084;
    CGFloat segPadding = (coverage/4 * 0.084) / 3;
    CGFloat segWidth = (coverage/4 - paddings) / 3;
    
    CGContextSetLineWidth(mycontext, lineWidth);
    CGContextSetStrokeColorWithColor(mycontext,
                                     [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1].CGColor);
    
    
    CGContextMoveToPoint(mycontext, startPoint.x, startPoint.y);
    CGContextAddArcToPoint(mycontext, startPoint.x+radius,startPoint.y, startPoint.x+radius,startPoint.y+radius, radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x+radius,startPoint.y+(2*radius), startPoint.x,startPoint.y+(2*radius), radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-radius,startPoint.y+(2*radius), startPoint.x-radius,startPoint.y+radius, radius);
    
    CGContextAddArcToPoint(mycontext, startPoint.x-radius,startPoint.y, startPoint.x,startPoint.y, radius);
    
    
    CGFloat dashArray[itemsCount];
    
    for (int i = 0; i < itemsCount; i=i+2) {
        dashArray[i] = segWidth;
    }
    
    for (int j = 1; j < itemsCount; j=j+2) {
        dashArray[j] = segPadding;
    }
    
    if (hours != 12) {
        uint filledItems = (itemsCount-1)/2;
        dashArray[itemsCount-1] = coverage-((filledItems*segPadding)+(filledItems*segWidth));
        
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
        
        // Trigger the drawEmptyHours method
        [self drawFilledHours:mycontext withStartPoint:startPoint radius:radius andFilledHours:12-hours];
    } else {
        dashArray[itemsCount-1] = segPadding;
        CGContextSetLineDash(mycontext, -segPadding/2, dashArray, itemsCount);
        CGContextStrokePath(mycontext);
    }
    
    
    
    
}




- (void)drawFilledMiutes: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledMiutes: (uint) minutes {
    
    uint itemsCount = minutes * 2;
    
    
    CGFloat coverage = 2 * M_PI * r;
    CGFloat lineWidth = 35.0;
    
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
    CGContextTranslateCTM(mycontext, 0, -r/2);
    
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
    CGFloat lineWidth = 35.0;
    
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
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:8.0]}];
        
        CGPoint center = CGPointMake(160, 260);
        
        CGFloat theta = M_PI - i * (2 * M_PI / 12.0);
        CGFloat x = center.x + (radius) * sin(theta) - letterSize.width / 2.0;
        CGFloat y = center.y + (radius) * cos(theta) - letterSize.height / 2.0;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:8.0]}];
    }
}


- (void) setOuterTextNumbersWithRadius: (CGFloat) radius andContext: (CGContextRef) context {
    NSArray *myLetters_big = [NSArray arrayWithObjects:@"60",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];
    
    for (int i = 0; i < 12; i++)
    {
        NSString *letter = [myLetters_big objectAtIndex:i];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:11.0]}];
        
        CGPoint center = CGPointMake(160, 260);
        
        CGFloat theta = M_PI - i * (2 * M_PI / 12.0);
        CGFloat x = center.x + (radius) * sin(theta) - letterSize.width / 2.0;
        CGFloat y = center.y + (radius) * cos(theta) - letterSize.height / 2.0;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:11.0]}];
    }
}


- (void) drawMiutesLeft:(uint) miutes withContext: (CGContextRef) context {
    
    
    if (miutes == 0) {
//        CGContextTranslateCTM(context, 0, -50);
        [self drawFilledMiutes:context withStartPoint:CGPointMake(160.0, 160.0) radius:100.0 andFilledMiutes:60];
        
    } else {
        [self drawFilledMiutes:context withStartPoint:CGPointMake(160.0, 160.0) radius:100.0 andFilledMiutes:60-miutes];
        
        [self drawEmptyMiutes:context withStartPoint:CGPointMake(160.0, 160.0) radius:100.0 andFilledMiutes:miutes];
    }
    
    
    
}


- (void) drawClockWithContext:(CGContextRef) context hoursLeft: (uint)hours andMinutesLeft: (uint)minutes {
    
    [self drawEmptyHours:context withStartPoint:CGPointMake(160.0, 160.0) radius:50.0 andEmptyHours:hours];
    [self drawMiutesLeft:minutes withContext:context];
    
    
    [self setInnerTextNumbersWithRadius:72.0 andContext:context];
    [self setOuterTextNumbersWithRadius:128.0 andContext:context];
    
    
    if (hours < 10) {
        
        if (minutes < 10) {
            [[NSString stringWithFormat:@"0%i : 0%i ",hours, minutes] drawAtPoint:CGPointMake(138, 245) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:14.0]}];
        } else {
            [[NSString stringWithFormat:@"0%i : %i ",hours, minutes] drawAtPoint:CGPointMake(138, 245) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:14.0]}];
        }
        
        
    } else {
        if (minutes < 10) {
            [[NSString stringWithFormat:@"%i : 0%i ",hours, minutes] drawAtPoint:CGPointMake(138, 245) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:14.0]}];
        } else {
            [[NSString stringWithFormat:@"%i : %i ",hours, minutes] drawAtPoint:CGPointMake(138, 245) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:14.0]}];
        }
    }
    
    [@"Stunden" drawAtPoint:CGPointMake(134, 259) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Exo" size:15.0]}];
    
}






@end
