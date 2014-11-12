//
//  Draw2DView.h
//  QuartzSpielerei
//
//  Created by Arkadius Miska on 29.07.14.
//  Copyright (c) 2014 Arkadius Miska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constans.h"

@interface Draw2DView : UIView


@property (assign, nonatomic) uint hours;
@property (assign, nonatomic) uint minutes;

@property (strong,nonatomic) NSTimer *clockTimer;
@property (assign, nonatomic) CGFloat radiusMax;

@property (strong, nonatomic) UILabel *lbl_time;
@property (strong, nonatomic) UILabel *lbl_hours;

//Method definitions
- (id)initClockWithFrame:(CGRect)frame andHours: (uint)hours andMiuntes:(uint)minutes;



@end
