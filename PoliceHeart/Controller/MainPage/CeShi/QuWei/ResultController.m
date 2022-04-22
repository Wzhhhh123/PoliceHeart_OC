//
//  ResultController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/16.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ResultController.h"
#import "EvaluateCell.h"
#import "ControllerOne.h"
#import "QWController.h"
#import "MainController.h"

#import <Social/Social.h>
#import "LoginController.h"
#import "ReportController.h"

#import "WoDeCLController.h"


#import "ReplyCell.h"

#import "MasageController.h"

@interface ResultController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSString *resultStr;
    //CGFloat cHig;
    NSInteger _page;
    BOOL _isRefresh;
    CGFloat headHig;
    
}
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (strong, nonatomic) IBOutlet UIView *jieguo;




@property (strong, nonatomic) IBOutlet UIView *plView;
@property (weak, nonatomic) IBOutlet UITextField *plField;

@property (weak, nonatomic) IBOutlet UIButton *dzBtn;
@property (strong, nonatomic) IBOutlet UIView *maskView;

@property (strong, nonatomic) IBOutlet UIView *qwfoot;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;
@property (strong, nonatomic) IBOutlet UIView *baogaoView;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;

@property (weak, nonatomic) IBOutlet UIWebView *webDet;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray new];
    
    headHig=200;
    _NavHig=SCREEN_HEIGHT>800?83:64;
    [self createHead];
    [self createTableView];
    
    [self getResultData];
    
    _titLab.text=self.kinStr;
    
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    

}
- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}
- (void)getResultData{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    [dic setObject:self.AnsId forKey:@"id"];
    
    [self loadData:dic];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [_webDet.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    [_webDet.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)setsecData{
    
    
    _webDet.delegate=self;
    
    [_webDet loadHTMLString:resultStr baseURL:nil];
    
    _webDet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[_webDet.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [SVProgressHUD showWithStatus:@"结果加载中..."  maskType:SVProgressHUDMaskTypeGradient];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    
    [_webDet stringByEvaluatingJavaScriptFromString:str];
    [SVProgressHUD showSuccessWithStatus:@"加载完成！"];
    _webDet.scrollView.scrollEnabled = NO;
    
    [self freshLiuYan];
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGPoint point = [change[@"new"] CGPointValue];
        
        //  CGFloat height = point.y;
        // NSLog(@"point.y---%f",height);
        
        CGSize fittingSize = [_webDet sizeThatFits:CGSizeZero];
        
        CGFloat webHeight = fittingSize.height;
        
        headHig=webHeight+108;
        
        [_tableView reloadData];
        
    }
}


- (void)loadData:(NSMutableDictionary *)dict{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [SVProgressHUD showWithStatus:@"结果获取中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    [manger GET:ResultUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"\\\\\\\\\\\\-----%@",dict);
        
        if ([dict[@"Status"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功!"];
            
            resultStr=[NSString stringWithFormat:@"%@",dict[@"Data"][@"ua_Brief"]];
            self.testDic =[dict[@"Data"] mutableCopy];
            
            self.kinStr=[NSString stringWithFormat:@"%@",dict[@"Data"][@"tp_Type"]];
            self.testPapper_id=[NSString stringWithFormat:@"%@",dict[@"Data"][@"tp_id"]];
            [self createFootView];
            [self setsecData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"结果获取失败！"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"结果获取失败！"];
        
    }];
}


- (void)freshLiuYan{
    
    _page=1;
    _isRefresh=YES;
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setObject:self.AnsId forKey:@"ua_id"];
    
    [self loadLiuYanData:dic];
    
}

- (void)MoreLiuYan{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setObject:self.AnsId forKey:@"ua_id"];
    
    [self loadLiuYanData:dic];
    
}

- (void)loadLiuYanData:(NSMutableDictionary *)dict{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:LiuYanLBUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
      //  NSLog(@"\\\\留言-----%@",dict);
        
        if (_isRefresh) {
            [_dataArray removeAllObjects];
        }
        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            //[SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            _page++;
            _isRefresh=NO;
            
            for (NSDictionary *diccc in dict[@"result"]) {
                [_dataArray addObject:diccc];
            }
            
            [_tableView reloadData];
        }else{
            
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"留言获取失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}




- (IBAction)testResult:(UIButton *)sender {
    if (_enter==4) {
        
        if(sender.tag==0) {
            QWController *wbvc=[[QWController alloc]init];
            wbvc.enter=self.enter;
            wbvc.kinStr=self.kinStr;
            // wbvc.testDic=[_testDic mutableCopy];
            
            wbvc.testPapper_id=self.testPapper_id ;
            
            wbvc.userDic=[_userDic mutableCopy];
            
            [self.navigationController pushViewController:wbvc animated:YES];
            
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MasageController class]]) {
                    MasageController *revise =(MasageController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        }
    }else if (_enter==3) {
        if(sender.tag==0) {
            QWController *wbvc=[[QWController alloc]init];
            wbvc.enter=self.enter;
            wbvc.kinStr=self.kinStr;
           // wbvc.testDic=[_testDic mutableCopy];
            
            wbvc.testPapper_id=self.testPapper_id ;

            wbvc.userDic=[_userDic mutableCopy];
            
            [self.navigationController pushViewController:wbvc animated:YES];
            
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WoDeCLController class]]) {
                    WoDeCLController *revise =(WoDeCLController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        }
    }else if (_enter==2) {
        if(sender.tag==0) {
            QWController *wbvc=[[QWController alloc]init];
            wbvc.enter=self.enter;
            wbvc.kinStr=self.kinStr;
            //wbvc.testDic=[_testDic mutableCopy];
            wbvc.testPapper_id=self.testPapper_id ;

            wbvc.userDic=[_userDic mutableCopy];
            
            [self.navigationController pushViewController:wbvc animated:YES];
            
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ReportController class]]) {
                    ReportController *revise =(ReportController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        }
    }else{
        if(sender.tag==0) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[QWController class]]) {
                    QWController *revise =(QWController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ControllerOne class]]) {
                    ControllerOne *revise =(ControllerOne *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }
    }
    
}

