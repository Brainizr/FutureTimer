//
//  Draw2DView.h
//  QuartzSpielerei
//
//  Created by Arkadius Miska on 29.07.14.
//  Copyright (c) 2014 Arkadius Miska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Draw2DView : UIView

@property (assign,nonatomic) uint h;
@property (assign,nonatomic) uint m;

@property (strong,nonatomic) NSTimer *clockTimer;



- (void) drawFilledHours: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledHours: (uint) hours;

- (void) drawEmptyHours: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) radius andEmptyHours: (uint) hour;

- (void)drawFilledMiutes: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledMiutes: (uint) minutes;

- (void)drawEmptyMiutes: (CGContextRef) mycontext withStartPoint: (CGPoint) startPoint radius: (CGFloat) r andFilledMiutes: (uint) minutes;

- (void) drawMiutesLeft:(uint) miutes withContext: (CGContextRef) context;

- (void) setInnerTextNumbersWithRadius: (CGFloat) radius andContext: (CGContextRef) context;
- (void) setOuterTextNumbersWithRadius: (CGFloat) radius andContext: (CGContextRef) context;

- (void) drawClockWithContext:(CGContextRef) context hoursLeft: (uint)hours andMinutesLeft: (uint)minutes;

@end
