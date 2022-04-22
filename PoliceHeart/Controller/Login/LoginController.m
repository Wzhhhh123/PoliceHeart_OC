//
//  LoginController.m
//  Elevator
//
//  Created by Tcy on 2017/10/31.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "LoginController.h"
#import "ViewCommon.h"
#import "SVProgressHUD.h"
#import "ResignController.h"

@interface LoginController ()<UITextFieldDelegate>{
    CGFloat hhig,chig,wid;
}

@property (strong, nonatomic) IBOutlet UIView *logoView;

@property (strong, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (strong, nonatomic) IBOutlet UIView *sureView;
@property (weak, nonatomic) IBOutlet UIButton *RESBTN;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    _NavHig=SCREEN_HEIGHT>800?83:64;
    
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
    [self createLoginView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)createLoginView{
    
    chig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?100:95):90;
    wid=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?60:60):50;
    hhig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?30:20):10;
    
    _logoView.frame=CGRectMake(0, _NavHig+16, SCREEN_WIDTH, 180*Rat);
    
    [self.view addSubview:_logoView];
    
    CGFloat shig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?150:145):140;

    _countView.frame=CGRectMake(wid/2, _NavHig+16+180*Rat+hhig, SCREEN_WIDTH-wid, chig);
//    _countView.layer.shadowColor=[UIColor grayColor].CGColor;
//    _countView.layer.shadowOffset=CGSizeMake(0, 1);
//    _countView.layer.shadowOpacity=0.8;
//    _countView.layer.shadowRadius=3.f;
    [self.view addSubview:_countView];

    
    
//    UIImage *im = [UIImage imageNamed:@"name.png"];
//    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
//    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
//    lv.backgroundColor = [UIColor clearColor];
//    iv.center = lv.center;
//    [lv addSubview:iv];
//    _phone.leftViewMode = UITextFieldViewModeAlways;
//    _phone.leftView = lv;
    _phone.delegate = self;
    
//    UIImage *pa = [UIImage imageNamed:@"pass.png"];
//    UIImageView *pav = [[UIImageView alloc] initWithImage:pa];
//    UIView *pv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
//    pv.backgroundColor = [UIColor clearColor];
//    pav.center = pv.center;
//    [pv addSubview:pav];
//    _pass.leftViewMode = UITextFieldViewModeAlways;
//    _pass.leftView = pv;
    _pass.delegate = self;
    
    _sureView.frame=CGRectMake(wid/2, SCREEN_HEIGHT/2+70*Rat, SCREEN_WIDTH-wid, shig);
    [self.view addSubview:_sureView];
    _RESBTN.layer.borderWidth=1;
    _RESBTN.layer.borderColor=RGBCOLOR(103, 155, 244).CGColor;
    _RESBTN.layer.masksToBounds=YES;
    _RESBTN.layer.cornerRadius=4;
    
//    NSArray *iconArr=@[@"qq.png",@"weixin.png",@"duanxin.png"];
//
//    for (int i=0; i<3; i++) {
//        UIButton *bacBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25*Rat+(50*Rat+20)*(i-1), SCREEN_HEIGHT-50*Rat-10, 50*Rat, 50*Rat)];
//        [bacBtn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
//        bacBtn.tag=i;
//        [bacBtn addTarget:self action:@selector(loginPass:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:bacBtn];
//    }
    
    
}

- (void)loginPass:(UIButton *)btn{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==_phone) {
      //  [_phone resignFirstResponder];
        [_pass becomeFirstResponder];
        
        
    }
    if (textField==_pass) {
        [_pass resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _countView.frame=CGRectMake(wid/2, 80+180*Rat+hhig, SCREEN_WIDTH-wid, chig);
            
        } completion:^(BOOL finished) {
            [self loginContent];

        }];
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
        _countView.frame=CGRectMake(wid/2, 80+180*Rat, SCREEN_WIDTH-wid, chig);
        
    }];
    return YES;
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}



- (IBAction)resignCount:(UIButton *)sender {
    
    ResignController *res=[[ResignController alloc]init];
    if (sender.tag==0) {
        res.kinStr=@"用户注册";
    }else{
        res.kinStr=@"找回密码";
    }
    [res setResetSuccess:^(NSString *phone) {
        _phone.text=phone;
    }];
    
    [self.navigationController pushViewController:res animated:YES];
}

- (IBAction)login:(id)sender {
    [self loginContent];
}

- (void)loginContent{
    
    [_phone resignFirstResponder];
    [_pass resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _countView.frame=CGRectMake(wid/2, 80+180*Rat+hhig, SCREEN_WIDTH-wid, chig);
        
    }];
    
    if ([_phone.text length]>0&&[_pass.text length]>0) {
        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_phone.text forKey:@"strUser"];
        [dict setObject:_pass.text forKey:@"strPwd"];
        [dict setObject:@"ios" forKey:@"strType"];
        
        if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"]] length]>0) {
            [dict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"]] forKey:@"au_RegistrationId"];//极光码
            
        }else{
            [dict setObject:@"ios" forKey:@"au_RegistrationId"];//极光码
            
        }
        
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manger.requestSerializer.timeoutInterval = 20.f;
        [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manger GET:LoginUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"ssss%@",dic);
            if ([dic[@"bRes"] intValue]==10000) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功！"];
                
                [dic setValue:_pass.text forKey:@"au_Password"];
                if (self.actionLoginSuccess) {
                    self.actionLoginSuccess(dic);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"登录失败！"];
            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"密码或账号不能为空"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