- (IBAction)getBaogao:(id)sender {
    if (_userDic==nil) {
        
        LoginController *pvc=[[LoginController alloc]init];
        [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
            [[DataDefault shareInstance]setUserInfor:useinf];
            _userDic=[useinf mutableCopy];
            
            
            
            
        }];
        
        [self.navigationController pushViewController:pvc animated:YES];
        
    }else{
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manger.requestSerializer.timeoutInterval = 20.f;
        [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manger POST:[NSString stringWithFormat:@"%@%@",BaoGaoUrl,self.AnsId] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            // NSLog(@"-----%@",dict);
            
            if ([dict[@"Status"] integerValue]==1) {
                [SVProgressHUD showSuccessWithStatus:@"申请成功!"];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"您已申请过报告！"];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"申请失败！"];
            
        }];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // [cell.detWeb loadHTMLString:resultStr baseURL:nil];
    
    return _jieguo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headHig;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return 1;
    }else{
        return _dataArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    ResultController *wbvc=[[ResultController alloc]init];
    //
    //    //     wbvc.eleNum=_resultArray[indexPath.row][@"ELE_NUM"];
    //
    //    [self.navigationController pushViewController:wbvc animated:YES];
}

- (void)createTableView{
    CGFloat h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?42:38):34;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50-h) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(255, 255, 255);
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"ReplyCell" bundle:nil] forCellReuseIdentifier:@"ReplyCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"EvaluateCell" bundle:nil] forCellReuseIdentifier:@"EvaluateCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(freshLiuYan)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(MoreLiuYan)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 52);
    _tableView.tableHeaderView=_headView;
    
    
    
    
    _maskView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_maskView];
    _maskView.hidden=YES;
   
    
    _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [self.view addSubview:_plView];
    
    _plField.delegate=self;
    
}

