//
//  Alert.h
//  AlertDemo
//
//  Created by Mark Miscavage on 4/22/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import <UIKit/UIKit.h>

//Incoming Transition Types
typedef NS_ENUM(NSUInteger, AlertIncomingTransitionType) {
    AlertIncomingTransitionTypeFlip = 1,
    AlertIncomingTransitionTypeSlideFromLeft,
    AlertIncomingTransitionTypeSlideFromTop,
    AlertIncomingTransitionTypeSlideFromRight,
    AlertIncomingTransitionTypeGrowFromCenter,
    AlertIncomingTransitionTypeFadeIn,
    AlertIncomingTransitionTypeInYoFace
};

//Outgoing Transition Types
typedef NS_ENUM(NSUInteger, AlertOutgoingTransitionType) {
    AlertOutgoingTransitionTypeFlip = 1,
    AlertOutgoingTransitionTypeSlideToLeft,
    AlertOutgoingTransitionTypeSlideToTop,
    AlertOutgoingTransitionTypeSlideToRight,
    AlertOutgoingTransitionTypeShrinkToCenter,
    AlertOutgoingTransitionTypeFadeAway,
    AlertOutgoingTransitionTypeOutYoFace
};

//Type of alert, Error = red, Success = blue, Warning = yellow
typedef NS_ENUM(NSUInteger, AlertType) {
    AlertTypeError = 1,
    AlertTypeSuccess,
    AlertTypeWarning
};


@class Alert;

@protocol AlertDelegate;

@interface Alert : UIView

@property (nonatomic, weak) id <AlertDelegate> delegate;


- (instancetype)initWithTitle:(NSString *)title
                     duration:(CGFloat)duration
                  completion:(void (^)(void))completion;

//Does Alert bounce when it is transitioning in?
@property (nonatomic, assign) BOOL bounces;

//Do you want to show the status bar up top, or have it disappear when Alert is showing?
@property (nonatomic, assign) BOOL showStatusBar;

//Background color of Alert, suggest using AlertTypes for this
@property (nonatomic, assign) UIColor *backgroundColor;

//Color of Alert text
@property (nonatomic, assign) UIColor *titleColor;

@property (nonatomic, assign) AlertIncomingTransitionType incomingTransition;
@property (nonatomic, assign) AlertOutgoingTransitionType outgoingTransition;

@property (nonatomic, assign) AlertType alertType;

- (void)showAlert;
- (void)dismissAlert;


@end

@protocol AlertDelegate <NSObject>

@optional

//Called when your Alert is transitioning to the top of the screen
- (void)alertWillAppear:(Alert *)alert;

//Called when your Alert is at the top of the screen after animating
- (void)alertDidAppear:(Alert *)alert;

//Called when your Alert is transitioning away from the top of the screen
- (void)alertWillDisappear:(Alert *)alert;

//Called when your Alert has disappeared from the screen
- (void)alertDidDisappear:(Alert *)alert;

@end