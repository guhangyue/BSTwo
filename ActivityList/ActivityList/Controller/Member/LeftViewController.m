//
//  LeftViewController.m
//  ActivityList
//
//  Created by IMAC on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "LeftViewController.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LeftViewController ()

@property(strong,nonatomic) NSArray * arr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiLayout];
    [self dataInitialize];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden=YES;
        _usernameLbl.hidden=NO;
        
        UserModel*user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"Avatar"]];
        _usernameLbl.text=user.nickname;
    }else{
        //未登录
        _loginBtn.hidden=YES;
        _usernameLbl.hidden=NO;
        
        _avatarImgView.image=[UIImage imageNamed:@"Avatar"];
        _usernameLbl.text = @"游客";
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uiLayout
{
    _avatarImgView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
}
-(void)dataInitialize
{
    _arr=@[@"我的活动",@"我的推广",@"积分中心",@"意见反馈",@"关于我们"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return _arr.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        
        
        cell.textLabel.text=_arr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50.f;
    }
    else{
        return UI_SCREEN_H-500;
        //return UI_SCREEN_H-170-80-50*5;   等于屏幕高度减去500
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        if ([Utilities loginCheck]) {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self performSegueWithIdentifier:@"Let2MyAct" sender:self];
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        UINavigationController*signNavi=[Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
 
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转的页面实例
    UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
    //执行跳转
    [self presentViewController:signNavi animated:YES completion:nil];

}

- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        //return 50.f;
    }else{
    UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
    //执行跳转
    [self presentViewController:signNavi animated:YES completion:nil];
    }
}
@end
