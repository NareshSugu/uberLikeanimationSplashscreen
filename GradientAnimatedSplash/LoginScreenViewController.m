//
//  LoginScreenViewController.m
//  GradientAnimatedSplash
//
//  Created by nsugu on 18/07/18.
//  Copyright © 2018 NSK. All rights reserved.
//

#import "LoginScreenViewController.h"

@interface LoginScreenViewController ()

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;

@end

@implementation LoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDropShadowWithRoundCorner];
}

-(void) addDropShadowWithRoundCorner {
    // corner radius
    _loginContainerView.layer.cornerRadius = 10.0f;
    
    // border
    _loginContainerView.layer.borderWidth = 1.0f;
    _loginContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // shadow
    _loginContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _loginContainerView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    _loginContainerView.layer.shadowOpacity = 0.7f;
    _loginContainerView.layer.shadowRadius = 4.0f;
}


@end
