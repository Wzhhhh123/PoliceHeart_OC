//
//  ResignController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/9.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ResignController.h"

@interface ResignController ()<UITextFieldDelegate>{
    CGFloat hhig,chig,wid;
    BOOL isGet;
   // NSString *codeStr;
    NSInteger i;
}

@property (strong, nonatomic) IBOutlet UIView *logoView;

@property (strong, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codBtn;

@property (strong, nonatomic) IBOutlet UIView *sureView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *passLab;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation ResignController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titLab.text=self.kinStr;
    isGet=NO;
    i=60;
    _NavHig=SCREEN_HEIGHT>800?83:64;
    
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
    if ([self.kinStr isEqualToString:@"用户注册"]) {
        _passLab.text=@"登录密码";
    }else{
        _passLab.text=@"设置密码";
    }
    [self createLoginView];
}



- (void)createLoginView{
    
    chig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?140:135):130;
    wid=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?60:60):50;
    hhig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?30:20):10;
    _logoView.frame=CGRectMake(0, 80, SCREEN_WIDTH, 180*Rat);
    
    CGFloat shig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?145:140):135;
    
    [self.view addSubview:_logoView];
    
    _countView.frame=CGRectMake(wid/2, _NavHig+16+180*Rat+hhig, SCREEN_WIDTH-wid, chig);

    [self.view addSubview:_countView];

    _phone.delegate = self;

    _pass.delegate = self;
    _code.delegate = self;
    
    _sureView.frame=CGRectMake(wid/2, SCREEN_HEIGHT/2+80*Rat, SCREEN_WIDTH-wid, shig);
    [self.view addSubview:_sureView];
    
}

- (IBAction)getCode:(UIButton *)sender {
    
    
    
    
    if (_phone.text.length==11) {
        [self openCountdown];

        [self getGodeText];
    }else{
        [SVProgressHUD showErrorWithStatus:@"电话号有误！"];

    }

}


-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.codBtn setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
                self.codBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.codBtn setTitle:[NSString stringWithFormat:@"%.2d s", seconds] forState:UIControlStateNormal];
                [self.codBtn setTitleColor:RGBCOLOR(151, 200, 255) forState:UIControlStateNormal];
                self.codBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


- (void)getGodeText{
    NSString *urlStr;
    if ([self.kinStr isEqualToString:@"用户注册"]) {
        urlStr=[NSString stringWithFormat:@"%@",ZCCode];
    }else{
        urlStr=[NSString stringWithFormat:@"%@",ResetCode];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_phone.text forKey:@"phoneNumbers"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:urlStr parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"Status"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功！"];
  
           // codeStr=[NSString stringWithFormat:@"%@",dic[@"Message"]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败！"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败！"];
    }];

}



- (IBAction)login:(id)sender {
    [_phone resignFirstResponder];
    [_pass resignFirstResponder];
    [_code resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _countView.frame=CGRectMake(wid/2, 80+180*Rat+hhig, SCREEN_WIDTH-wid, chig);
        
    }];
    
    if ([_phone.text length]>0&&[_pass.text length]>0) {
        
        if ([_code.text length]>0) {
            [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeGradient];
            
            NSString *urlStr;
            if ([self.kinStr isEqualToString:@"用户注册"]) {
                urlStr=[NSString stringWithFormat:@"%@",ZCSend];
            }else{
                urlStr=[NSString stringWithFormat:@"%@",ResetSend];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_phone.text forKey:@"au_Phone"];
            [dict setObject:_pass.text forKey:@"au_Password"];
            [dict setObject:_code.text forKey:@"strCode"];
            
            
            
            AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
            manger.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manger.requestSerializer.timeoutInterval = 20.f;
            [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manger GET:urlStr parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
               // NSLog(@"ssss%@",dic);

                if ([self.kinStr isEqualToString:@"用户注册"]) {
                    if ([dic[@"Code"] intValue]==10000) {
                            [SVProgressHUD showSuccessWithStatus:@"注册成功！"];

                        if (self.ResetSuccess) {
                            self.ResetSuccess(_phone.text);
                        }
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                            [SVProgressHUD showErrorWithStatus:dic[@"Message"]];

                    }
                    
                }else{
                    if ([dic[@"Code"] intValue]==10000) {
                            [SVProgressHUD showSuccessWithStatus:@"重置成功！"];
                        if (self.ResetSuccess) {
                            self.ResetSuccess(_phone.text);
                        }
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{

                        [SVProgressHUD showErrorWithStatus:dic[@"Message"]];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                if ([self.kinStr isEqualToString:@"用户注册"]) {
                    [SVProgressHUD showErrorWithStatus:@"注册失败！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"重置失败！"];
                }            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"密码或账号不能为空"];
    }
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _countView.frame=CGRectMake(wid/2, 80+180*Rat+hhig, SCREEN_WIDTH-wid, chig);
            
        }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
