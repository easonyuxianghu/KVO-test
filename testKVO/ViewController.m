//
//  ViewController.m
//  Test-KVO
//
//  Created by Yuxhu on 12/19/17.
//  Copyright © 2017 sheng. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tapButton {
    MyViewController *controller = [[MyViewController alloc] init];
    [self presentViewController:controller animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
