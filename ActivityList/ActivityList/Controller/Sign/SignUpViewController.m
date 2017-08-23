//
//  SignUpViewController.m
//  ActivityList
//
//  Created by IMAC on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
- (IBAction)clickAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)clickAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
