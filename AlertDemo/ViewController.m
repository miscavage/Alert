//
//  ViewController.m
//  AlertDemo
//
//  Created by Mark Miscavage on 4/22/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import "ViewController.h"
#import "Alert.h"

BOOL bounces;
BOOL hideStatus;

@interface ViewController () <AlertDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate> {
    
    Alert *alert;
    AlertIncomingTransitionType incomingType;
    AlertOutgoingTransitionType outgoingType;
    
    NSArray *incomingTypes;
    NSArray *outgoingTypes;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;

@property (weak, nonatomic) IBOutlet UIButton *incomingBtn;
@property (weak, nonatomic) IBOutlet UIButton *outgoingBtn;
@property (weak, nonatomic) IBOutlet UIButton *bounceBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *durationField;

@end

@implementation ViewController
@synthesize scrollView, typeSegment, incomingBtn, outgoingBtn, statusBtn, bounceBtn, titleField, durationField;

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTapToDismiss];
    [self setUpScrollView];
    [self setUpBtns];
    [self setUpPickers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self adjustScrollViewAnimated:NO];
}

#pragma mark Setup Methods

- (void)setUpTapToDismiss {
    //Tap to dismiss everything
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissEverything)];
    [tap setDelegate:self];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)setUpScrollView {
    [scrollView setFrame:self.view.frame];
    [scrollView setContentSize:self.view.frame.size];
}