- (void)createFootView{
    CGFloat h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?42:38):34;

    if ([self.kinStr isEqualToString:@"趣味测量"]) {
        _quxiaoBtn.layer.borderWidth=1;
        _quxiaoBtn.layer.borderColor=RGBACOLOR(92, 154, 245, 1).CGColor;
        
        _qwfoot.frame=CGRectMake(0, SCREEN_HEIGHT-50-h, SCREEN_WIDTH, h);
        [self.view addSubview:_qwfoot];
        
    }else{
        
        _baogaoView.frame=CGRectMake(0, SCREEN_HEIGHT-50-h, SCREEN_WIDTH, h);
        [self.view addSubview:_baogaoView];
    }
    
    self.biaoti.text=_testDic[@"tp_Name"];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArray.count==0) {
        EvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EvaluateCell"];
        
        [cell.ico setImage:nil];
        cell.user.text=@"";
        cell.evaDet.text=@"期待您的留言！";
        cell.timeab.text=@"";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        NSArray *arr=_dataArray[indexPath.row][@"lm_LeaveMessage"];
        
        if (arr.count>0) {
            ReplyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReplyCell"];
            NSDictionary *dic=arr[0];
            
//            [cell.zjIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
//            cell.hfCount.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Content"]];
//            cell.hfTime.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Time"]];
//            cell.zjTit.text=[NSString stringWithFormat:@"%@ ",_dataArray[indexPath.row][@"au_Name"]];
//            //cell.zjTit.text=[NSString stringWithFormat:@"%@ 回复了您的留言：",_dataArray1[indexPath.row][@"au_Name"]];
//
//            [cell.usIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
//            cell.usLiuyan.text=[NSString stringWithFormat:@"%@",dic[@"lm_Content"]];
//            cell.usTime.text=[NSString stringWithFormat:@"%@",dic[@"lm_Time"]];
            
            
            
            [cell.zjIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
            
            cell.hfCount.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Content"]];
            cell.hfTime.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Time"]];
            cell.zjTit.text=[NSString stringWithFormat:@"%@ ",_dataArray[indexPath.row][@"au_Name"]];
            cell.zjTit.textColor=[UIColor darkGrayColor];
            cell.sigLab.hidden=YES;
            
            
            [cell.usIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"au_ImgUrl"]]]];

            cell.usLiuyan.text=[NSString stringWithFormat:@"%@",dic[@"lm_Content"]];
            cell.usTime.text=[NSString stringWithFormat:@"%@",dic[@"lm_Time"]];
            cell.usName.text=[NSString stringWithFormat:@"%@ 回复",dic[@"au_Name"]];
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            EvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EvaluateCell"];
            
            [cell.ico setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
            cell.user.text=[NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"au_Name"]];
            cell.evaDet.text=[NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"lm_Content"]];
            cell.timeab.text=[NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"lm_Time"]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArray.count==0) {
        return 110;
        
        
    }else{
        
        NSArray *arr=_dataArray[indexPath.row][@"lm_LeaveMessage"];
        
        if (arr.count>0) {
            
                return 180+[NSString stringPhsHight:_dataArray[indexPath.row][@"lm_Content"] font:14 width:SCREEN_WIDTH-32]+[NSString stringPhsHight:arr[0][@"lm_Content"] font:14 width:SCREEN_WIDTH-52];
                
                
            }else{
                return [NSString stringHight:[NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"lm_Content"]] font:14 width:SCREEN_WIDTH-32]+94;

            }
        }
    
}

- (IBAction)gbAndShare:(UIButton *)sender {
    NSLog(@"ssss______%d",sender.tag);
    if (sender.tag==0) {
        
    }else{
        // NSString *textToShare = [NSString stringWithFormat:@"%@%@",self.dic[@"WARN_TYPE"],self.dic[@"WARN_LEVEL"]];
        NSString *textToShare = [NSString stringWithFormat:@"ascjhgasjkhklhjvlkdsahvkujndvklhkl;ghjkladgBjklasdgj,asdgvjkasgdkvjgbasdkvjgbasdjkvgjkasdgkvasdjfgasdjkgfkasgdfkfj"];
        //分享的图片
        UIImage *imageToShare = [UIImage imageNamed:@"LOGO.png"];
        
        //分享的url
        NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.baidu.com"]];
        //NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"http://gsqx.com:6081/dfecw/share.html?idsd_%@",self.detId]];
        //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
        NSArray *activityItems = @[urlToShare,imageToShare,textToShare];
        //NSArray *activityItems = @[textToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享之后的回调
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed) {
            
            NSLog(@"activityType :%@", activityType);
            
            if (completed)  {
                
                NSLog(@"completed");
            }
            else  {
                NSLog(@"cancel");
            }
            
            activityVC.completionHandler = myBlock;
            
        };
        
    }
    
    
    
    
}

