//
//  ViewController.m
//  AnimatedStatusBar
//
//  Created by David Williames on 13/02/2015.
//  Copyright (c) 2015 davidwilliames. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedStatusBar.h"
#import "ProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTap;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *pan;
@end

@implementation ViewController
@synthesize bgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bgView.layer.shadowRadius = 8.0;
    bgView.layer.shadowOpacity = 0.3;
    
    [AnimatedStatusBar initialize];
    [_singleTap requireGestureRecognizerToFail:_doubleTap];
}

- (IBAction)tap:(id)sender {
    [AnimatedStatusBar setAnimationDuration:0.5 andSpringDamping:0.6];
    [AnimatedStatusBar showMessage:@"Updated 1 hour ago" forDuration:2.0];
}

- (IBAction)doubleTap:(id)sender {
    ProgressView *customView = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [AnimatedStatusBar setAnimationDuration:0.75 andSpringDamping:0.8];
    [AnimatedStatusBar showCustomView:customView];
    [customView playLoadAnimation];
}

- (IBAction)pan:(id)sender {
    static CGPoint startPoint;
    AnimatedStatusBar *statusBar = [AnimatedStatusBar sharedView];
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        [AnimatedStatusBar freeze];
        startPoint = [recognizer locationInView:self.view];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat x = self.view.frame.size.width/2.0 + [recognizer locationInView:self.view].x - startPoint.x;
        statusBar.center = CGPointMake(x, statusBar.center.y);
        bgView.center = CGPointMake(x, bgView.center.y);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            statusBar.center = CGPointMake(self.view.frame.size.width/2.0, statusBar.center.y);
            bgView.center = self.view.center;
        }completion:^(BOOL finished){
            [AnimatedStatusBar unfreeze];
        }];
    }
}

@end
