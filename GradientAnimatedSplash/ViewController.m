//
//  ViewController.m
//  GradientAnimatedSplash
//
//  Created by nsugu on 18/07/18.
//  Copyright © 2018 NSK. All rights reserved.
//

#import "ViewController.h"
#import "GASSplashViewController.h"

@interface ViewController ()
@property (nonatomic) GASSplashViewController* splashViwController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,5.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showLoginScreen];
    });
}

- (void) showLoginScreen {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginScreenIdentifier"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
