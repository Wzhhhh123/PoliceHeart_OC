//
//  MainController.m
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "MainController.h"
#import "LoginController.h"
#import "ViewCommon.h"

#import "MYCycleView.h"
//#import <SystemConfiguration/CaptiveNetwork.h>
//#import <NetworkExtension/NetworkExtension.h>

#import "MQGuideView.h"


#import "BtnCell.h"
#import "MPageCell.h"

#import "ControllerOne.h"
#import "PersonController.h"
#import "OneDetController.h"
#import "WZListController.h"
#import "ZhuanjiaController.h"

#import "QWController.h"

@interface MainController ()<UITableViewDelegate,UITableViewDataSource,MQGuideViewDelegate,UITextFieldDelegate>{
    
    UITableView *_tableView;
    CGFloat secHig;
    CGFloat Khig;
    NSInteger _page;
    BOOL _isRefresh,setImage;
    UIButton *bacBtn;
    
    
    
}

@property (nonatomic, strong) MYCycleView *cycleView;
@property (nonatomic )NSMutableArray *dataArray;
@property (nonatomic )NSMutableArray *imageArray;
@property (nonatomic )NSMutableArray *wzArray;

@property (strong,nonatomic) MQGuideView *guideView;

@property (strong, nonatomic) IBOutlet UIView *secView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong, nonatomic) IBOutlet UIView *mindView;

@property (weak, nonatomic) IBOutlet UITextField *zhanghao;
@property (weak, nonatomic) IBOutlet UITextField *mima;

@property (weak, nonatomic) IBOutlet UIButton *kaishi;
@property (weak, nonatomic) IBOutlet UIButton *quxiao;
@property (strong, nonatomic) IBOutlet UIView *maskView;

@property ( nonatomic)  CGFloat NavHig;

@property (strong, nonatomic) IBOutlet UIView *mutHead;

@property (nonatomic ) NSMutableDictionary *userDic;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _NavHig=SCREEN_HEIGHT>800?83:64;
    self.navigationController.navigationBar.hidden=YES;
    secHig=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?160:160):160;
    Khig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?270:260):256;
    _userDic=[NSMutableDictionary new];
    setImage=YES;
    _imageArray =[NSMutableArray new];
    _wzArray =[NSMutableArray new];
    _dataArray =[NSMutableArray new];
    
    [self createHead];
    NSLog(@"kdkdk%f",SCREEN_HEIGHT);
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
 //      self.tabBarController.tabBar.hidden=YES;
//
//        _guideView = [[MQGuideView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        _guideView.delegate = self;
//        [self.view addSubview:_guideView];
//    }else{
    
        [self refresh];

        
        if([[DataDefault shareInstance]userInfor]==nil){
//            LoginController *pvc=[[LoginController alloc]init];
//            [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
//
//                [[DataDefault shareInstance]setUserInfor:useinf];
//                _userDic=[useinf mutableCopy];
//
//
//                [self refresh];
//
//
//            }];
//
//            [self.navigationController pushViewController:pvc animated:YES];
        }else{
            _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
            //  [self createTableView];

//            [self refresh];


        }
        
        
  //  }
    
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

- (void)onPassButtonPressed{
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _guideView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_guideView removeFromSuperview];
        self.tabBarController.tabBar.hidden=NO;

        //
        //        [self createPage];
        //
        //        [self createTableView];
        
        
        [self refresh];

        //        LoginController *pvc=[[LoginController alloc]init];
        //        [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
        //
        //            [self createTableView];
        //
        //        }];
        //
        //        [self presentViewController:pvc animated:YES completion:^{
        //
        //        }];
        //
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    开始轮播
    self.cycleView.second = 3;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];

//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]) {
//
//        self.tabBarController.tabBar.hidden=YES;
//
//    }else{
//        self.tabBarController.tabBar.hidden=NO;
//
//    }
    self.tabBarController.tabBar.hidden=NO;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    停止轮播
    self.cycleView.second = 0;
}


- (void)createMaskView{
    _maskView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _maskView.backgroundColor=RGBACOLOR(22, 22, 22, 0.6);
    [self.view addSubview:_maskView];
    
    _mindView.frame=CGRectMake(60*Rat, 140*Rat, SCREEN_WIDTH-120*Rat, (SCREEN_WIDTH-120*Rat)*33/73+182);
    [_maskView addSubview:_mindView];
    
    _quxiao.layer.borderWidth=1;
    _quxiao.layer.borderColor=RGBCOLOR(119, 187, 255).CGColor;
    
    _zhanghao.delegate=self;
    _mima.delegate=self;
    
    _maskView.hidden=YES;
    
}

