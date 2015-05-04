//
//  Alert.m
//  AlertDemo
//
//  Created by Mark Miscavage on 4/22/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import "Alert.h"

BOOL doesBounce = NO;

@interface Alert () <UIScrollViewDelegate> {

    UIView *alertView;
    UILabel *titleLabel;
    NSString *titleString;
    
    AlertIncomingTransitionType incomingType;
    AlertOutgoingTransitionType outgoingType;
    
    CGFloat timePassed;
    CGFloat timeDuration;
    NSTimer *timer;
    
    UIScrollView *scrollView; //Needed for truncation of the title
}

@end

@implementation Alert

#pragma mark Instance Types

- (instancetype)initWithTitle:(NSString *)title
                     duration:(CGFloat)duration
                   completion:(void (^)(void))completion {
    
    if ([super init]) {
        timeDuration = duration;
        titleString = title;
        
        [self configure];
    }
    
    return self;
}

#pragma mark Creation Methods

- (void)configure {
    [self setUpAlertView];
    [self setUpTitleLabel];
}

- (void)setUpAlertView {
    alertView = [[UIView alloc] init];
    [alertView setFrame:[self alertRect]];
    [alertView setBackgroundColor:[UIColor colorWithRed:0.91 green:0.302 blue:0.235 alpha:1] /*#e84d3c*/];
}

- (void)setUpTitleLabel {

    if (!titleLabel) {
        CGRect rect = [self alertRect];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, rect.origin.y + 44, rect.size.width - 60, 24)];
        [titleLabel setText:titleString];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [titleLabel setMinimumScaleFactor:14.0/16.0];
        
        CGSize size = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}];

        if (size.width > titleLabel.bounds.size.width) {
            //Text is truncated, put in a scrollview and scroll that text across the top
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setBounces:NO];
            [scrollView setDelegate:self];
            [scrollView setContentSize:CGSizeMake(size.width + 60, rect.size.height)];
            
            [alertView addSubview:scrollView];
            
            [titleLabel setFrame:CGRectMake(30, rect.origin.y + 44, size.width, 24)];
            [scrollView addSubview:titleLabel];
        }
        else {
            [alertView addSubview:titleLabel];
        }
        
    }
    
}

#pragma mark Timer Methods

- (void)setTimer {

    if (timeDuration != 0) {
        timePassed = 0.0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countTimePassed) userInfo:nil repeats:YES];
    }
    
}

- (void)countTimePassed {
    timePassed += 0.1;
    
    if (timePassed >= timeDuration) {
        [timer invalidate];
        timer = nil;
        [self dismissAlert];
    }
}

#pragma mark UIScrollView Methods

- (void)slideScrollView {
    //Animate the ScrollView so you can see the entire title
    [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
    [UIScrollView setAnimationDuration:timeDuration/1.5];
    [scrollView setContentOffset:CGPointMake(-scrollView.frame.size.width + scrollView.contentSize.width, 0)];
    [UIScrollView commitAnimations];
}

#pragma mark Accessor Methods

- (void)setIncomingTransition:(AlertIncomingTransitionType)incomingTransition {
    incomingType = incomingTransition;
}

- (void)setOutgoingTransition:(AlertOutgoingTransitionType)outgoingTransition {
    outgoingType = outgoingTransition;
}

- (void)setAlertType:(AlertType)alertType {
    
    if (alertType == AlertTypeError) {
        [alertView setBackgroundColor:[UIColor colorWithRed:0.91 green:0.302 blue:0.235 alpha:1] /*#e84d3c*/];
    }
    else if (alertType == AlertTypeSuccess) {
        [alertView setBackgroundColor:[UIColor colorWithRed:0.196 green:0.576 blue:0.827 alpha:1] /*#3293d3*/];
    }
    else if (alertType == AlertTypeWarning) {
        [alertView setBackgroundColor:[UIColor colorWithRed:1 green:0.804 blue:0 alpha:1] /*#ffcd00*/];
    }
    
}

- (void)setBounces:(BOOL)bounces {
    if (bounces) {
        doesBounce = bounces;
    }
}

- (void)setShowStatusBar:(BOOL)showStatusBar {
    if (!showStatusBar) {
        //Set "View controller-based status bar appearance" = NO in info.plist
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (BOOL)prefersStatusBarHidden {
    //Needed for Hiding the status bar
    return YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [alertView setBackgroundColor:backgroundColor];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [titleLabel setTextColor:titleColor];
}

#pragma mark Show/Dismiss Methods

- (void)showAlert {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self addSubview:alertView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertWillAppear:)]) {
        [self.delegate alertWillAppear:self];
    }
    
    if (incomingType) {
        [self configureIncomingAnimationFor:incomingType];
    }
    else {
        [self configureIncomingAnimationFor:AlertIncomingTransitionTypeSlideFromTop];
    }
}

- (void)dismissAlert {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertWillDisappear:)]) {
        [self.delegate alertWillDisappear:self];
    }

    if (outgoingType) {
        [self configureOutgoingAnimationFor:outgoingType];
    }
    else {
        [self configureOutgoingAnimationFor:AlertOutgoingTransitionTypeSlideToTop];
    }
}

