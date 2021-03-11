//
//  ViewController.m
//  UISearchController-Example
//
//  Created by chuimanlong on 2017/10/11.
//  Copyright © 2017 CHUI MANLONG. All rights reserved.
//

#import "ViewController.h"
#import "CMLSearchController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnClick:(id)sender {
    
    CMLSearchController *vc = [[CMLSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
