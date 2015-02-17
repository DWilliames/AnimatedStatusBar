//
//  ProgressView.m
//  AnimatedStatusBar
//
//  Created by David Williames on 17/02/2015.
//  Copyright (c) 2015 davidwilliames. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (nonatomic, strong) UIView *progressBar;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation ProgressView
@synthesize progressBar, progressLabel;

float radius = 1.5;

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        progressBar = [[UIView alloc]initWithFrame:CGRectMake(-radius, 0, radius*2, radius*2)];
        progressBar.layer.cornerRadius = radius;
        progressBar.backgroundColor = [UIColor colorWithHue:0.59 saturation:1.0 brightness:1.0 alpha:1.0];
        [self addSubview:progressBar];
        
        float padding = 2.0;
        progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, radius*2 + padding, self.frame.size.width, 20 - radius*2 - padding)];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        progressLabel.text = @"Loading...";
        [self addSubview:progressLabel];
    }
    return self;
}

- (void)playLoadAnimation {
    [UIView animateWithDuration:3.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        progressBar.frame = CGRectMake(-radius, 0, self.frame.size.width + 2*radius, radius*2);
    }completion:^(BOOL finished){
        [AnimatedStatusBar hideCustomView];
        [UIView animateWithDuration:0.3 animations:^{
            progressBar.alpha = 0;
        }];
    }];
}

@end
