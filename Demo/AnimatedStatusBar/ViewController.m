//
//  ViewController.m
//  AnimatedStatusBar
//
//  Created by David Williames on 13/02/2015.
//  Copyright (c) 2015 davidwilliames. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedStatusBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    [self.view addGestureRecognizer:tap];
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    [self.view addGestureRecognizer:pan];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [AnimatedStatusBar showMessage:@"Updated 1 hour ago" forDuration:2.0];
}

//- (void)tap:(UITapGestureRecognizer*)recognizer {
//    NSLog(@"Tap");
//    [AnimatedStatusBar showMessage:@"All data updated!" forDuration:1.5];
//}
//
//- (void)pan:(UIPanGestureRecognizer*)recognizer {
//    
//    static CGPoint startPoint;
//    static BOOL isMovingBack;
//    static BOOL valid;
//    
//    AnimatedStatusBar *statusBar = [AnimatedStatusBar sharedView];
//    
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            if(!isMovingBack && !statusBar.isMessageDisplayed){
//                [AnimatedStatusBar freeze];
//                startPoint = [recognizer locationInView:self.view];
//                valid = YES;
//            }
//            else valid = NO;
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//        {
//            if(valid){
//                CGPoint point = [recognizer locationInView:self.view];
//                CGFloat xDiff = point.x - startPoint.x;
//                statusBar.center = CGPointMake(self.view.frame.size.width/2.0 + xDiff, statusBar.center.y);
//            }
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        {
//            if(valid){
//                isMovingBack = YES;
//                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    statusBar.center = CGPointMake(self.view.frame.size.width/2.0, statusBar.center.y);
//                }completion:^(BOOL finished){
//                    [AnimatedStatusBar unfreeze];
//                    isMovingBack = NO;
//                }];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}

@end