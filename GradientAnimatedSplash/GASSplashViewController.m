//
//  GASSplashViewController.m
//  GradientAnimatedSplash
//
//  Created by nsugu on 18/07/18.
//  Copyright © 2018 NSK. All rights reserved.
//

#import "GASSplashViewController.h"
#import "GASAnimatedULogoView.h"

@interface GASSplashViewController ()

@property (weak, nonatomic) IBOutlet GASAnimatedULogoView *animatedLogoView;
@property (nonatomic) GASAnimatedULogoView* animatedLogoViewObject;

@end

@implementation GASSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _animatedLogoViewObject = [[GASAnimatedULogoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
    [self.view addSubview:_animatedLogoViewObject];
    _animatedLogoViewObject.layer.position = self.view.layer.position;
    [_animatedLogoViewObject startAnimating];
}
@end
