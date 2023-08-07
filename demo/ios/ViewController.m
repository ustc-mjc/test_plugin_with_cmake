//
//  ViewController.m
//  my_app
//
//  Created by mojucheng on 2023/5/5.
//

#import "ViewController.h"
#include "calculator/CalculatorApple.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel* label = [[UILabel alloc]init];
//    label.text = @"hello world";
//    [label sizeToFit];
//    label.center = self.view.center;
//    [self.view addSubview: label];
    self.versionLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 50)];
    self.versionLable.textAlignment = NSTextAlignmentCenter;
//    self.versionLable.center = self.view.center;
    // 将 UILabel 添加到视图中
    [self.view addSubview:self.versionLable];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 50, 100, 50);
    [button setTitle:@"获取版本" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

-(void)buttonTapped:(UIButton*)sender {
    NSLog(@"点击按钮");
    self.versionLable.text = [CalculatorApple getVersion];
}

@end
