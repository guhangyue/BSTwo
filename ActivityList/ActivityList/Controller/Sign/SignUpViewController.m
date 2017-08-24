//
//  SignUpViewController.m
//  ActivityList
//
//  Created by IMAC on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//


#import "SignUpViewController.h"
#import "registrationModel.h"
@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
- (IBAction)clickAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *registrationBtn;
@property(strong,nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self judgment];
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
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)readyForEncoding
{
    _aiv=[Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/login/getKey" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject)
     {
         //NSLog(@"responseObject":%@,responseObject);
         if ([responseObject[@"resultFlag"]integerValue]==8001)
         {
             NSDictionary *result=responseObject[@"result"];
             NSString *modulus = result[@"modulus"];
             NSString *exponent = result[@"exponent"];
             //对内容进行MD5加密
             NSString *md5Str=[_passWordTextField.text getMD5_32BitString];
             
             
             //用模数和指数对MD5密码进行加密过后的密码进行加密   categary
             NSString *rsaStr=[NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
             [self signInWithEncryptPwd:rsaStr];
         }else{
             [_aiv stopAnimating];
             NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
             [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
         }
     }failure:^(NSInteger statusCode, NSError *error) {
         [_aiv stopAnimating];
         //业务逻辑失败的情况下
         [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
     }];
    
}
-(void)signInWithEncryptPwd:(NSString *)encryptPwd
{
    NSDictionary *parameter = @{@"userTel" : _userNameTextField.text, @"userPwd" : _passWordTextField.text,@"nickname": _nickNameTextField.text,@"nums":_verificationTextField.text};
    [RequestAPI requestURL:@"/register" withParameters:parameter andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
                NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result=responseObject[@"result"];
            registrationModel *user=[[registrationModel alloc]initWithDictionary:result];
            //将用户获取到的信息打包存储到单例化全局变量
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            //单独将用户的ID也存储进去单例化全局变量中来作为用户是否已经登录的判断依据，同时也方便其他所有的页面更快捷的使用用户ID这个参数
            [[StorageMgr singletonStorageMgr]addKey:@"userTel" andValue:user.userTel];
            //如果键盘还开着 就让他收回去
            [self.view endEditing:YES];
            //清空密码输入框的内容
            _passWordTextField.text=@"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_userNameTextField.text];
            //用model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}

- (IBAction)clickAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"111");
    if (_confirmPwdTextField.text == _passWordTextField.text ) {
        [self readyForEncoding];
    }
    else {
        [Utilities popUpAlertViewWithMsg:@"两次输入密码不一致" andTitle:@"提示" onView:self];
    }
}

- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
