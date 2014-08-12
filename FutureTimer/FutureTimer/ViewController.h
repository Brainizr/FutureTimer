//
//  ViewController.h
//  FutureTimer
//
//  Created by Arkadius Miska on 12.08.14.
//  Copyright (c) 2014 Arkadius Miska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draw2DView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) Draw2DView *clockView;

@property (assign,nonatomic) uint h;
@property (assign,nonatomic) uint m;

@property (strong,nonatomic) NSTimer *clockTimer;


@end