#pragma mark Transition Methods

- (void)configureIncomingAnimationFor:(AlertIncomingTransitionType)trannyType {
    
    CGRect rect = [self alertRect];

    switch (trannyType) {
        case AlertIncomingTransitionTypeFlip: {
            
            if (doesBounce) {
                rect.origin.y = -90;
                [alertView setFrame:rect];
                
                [UIView animateWithDuration:0.185 animations:^{
                    [alertView setFrame:[self alertRect]];
                }];
                
                alertView.transform = CGAffineTransformMake(1, 0, 0, -0.25, 0, alertView.transform.ty);

                [UIView animateWithDuration:0.35 delay:0.18 usingSpringWithDamping:0.65 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                    alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.25 animations:^{
                        alertView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [self finishShowing];
                    }];
                }];
                
            }
            else {
                rect.origin.y = -90;
                [alertView setFrame:rect];
                
                [UIView animateWithDuration:0.185 animations:^{
                    [alertView setFrame:[self alertRect]];
                }];
                
                alertView.transform = CGAffineTransformMake(1, 0, 0, -1 , 0, alertView.transform.ty);

                [UIView animateWithDuration:0.25 animations:^{
                    alertView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            
            break;
        }
        case AlertIncomingTransitionTypeSlideFromTop: {
            rect.origin.y = -90;
            [alertView setFrame:rect];
            
            if (doesBounce) {
                [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            else {
                [UIView animateWithDuration:0.125 animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            
            break;
        }
        case AlertIncomingTransitionTypeSlideFromLeft: {
            rect.origin.x = -rect.size.width;
            [alertView setFrame:rect];
            
            if (doesBounce) {
                [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            else {
                [UIView animateWithDuration:0.125 animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            
            break;
        }
        case AlertIncomingTransitionTypeSlideFromRight: {
            rect.origin.x = rect.size.width;
            [alertView setFrame:rect];
            
            if (doesBounce) {
                [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            else {
                [UIView animateWithDuration:0.125 animations:^{
                    [alertView setFrame:[self alertRect]];
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }
            
            break;
        }
        case AlertIncomingTransitionTypeGrowFromCenter: {
            
            alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            
            [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
                alertView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self finishShowing];
            }];

            
            break;
        }
        case AlertIncomingTransitionTypeFadeIn: {
            [alertView setAlpha:0.0];
            
            [UIView animateWithDuration:0.35 animations:^{
                [alertView setAlpha:1.0];
            } completion:^(BOOL finished) {
                [self finishShowing];
            }];
            
            
            break;
        }
        case AlertIncomingTransitionTypeInYoFace: {
            alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            
            [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.95 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                alertView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    alertView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self finishShowing];
                }];
            }];
            
            break;
        }
        default: {
            break;
        }
    }
    
}

- (void)configureOutgoingAnimationFor:(AlertOutgoingTransitionType)trannyType {

    CGRect finalRect = [self alertRect];

    switch (trannyType) {
        case AlertOutgoingTransitionTypeFlip: {
            
            [UIView animateWithDuration:0.275 animations:^{
                alertView.transform = CGAffineTransformMake(1, 0, 0, -0.05 , 0, alertView.transform.ty - 18.5);
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeSlideToTop: {
            finalRect.origin.y = -90;
            
            [UIView animateWithDuration:0.15 animations:^{
                [alertView setFrame:finalRect];
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeSlideToLeft: {
            finalRect.origin.x = -finalRect.size.width;
            
            [UIView animateWithDuration:0.15 animations:^{
                [alertView setFrame:finalRect];
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeSlideToRight: {
            finalRect.origin.x = finalRect.size.width;
           
            [UIView animateWithDuration:0.15 animations:^{
                [alertView setFrame:finalRect];
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeShrinkToCenter: {

            [UIView animateWithDuration:0.2 animations:^{
                alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeFadeAway: {
            
            [UIView animateWithDuration:0.2 animations:^{
                [alertView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [self finishDisappearing];
            }];
            
            break;
        }
        case AlertOutgoingTransitionTypeOutYoFace: {
            alertView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.95 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                alertView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
                } completion:^(BOOL finished) {
                    [self finishDisappearing];
                }];
            }];
            
            break;
        }
        default: {
            break;
        }
    }
    
}

#pragma mark Finishing Methods

- (void)finishShowing {
    [self setTimer];
    
    if (scrollView) {
        [self performSelector:@selector(slideScrollView) withObject:nil afterDelay:0.2];
    }
    if ([self.delegate respondsToSelector:@selector(alertDidAppear:)]) {
        [self.delegate alertDidAppear:self];
    }
}

- (void)finishDisappearing {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidDisappear:)]) {
        [self.delegate alertDidDisappear:self];
    }
}

- (CGRect)alertRect {
    UIScreen *mainScreen = [UIScreen mainScreen];
    return CGRectMake(-20, -10, mainScreen.bounds.size.width + 40, 74);
}

@end