- (void)selTest:(UIButton *)sender {
    
    if (sender.tag==3) {
        [self.navigationController pushViewController:[[ZhuanjiaController alloc]init] animated:YES];
    }else{
        
        ControllerOne *cone=[[ControllerOne alloc]init];
        if (sender.tag==0) {
            cone.kinStr=@"趣味测量";
            cone.userDic=[_userDic mutableCopy];
            
            [self.navigationController pushViewController:cone animated:YES];
        }else  if (sender.tag==1) {
            cone.kinStr=@"专业测量";
            cone.userDic=[_userDic mutableCopy];
            
            [self.navigationController pushViewController:cone animated:YES];
        }else  if (sender.tag==2) {
            cone.kinStr=@"定制测量";
            _maskView.hidden=NO;
        }
    }
}


- (IBAction)beginDingZhi:(UIButton *)sender {
    if (sender.tag==0) {
        if (_zhanghao.text.length>0) {
            if (_mima.text.length>0) {
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:_zhanghao.text forKey:@"ut_BH"];
                [dic setObject:_mima.text forKey:@"ut_Pwd"];

                AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
                manger.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                manger.requestSerializer.timeoutInterval = 20.f;
                [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeGradient];

                [manger GET:QYLogin parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    [SVProgressHUD showSuccessWithStatus:@"验证成功！"];

                    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  //   NSLog(@"文章列表%@",dic);
                    if ([dic[@"Status"] integerValue]==1) {
                        _maskView.hidden=YES;
                        _zhanghao.text=nil;
                        _mima.text=nil;
                        
                        QWController *cone=[[QWController alloc]init];
                        cone.kinStr=@"定制测量";
                        cone.userDic=[_userDic mutableCopy];
                        cone.testDic=[dic[@"Data"] mutableCopy];
                        cone.testPapper_id=[dic[@"Data"] mutableCopy];

                        
                        [self.navigationController pushViewController:cone animated:YES];
           
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"验证失败！"];
                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    [SVProgressHUD showErrorWithStatus:@"验证失败！"];

                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"密码不能为空！"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"账号不能为空！"];
        }
    }else{
        _maskView.hidden=YES;

        _zhanghao.text=nil;
        _mima.text=nil;
    }
    [_zhanghao resignFirstResponder];
    [_mima resignFirstResponder];
}

#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}