- (IBAction)liuyan:(id)sender {
    
    if (_plField.text.length>0) {
        [_plField resignFirstResponder];
        
        if (_userDic==nil) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未登录，是否登录留言？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"登 录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                LoginController *pvc=[[LoginController alloc]init];
                [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
                    [[DataDefault shareInstance]setUserInfor:useinf];
                    _userDic=[useinf mutableCopy];
                    
                    [self Liuyan];
                    
                }];
                
                [self.navigationController pushViewController:pvc animated:YES];
                
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                _plField.text=nil;
            }];
            [okAction setValue:RGBCOLOR(250, 74, 64) forKey:@"_titleTextColor"];
            
            
            
            [alertController addAction:okAction];           // A
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self Liuyan];
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"留言不能为空！"];
        
    }
}

- (void)Liuyan{
    NSMutableDictionary *dicc=[NSMutableDictionary new];
    [dicc setValue:self.AnsId forKey:@"ua_id"];
    [dicc setValue:_plField.text forKey:@"lm_Content"];
    [dicc setValue:[NSString nowTimeStyle4] forKey:@"lm_Time"];
    [dicc setValue:_userDic[@"id"] forKey:@"au_id"];
    [dicc setValue:_userDic[@"au_Nme"] forKey:@"au_Name"];
    
    [SVProgressHUD showWithStatus:@"提交留言中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *url=[NSURL URLWithString:LiuYanUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:[[self objDictionToJSON:dicc] dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *respone,
                                               NSData *data,
                                               NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([data length]>0 && error==nil) {
                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 //   NSLog(@"答案-----%@",dict);
                 
                 if ([dict[@"Status"] integerValue]==1) {
                     [SVProgressHUD showSuccessWithStatus:@"留言成功!"];
                     
                     [UIView animateWithDuration:0.3 animations:^{
                         
                         _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
                         
                     } completion:^(BOOL finished) {
                         _maskView.hidden=YES;
                         _plField.text=nil;
                         
                         [self freshLiuYan];
                         
                     }];
                     
                     
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"留言失败！"];
                 }
                 
             }else{
                 [SVProgressHUD showErrorWithStatus:@"留言失败！"];
             }
         });
     }];
    
}

- (NSString *)objDictionToJSON:(NSDictionary *)dic {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString * str2 = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    return jsonString;
}


- (IBAction)goBack:(id)sender {
    if (_enter==4) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MasageController class]]) {
                MasageController *revise =(MasageController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
        
    }else if (_enter==3) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WoDeCLController class]]) {
                WoDeCLController *revise =(WoDeCLController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
        
    }else  if (_enter==2) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ReportController class]]) {
                ReportController *revise =(ReportController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
        
    }else{
        if ([self.kinStr isEqualToString:@"定制测量"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MainController class]]) {
                    MainController *revise =(MainController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ControllerOne class]]) {
                    ControllerOne *revise =(ControllerOne *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        }
        
    }
}


- (IBAction)resignInput:(id)sender {
    [_plField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        
    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
    }];
}



//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    _maskView.hidden=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat h=SCREEN_WIDTH>321?(SCREEN_WIDTH>376?271:258):253;
        
       // _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50-height);
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50-height, SCREEN_WIDTH, 50);
    } completion:^(BOOL finished) {
        
    }];
    
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    [_plField resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        
    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
    }];
}


#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _maskView.hidden=NO;
    
//    [UIView animateWithDuration:0.3 animations:^{
//        CGFloat h=SCREEN_WIDTH>321?(SCREEN_WIDTH>376?271:258):253;
//
//        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50-h, SCREEN_WIDTH, 50);
//    } completion:^(BOOL finished) {
//
//    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        
    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
    }];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
