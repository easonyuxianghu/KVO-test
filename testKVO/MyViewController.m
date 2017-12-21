//
//  MyViewController.m
//  Test-KVO
//
//  Created by Yuxhu on 12/19/17.
//  Copyright © 2017 sheng. All rights reserved.
//

#import "MyViewController.h"
#import "KeyValueObserver.h"
#import "RuntimeHelpers.h"
#import "SJObserverHelper.h"
#import "Observer.h"

@interface MyViewController ()
@property (nonatomic, strong) Observer *observer;
@end

@implementation MyViewController

- (void)dealloc {
    printf("dealloc\n");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [button setTitle:@"Update" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *removeObserverButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
    [removeObserverButton setTitle:@"Remove" forState:UIControlStateNormal];
    removeObserverButton.backgroundColor = UIColor.greenColor;
    [removeObserverButton addTarget:self action:@selector(tapRemoveObserverButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeObserverButton];

    //exit button
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 400, 50, 50)];
    [exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    exitButton.backgroundColor = UIColor.redColor;
    [exitButton addTarget:self action:@selector(tapExitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    
    //SJObserverHelper
//    [self sj_addObserver:self forKeyPath:@"firstName"];
    _observer = [Observer new];
    [self sj_addObserver:self.observer forKeyPath:@"firstName"];
    //try addobserver manually
//    [self addObserver:self.observer forKeyPath:@"firstName" options:NSKeyValueObservingOptionNew context:nil];

    //keyValueObserver
//    [self addKeyValueObserverWithSelector:@selector(myObserveValueForKeyPath:ofObject:change:context:) forObject:self keyPath:SELSTR(firstName) options:NSKeyValueObservingOptionNew];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)myObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateUI];
}

- (void)updateUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    label.backgroundColor = UIColor.whiteColor;
    label.tintColor = UIColor.blueColor;
    label.text = self.firstName;
    [self.view addSubview:label];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateUI];
}

- (void)tapButton {
    printf("press button \n");
    self.firstName = @"Changed first name";
}

- (void)tapRemoveObserverButton {
    printf("press removeObserverButton \n");
//    [self removeObserver:self forKeyPath:@"firstName"];
    [self removeObserver:self.observer forKeyPath:@"firstName"];
}

- (void)tapExitButton {
    printf("press exit button \n");
    [self dismissViewControllerAnimated:self completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
