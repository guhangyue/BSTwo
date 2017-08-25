//
//  DetailViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeelbl;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attendenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueView;
@property (weak, nonatomic) IBOutlet UIView *applyIngView;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property(strong,nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    // Do any additional setup after loading the view.
}
//每次来到该页面执行一次

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = _activity.name;
    //设置导航条颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏.
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void)networkRequest{
    _aiv=[Utilities getCoverOnView:self.view];
    NSString *request= [NSString stringWithFormat:@"/event/%@",_activity.activityId];
    //可变字典
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    if ([Utilities loginCheck]) {
        [parameters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"] forKey:@"memberId"];
    }
    
    [RequestAPI requestURL:request withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
         [_aiv stopAnimating];
       // NSLog(@"");
        if ([responseObject[@"resultFlag" ]integerValue]==8001) {
            NSDictionary *result =responseObject[@"result"];
            _activity=[[ActivityModel alloc]initWithDetialDictionary:result];
        }else{
            
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
-(void)uiLayout{
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"image"]];
    _applyFeelbl.text=[NSString stringWithFormat:@"%@元",_activity.applyFee];
    _attendenceLbl.text=[NSString stringWithFormat:@"%@/%@",_activity.attendence,_activity.limitation];
    _typeLbl.text=_activity.type;
    _issuerLbl.text=_activity.issuer;
    
    _addressLbl.text=_activity.address;
    _contentLbl.text=_activity.content;
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者：%@",_activity.phone] forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

@end