- (void)setUpBtns {
    [self bounceAction];
    [self statusAction];
    
    [bounceBtn addTarget:self action:@selector(bounceAction) forControlEvents:UIControlEventTouchUpInside];
    [statusBtn addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpPickers {
    
    incomingTypes = @[@"Flip", @"SlideFromLeft", @"SlideFromTop", @"SlideFromRight", @"GrowFromCenter", @"FadeIn", @"InYoFace"];
    outgoingTypes = @[@"Flip", @"SlideToLeft", @"SlideToTop", @"SlideToRight", @"ShrinkToCenter", @"FadeAway", @"OutYoFace"];
    
    UIPickerView *picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    [picker1 setDelegate:self];
    [picker1 setDataSource:self];
    [picker1 setAlpha:0.0];
    [picker1 setTag:1];
    [picker1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:picker1];
    
    UIPickerView *picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    [picker2 setDelegate:self];
    [picker2 setDataSource:self];
    [picker2 setAlpha:0.0];
    [picker2 setTag:2];
    [picker2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:picker2];
}

- (void)adjustScrollViewAnimated:(BOOL)animated {
    //Whatever, weird way to make the scrollview work
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        //If is iPhone4
        [scrollView setContentOffset:CGPointMake(0, 120) animated:animated];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568) {
        //If is iPhone5
        [scrollView setContentOffset:CGPointMake(0, 32) animated:animated];
        
    }
    else if ([UIScreen mainScreen].bounds.size.height > 568) {
        //If is iPhone6, 6+
        [scrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}

#pragma mark Button Methods

- (void)bounceAction {
    if (bounces) {
        bounces = NO;
        [bounceBtn setAlpha:0.5];
        [bounceBtn setTitle:@"Doesn't Bounce" forState:UIControlStateNormal];
    }
    else {
        bounces = YES;
        [bounceBtn setAlpha:1.0];
        [bounceBtn setTitle:@"Does Bounce" forState:UIControlStateNormal];
    }
}

- (void)statusAction {
    if (hideStatus) {
        hideStatus = NO;
        [statusBtn setAlpha:0.5];
        [statusBtn setTitle:@"Don't Hide Status" forState:UIControlStateNormal];
    }
    else {
        hideStatus = YES;
        [statusBtn setAlpha:1.0];
        [statusBtn setTitle:@"Hide Status Bar" forState:UIControlStateNormal];
    }
}

#pragma mark Finding Methods

- (AlertType)findOutAlertType{
    
    switch (typeSegment.selectedSegmentIndex) {
        case 0:
            return AlertTypeError;
            break;
        case 1:
            return AlertTypeSuccess;
            break;
        case 2:
            return AlertTypeWarning;
            break;
        default:
            break;
    }
    
    return AlertTypeError;
}

- (AlertIncomingTransitionType)findOutIncomingType {
    NSString *title = incomingBtn.titleLabel.text;

    if ([title isEqualToString:@"Flip"]) {
        return AlertIncomingTransitionTypeFlip;
    }
    else if ([title isEqualToString:@"SlideFromLeft"]) {
        return AlertIncomingTransitionTypeSlideFromLeft;
    }
    else if ([title isEqualToString:@"SlideFromTop"]) {
        return AlertIncomingTransitionTypeSlideFromTop;
    }
    else if ([title isEqualToString:@"SlideFromRight"]) {
        return AlertIncomingTransitionTypeSlideFromRight;
    }
    else if ([title isEqualToString:@"GrowFromCenter"]) {
        return AlertIncomingTransitionTypeGrowFromCenter;
    }
    else if ([title isEqualToString:@"FadeIn"]) {
        return AlertIncomingTransitionTypeFadeIn;
    }
    else if ([title isEqualToString:@"InYoFace"]) {
        return AlertIncomingTransitionTypeInYoFace;
    }
    else {
        return AlertIncomingTransitionTypeSlideFromTop;
    }
}

- (AlertOutgoingTransitionType)findOutOutgoingType {
    NSString *title = outgoingBtn.titleLabel.text;

    if ([title isEqualToString:@"Flip"]) {
        return AlertOutgoingTransitionTypeFlip;
    }
    else if ([title isEqualToString:@"SlideToLeft"]) {
        return AlertOutgoingTransitionTypeSlideToLeft;
    }
    else if ([title isEqualToString:@"SlideToTop"]) {
        return AlertOutgoingTransitionTypeSlideToLeft;
    }
    else if ([title isEqualToString:@"SlideToRight"]) {
        return AlertOutgoingTransitionTypeSlideToRight;
    }
    else if ([title isEqualToString:@"ShrinkToCenter"]) {
        return AlertOutgoingTransitionTypeShrinkToCenter;
    }
    else if ([title isEqualToString:@"FadeAway"]) {
        return AlertOutgoingTransitionTypeFadeAway;
    }
    else if ([title isEqualToString:@"OutYoFace"]) {
        return AlertOutgoingTransitionTypeOutYoFace;
    }
    else {
        return AlertOutgoingTransitionTypeSlideToTop;
    }
}

#pragma mark UITextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        //If is iPhone4
        [scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568) {
        //If is iPhone5
        [scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
    else if ([UIScreen mainScreen].bounds.size.height > 568) {
        //If is iPhone6, 6+
        [scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self adjustScrollViewAnimated:YES];
}

#pragma mark UIPickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [incomingTypes count];
    }
    else if ([pickerView tag] == 2) {
        return [outgoingTypes count];
    }
    else return 1;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return incomingTypes[row];
    }
    else if ([pickerView tag] == 2) {
        return outgoingTypes[row];
    }
    else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        [incomingBtn setTitle:incomingTypes[row] forState:UIControlStateNormal];
    }
    else if ([pickerView tag] == 2) {
        [outgoingBtn setTitle:outgoingTypes[row] forState:UIControlStateNormal];
    }
}

#pragma mark Change Trannys

- (IBAction)changeIncoming:(id)sender {
    [self.view endEditing:YES];
    
    UIPickerView *picker1 = (UIPickerView *)[self.view viewWithTag:1];
    UIPickerView *picker2 = (UIPickerView *)[self.view viewWithTag:2];
    if ([picker1 alpha] == 1.0) {
        [picker1 setAlpha:0.0];
    }
    else {
        [picker1 setAlpha:1.0];
    }
    
    [picker2 setAlpha:0.0];
}

- (IBAction)changeOutgoing:(id)sender {
    [self.view endEditing:YES];

    UIPickerView *picker1 = (UIPickerView *)[self.view viewWithTag:1];
    UIPickerView *picker2 = (UIPickerView *)[self.view viewWithTag:2];
    
    if ([picker2 alpha] == 1.0) {
        [picker2 setAlpha:0.0];
    }
    else {
        [picker2 setAlpha:1.0];
    }
    
    [picker1 setAlpha:0.0];
}

#pragma mark Show/Dismiss

- (IBAction)show:(id)sender {
    
    alert = [[Alert alloc] initWithTitle:titleField.text duration:(float)durationField.text.floatValue completion:^{
        //
    }];
    [alert setDelegate:self];
    [alert setShowStatusBar:hideStatus];
    [alert setAlertType:[self findOutAlertType]];
    [alert setIncomingTransition:[self findOutIncomingType]];
    [alert setOutgoingTransition:[self findOutOutgoingType]];
    [alert setBounces:bounces];
    [alert showAlert];

}

- (IBAction)dismiss:(id)sender {
    [alert dismissAlert];
    alert = nil;
}

- (void)dismissEverything {
    [self.view endEditing:YES];
    UIPickerView *picker1 = (UIPickerView *)[self.view viewWithTag:1];
    UIPickerView *picker2 = (UIPickerView *)[self.view viewWithTag:2];

    [picker1 setAlpha:0.0];
    [picker2 setAlpha:0.0];
}

#pragma mark Delegate Methods

- (void)alertWillAppear:(Alert *)alert {

}

- (void)alertDidAppear:(Alert *)alert {

}

- (void)alertWillDisappear:(Alert *)alert {

}

- (void)alertDidDisappear:(Alert *)alert {

}

@end
