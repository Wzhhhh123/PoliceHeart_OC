//
//  QWController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/12.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "QWController.h"
#import "CeshiController.h"

@interface QWController ()
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *textTit;
@property (weak, nonatomic) IBOutlet UILabel *subTit;
@property (weak, nonatomic) IBOutlet UILabel *unitDis;
@property (weak, nonatomic) IBOutlet UIImageView *picIma;
@property (weak, nonatomic) IBOutlet UITextView *disTit;

//@property (strong, nonatomic) IBOutlet UIView *mutHead;

//@property ( nonatomic)  CGFloat NavHig;

@end

@implementation QWController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titLab.text=self.kinStr;
   // _NavHig=SCREEN_HEIGHT>800?83:64;

    if ([self.kinStr isEqualToString:@"定制测量"]) {
        _unitDis.text=[NSString stringWithFormat:@"测量单位:%@\n时间:%@至%@",_testDic[@"c_Name"],_testDic[@"cp_BeginTime"],_testDic[@"cp_EndTime"]];
        
        [self setinf:self.testDic];

       // [self getTestPaper:self.testDic[@"id"]];

    }else{
        _unitDis.hidden=YES;
        [self getTestPaper:self.testPapper_id];

    }
   // NSLog(@"hshshshs%@",_testDic);
    
//    if (_enter==1) {
//       // [self getTestPaper:self.testDic[@"id"]];
//
//    }else{
//
//       // [self getTestPaper:self.testDic[@"tp_id"]];
//
//    }
    

    
}
//- (void)createHead{
//    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
//    [self.view addSubview:_mutHead];
//
//}
- (void)getTestPaper:(NSString *)tpid{
    NSMutableDictionary *dicd=[NSMutableDictionary new];
    [dicd setObject:tpid forKey:@"tp_id"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //[manger.requestSerializer setValue:[NSString stringWithFormat:@"BasicAuth%@",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Basic%@%@",@" ",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    [manger GET:SJXX parameters:dicd success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        if ([dict[@"Message"] isEqualToString:@"OK"]) {

            self.testDic=[dict[@"result"][0] mutableCopy];
            [self setinf:self.testDic];

        }else{
            [SVProgressHUD showErrorWithStatus:@"无更多数据！"];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
    
}

- (void)setinf:(NSMutableDictionary *)dic{
    self.textTit.text=dic[@"tp_Name"];
    self.subTit.text=[NSString stringWithFormat:@"题数:%@  平均用时:%@分钟  已完成人数:%@",dic[@"tp_Counts"],dic[@"tp_Long"],dic[@"tp_TestCount"]];
    self.disTit.text=dic[@"tp_Description"];
    [self.picIma setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"tp_BigImgUrl"]]]];


}

- (IBAction)shareAndBack:(UIButton *)sender {
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;

    
}

- (IBAction)beginTest:(id)sender {
    CeshiController *cvc=[[CeshiController alloc]init];
    cvc.enter=self.enter;

    cvc.kinStr=self.kinStr;
    cvc.userDic=[_userDic mutableCopy];
    cvc.testDic=[self.testDic mutableCopy];
    cvc.testPapper_id=self.testPapper_id ;

    [self.navigationController pushViewController:cvc animated:YES];
    
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