- (IBAction)moreNews:(id)sender {
    
    WZListController *wbvc=[[WZListController alloc]init];
    wbvc.userDic=[_userDic mutableCopy];
    
    [self.navigationController pushViewController:wbvc animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr=@[@"趣味测量",@"专业测量",@"定制测量",@"专家介绍"];
    NSArray *icon=@[@"quweiceliang.png",@"zhuanye.png",@"dingzhi.png",@"zhuanjia.png"];
    _secView.frame=CGRectMake(0, 0, SCREEN_WIDTH, secHig);

    for (int i=0; i<4; i++) {
        UIButton *bacBtn1=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-38*4)/5+((SCREEN_WIDTH-38*4)/5+38)*i, 24, 38, 29)];
        [bacBtn1 setImage:[UIImage imageNamed:icon[i]] forState:UIControlStateNormal];
        [bacBtn1 setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
        bacBtn1.titleLabel.font=[UIFont systemFontOfSize:15];
        bacBtn1.tag=i;
        [bacBtn1 addTarget:self action:@selector(selTest:) forControlEvents:UIControlEventTouchUpInside];
        [_secView addSubview:bacBtn1];
        
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-38*4)/10+((SCREEN_WIDTH-38*4)/5+38)*i, 60, (SCREEN_WIDTH-38*4)/5+38, 30)];
        lab.text=arr[i];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=RGBCOLOR(10, 10, 10);
        lab.font=[UIFont systemFontOfSize:15];
        [_secView addSubview:lab];
    }
    
    
    
    
    
    //    _moreBtn.layer.masksToBounds=YES;
    //    _moreBtn.layer.cornerRadius=6;
    //    _moreBtn.layer.borderColor=RGBCOLOR(0, 0, 255).CGColor;
    //    _moreBtn.layer.borderWidth=1;
    
    
    return _secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return secHig;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataArray.count;
    // return  8;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OneDetController *wbvc=[[OneDetController alloc]init];
    
    wbvc.inf=[_dataArray[indexPath.row] mutableCopy];
    wbvc.userDic=[_userDic mutableCopy];
    wbvc.intage=indexPath.row;
    wbvc.lm_ObjId=_dataArray[indexPath.row][@"id"];

    wbvc.kinStr=1;

    [wbvc setActionDianZan:^(NSMutableDictionary *infDic, NSInteger indx) {
        
        [_dataArray replaceObjectAtIndex:indx withObject:infDic];
        [_tableView reloadData];
    }];

    [self.navigationController pushViewController:wbvc animated:YES];
    
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(255, 255, 255);
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"BtnCell" bundle:nil] forCellReuseIdentifier:@"BtnCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"MPageCell" bundle:nil] forCellReuseIdentifier:@"MPageCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView  addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterRefreshingText:@"加载更多..."];
    
    
    
    
   // NSLog(@"djdjdj%d",_imageArray.count);
    self.cycleView = [[MYCycleView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 190*Rat)];
    //    当imageArray.cout为1时，不轮播，相当于imageView;
    self.cycleView.imageArray = _imageArray;
    //    设置轮播时间，小于0时逆向，大于0时正向，等于0是不自动轮播
    self.cycleView.second = -3;
    ////    设置pageControl未选中indicator的颜色
    //    self.cycleView.pageIndicatorColor = [UIColor grayColor];
    ////    设置pageControl当前indicator的颜色
    //    self.cycleView.currentIndicatorColor = [UIColor redColor];
    
    __block MainController *  blockSelf = self;
    
    self.cycleView.bannerClick = ^(NSInteger index) {
        
        //NSLog(@"点击了%zd",index);
        OneDetController *wbvc=[[OneDetController alloc]init];
        
        wbvc.inf=[_wzArray[index] mutableCopy];
        wbvc.intage=index;
        wbvc.lm_ObjId=_dataArray[index][@"id"];
        wbvc.userDic=[_userDic mutableCopy];

        wbvc.kinStr=1;
        [blockSelf.navigationController pushViewController:wbvc animated:YES];
        
        
    };
    
    _tableView.tableHeaderView=self.cycleView;
    
    CGFloat higf=SCREEN_HEIGHT>800?34:0;

    
    bacBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-100-higf, 40, 40)];
    [bacBtn setImage:[UIImage imageNamed:@"zhiding.png"] forState:UIControlStateNormal];
    [bacBtn addTarget:self action:@selector(backHead) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bacBtn];
    bacBtn.hidden=YES;
    
    [self createMaskView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>0) {
        bacBtn.hidden=NO;

    }else{
        
        bacBtn.hidden=YES;

    }
}



- (void)backHead{
    bacBtn.hidden=YES;

    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MPageCell"];
    
    [cell setInfo:_dataArray[indexPath.row]];
    
    cell.tag=indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Khig;
}

-(void)refresh{
    _page=1;
    _isRefresh=YES;
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
        [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];
        
    }else{
        
        [dic setValue:@"ios " forKey:@"au_RegistrationId"];
        
    }
    [self loadData:dic];
    
}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
        [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];

    }else{
        
        [dic setValue:@"ios " forKey:@"au_RegistrationId"];

    }

    
    [self loadData:dic];
    
}


- (void)loadData:(NSMutableDictionary *)diccct{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //[manger.requestSerializer setValue:[NSString stringWithFormat:@"BasicAuth%@",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Basic%@%@",@" ",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    [manger GET:WZList parameters:diccct success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (_isRefresh) {
            [_dataArray removeAllObjects];
        }
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"文章列表%@",dic);
        
        
        if ([dic[@"Message"] isEqualToString:@"OK"]) {
            NSMutableArray *dict=dic[@"result"];
            if (dict.count>0) {
                if (setImage) {
                    setImage=NO;
                    
                    if (dict.count>5) {
                        for (int i=0; i<5; i++) {
                            [_imageArray addObject:[NSString stringWithFormat:@"%@/%@",ImageHOST,dict[i][@"a_ImgUrl"]]];
                            [_wzArray addObject:dict[i]];
                        }
                    }else{
                        for (int i=0; i<dict.count; i++) {
                            [_imageArray addObject:[NSString stringWithFormat:@"%@/%@",ImageHOST,dict[i][@"a_ImgUrl"]]];
                            [_wzArray addObject:dict[i]];
                        }
                    }
                    
                    [self createTableView];
                    
                }
                
                
                [_dataArray addObjectsFromArray:dict];
                _page++;
                _isRefresh=NO;
                [_tableView reloadData];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"暂无数据！"];
                
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"无更多数据！"];
            
        }
        
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}




- (IBAction)personalInfor:(UIButton *)sender {
    
    PersonController *cone=[[PersonController alloc]init];
    
    [self.navigationController pushViewController:cone animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
