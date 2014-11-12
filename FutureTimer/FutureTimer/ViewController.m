//
//  ViewController.m
//  FutureTimer
//
//  Created by Arkadius Miska on 12.08.14.
//  Copyright (c) 2014 Arkadius Miska. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@end

@implementation ViewController

@synthesize clockView = _clockView;
@synthesize clockTimer = _clockTimer;

@synthesize h = _h;
@synthesize m = _m;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"View loaded!");
    
    self.h = 1;
    self.m = 10;
    
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) runClock {
    
    [self.clockView removeFromSuperview];
    self.clockView = nil;
    
    
    if (self.h == 0) {
        
        if (self.m == 0) {
            [self.clockTimer invalidate];
            self.clockTimer = nil;
        } else {
            self.m = self.m - 1;
        }
    } else {
        if (self.m == 0) {
            self.m = 59;
            self.h = self.h - 1;
        } else {
            self.m = self.m - 1;
        }
    }
    
    
    
    
    
    self.clockView = [[Draw2DView alloc] initClockWithFrame:CGRectMake(0, 120, 150, 300) andHours:self.h andMiuntes:self.m];
    [self.clockView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:self.clockView];
    
    
    
    
}

@end

