//
//  ViewController.m
//  my_app
//
//  Created by mojucheng on 2023/5/5.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel* label = [[UILabel alloc]init];
    label.text = @"hello world";
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview: label];
}


@end
