//
//  ViewController.m
//  heartDetection
//
//  Created by hundred wang on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "ViewController.h"
#import "HeartDetectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HeartDetectionView *view = [[HeartDetectionView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view startDetection];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
