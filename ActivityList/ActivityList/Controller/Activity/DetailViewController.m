//
//  DetailViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PurchaceTableViewController.h"
#import "ListViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate>
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
@property (strong, nonatomic) NSMutableArray *arr;
//@property(strong,nonatomic) CLLocation *location;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    //[self uiLayout];
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
            [self uiLayout];
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
    NSString *dueTimeStr=[Utilities dateStrFromCstampTime: _activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr=[Utilities dateStrFromCstampTime: _activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr=[Utilities dateStrFromCstampTime: _activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text=[NSString stringWithFormat:@"%@ ~ %@",startTimeStr,endTimeStr];
    _applyDueLbl.text=[NSString stringWithFormat:@"报名截止时间(%@)",dueTimeStr];
    NSDate *now=[NSDate date];
    NSTimeInterval nowTime=[now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor=[UIColor grayColor];
    if (nowTime>=_activity.dueTime) {
        _applyDueView.backgroundColor=[UIColor grayColor];
        _applyBtn.enabled=NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if(nowTime>=_activity.startTime){
           _applyIngView.backgroundColor=[UIColor grayColor];
            if (nowTime>=_activity.endTime) {
                _applyEndView.backgroundColor=[UIColor grayColor];
            }
        }
    }
    if (_activity.attendence>=_activity.limitation) {
        //禁用button按钮
        _applyBtn.enabled=NO;
        [_applyBtn setTitle:@"人数已满" forState:UIControlStateNormal];

    }
    switch (_activity.status) {
        case 0:{
            _applyStateLbl.text=@"已取消";
        }
            break;
        case 1:{
            _applyStateLbl.text=@"待付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            _applyStateLbl.text=@"已报名";
            _applyBtn.enabled=NO;
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            
        }
            break;
        case 3:{
            _applyStateLbl.text=@"退款中";
            _applyBtn.enabled=NO;
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
        }
            break;
        case 4:{
            _applyStateLbl.text=@"已退款";
        }
            break;

        default:{
            _applyStateLbl.text=@"待报名";
        }
            break;
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
////单击手势响应事件
//- (void)tapClick: (UITapGestureRecognizer *)tap{
//    
//    if(tap.state == UIGestureRecognizerStateRecognized){
//        
//        //NSLog(@"图片被单击了");
//        //拿到单击手势在_activityTableView中的位置
//        CGPoint location = [tap locationInView:_activityImgView];
//        //通过上述的点拿到在_activityTableView对应的indexPath
//        NSIndexPath *indexPath = [_activityImgView indexOfAccessibilityElement:location];
//        //防范
//        if (_arr != nil && _arr.count !=0){
//            ActivityModel *activity = _arr[indexPath.row];
//            //设置大图片的位置大小
//            _activityImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//            //用户交互启用
//            _activityImgView.userInteractionEnabled = YES;
//            _activityImgView.backgroundColor = [UIColor blackColor];
//            //_zoomIV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.imgUrl]]];
//            [_activityImgView sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"1"]];
//            //设置图片的内容模式
//            _activityImgView.contentMode = UIViewContentModeScaleAspectFit;
//            //获得窗口实例，并将大图放置到窗口实例上，根据苹果规则，后添加的控件会覆盖前添加的控件。
//            [[UIApplication sharedApplication].keyWindow addSubview:_activityImgView];
//            UITapGestureRecognizer *zoomIVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
//            [_activityImgView addGestureRecognizer:zoomIVTap];
//            
//        }
//    }
//}

- (void)zoomTap: (UITapGestureRecognizer *)tap{
    if(tap.state == UIGestureRecognizerStateRecognized){
        //把大图本身的东西扔掉（大图的手势）
        [_activityImgView removeGestureRecognizer:tap];
        //把自己从父级视图中移除
        [_activityImgView removeFromSuperview];
        //彻底消失（这样就不会造成内存的滥用）
        _activityImgView =nil;
        
    }
}

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //
    if ([Utilities loginCheck]) {
        PurchaceTableViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"Purchase"];
        //把ActivityModel的数据传给这个activity
        purchaseVC.activity=_activity;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        
    }else{
        //获取要跳转的页面实例
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //
    
    //配置电话App的路径，并将要拨打的号码组合到路径中
    NSString *targetAppStr=[NSString stringWithFormat:@"telprompt//%@",_activity.phone];
    NSURL *targetAppUrl=[NSURL URLWithString:targetAppStr];
    //从当前App跳转到其他指定的App中
    [[UIApplication sharedApplication] openURL:targetAppUrl];
}

@end
