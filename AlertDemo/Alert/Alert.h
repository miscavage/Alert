//
//  Alert.h
//  AlertDemo
//
//  Created by Mark Miscavage on 4/22/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, AlertIncomingTransitionType) {
    AlertIncomingTransitionTypeFlip = 1,
    AlertIncomingTransitionTypeSlideFromLeft,
    AlertIncomingTransitionTypeSlideFromTop,
    AlertIncomingTransitionTypeSlideFromRight,
    AlertIncomingTransitionTypeGrowFromCenter,
    AlertIncomingTransitionTypeFadeIn,
    AlertIncomingTransitionTypeInYoFace
};

typedef NS_ENUM(NSUInteger, AlertOutgoingTransitionType) {
    AlertOutgoingTransitionTypeFlip = 1,
    AlertOutgoingTransitionTypeSlideToLeft,
    AlertOutgoingTransitionTypeSlideToTop,
    AlertOutgoingTransitionTypeSlideToRight,
    AlertOutgoingTransitionTypeShrinkToCenter,
    AlertOutgoingTransitionTypeFadeAway,
    AlertOutgoingTransitionTypeOutYoFace
};

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

@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, assign) UIColor *backgroundColor;
@property (nonatomic, assign) UIColor *titleColor;

@property (nonatomic, assign) AlertIncomingTransitionType incomingTransition;
@property (nonatomic, assign) AlertOutgoingTransitionType outgoingTransition;

@property (nonatomic, assign) AlertType alertType;

- (void)showAlert;
- (void)dismissAlert;

@end

@protocol AlertDelegate <NSObject>

@optional

- (void)alertWillAppear:(Alert *)alert;

- (void)alertDidAppear:(Alert *)alert;

- (void)alertWillDisappear:(Alert *)alert;

- (void)alertDidDisappear:(Alert *)alert;

@end