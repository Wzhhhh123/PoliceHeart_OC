//
//  WoDeCLController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "WoDeCLController.h"
#import "CLListCell.h"

//#import "CeshiController.h"
#import "QWController.h"

@interface WoDeCLController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;

    
    NSInteger _kin;
    
    NSInteger _page1,_page2,_page3;
    BOOL isRefresh1,isRefresh2,isRefresh3;
    
    UIView *_siView;
    UIButton *bacBtn1;
    UIButton *bacBtn2;
    UIButton *bacBtn3;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *sigImage;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@property (strong, nonatomic) IBOutlet UIView *sigView;
@end

@implementation WoDeCLController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _kin=1;
    _dataArray1=[NSMutableArray new];
    _dataArray2=[NSMutableArray new];
    _dataArray3=[NSMutableArray new];
    _NavHig=SCREEN_HEIGHT>800?83:64;

    _page1=_page2=_page3=1;
    
    isRefresh1=isRefresh2=isRefresh3=YES;
    
    [self createHead];
    [self createPage];
    [self createTableView];
    [self refresh];
    
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

- (void)createPage{
    NSArray *arr=@[@"趣味测量",@"专业测量",@"定制测量"];
    bacBtn1=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*0, _NavHig, SCREEN_WIDTH/3, 40)];
    [bacBtn1 setTitle:arr[0] forState:UIControlStateNormal];
    [bacBtn1 setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
    bacBtn1.titleLabel.font=[UIFont systemFontOfSize:15];
    bacBtn1.tag=0;
    [bacBtn1 addTarget:self action:@selector(backHead:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bacBtn1];
    
    
    bacBtn2=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*1, _NavHig, SCREEN_WIDTH/3, 40)];
    [bacBtn2 setTitle:arr[1] forState:UIControlStateNormal];
    [bacBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    bacBtn2.titleLabel.font=[UIFont systemFontOfSize:15];
    bacBtn2.tag=1;
    [bacBtn2 addTarget:self action:@selector(backHead:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bacBtn2];
    
    bacBtn3=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, _NavHig, SCREEN_WIDTH/3, 40)];
    [bacBtn3 setTitle:arr[2] forState:UIControlStateNormal];
    [bacBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    bacBtn3.titleLabel.font=[UIFont systemFontOfSize:15];
    bacBtn3.tag=2;
    [bacBtn3 addTarget:self action:@selector(backHead:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bacBtn3];
    
    _siView=[[UIView alloc]init];
    _siView.frame=CGRectMake(0, _NavHig+40,SCREEN_WIDTH/3 , 3);
    _siView.backgroundColor=RGBCOLOR(32, 143, 254);
    [self.view addSubview:_siView];
    
}

- (void)backHead:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        _siView.frame=CGRectMake(SCREEN_WIDTH/3*btn.tag, _NavHig+40,SCREEN_WIDTH/3 , 3);
        
    }completion:^(BOOL finished) {
        if (btn.tag==0) {
            _kin=1;
            [bacBtn1 setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
            [bacBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [bacBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if (_dataArray1.count==0) {
                [self refresh];
            }else{
                [_tableView reloadData];

            }
            
        }
        if (btn.tag==1) {
            _kin=2;
            [bacBtn2 setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
            [bacBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [bacBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if (_dataArray2.count==0) {
                [self refresh];
            }else{
                [_tableView reloadData];
                
            }
        }
        if (btn.tag==2) {
            _kin=3;
            [bacBtn3 setTitleColor:RGBCOLOR(32, 143, 254) forState:UIControlStateNormal];
            [bacBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [bacBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if (_dataArray3.count==0) {
                [self refresh];
            }else{
                [_tableView reloadData];
                
            }
        }
    }];
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_kin==1) {
        return  _dataArray1.count;

    }else if (_kin==2) {
        return  _dataArray2.count;

    }else{
        
        return  _dataArray3.count;

    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (_kin==1) {
        dic=[_dataArray1[indexPath.row] mutableCopy];
        
    }else if (_kin==2) {
        dic=[_dataArray2[indexPath.row] mutableCopy];

    }else{
        
        dic=[_dataArray3[indexPath.row] mutableCopy];
    }
    if (_kin==3) {
      
        [SVProgressHUD showErrorWithStatus:@"定制测量不能重复进行"];
        
    }else{
        QWController *wbvc=[[QWController alloc]init];
        wbvc.kinStr=dic[@"tp_Type"];
        wbvc.testPapper_id=dic[@"tp_id"];
        wbvc.testDic=[dic mutableCopy];
        wbvc.userDic=[_userDic mutableCopy];
        wbvc.enter=3;
        
        [self.navigationController pushViewController:wbvc animated:YES];
    }
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig+44, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"CLListCell" bundle:nil] forCellReuseIdentifier:@"CLListCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    
    _sigView.frame=CGRectMake(0, _NavHig+44, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:_sigView];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CLListCell"];
    
    if (_kin==1) {
        [cell setInfWithdic:_dataArray1[indexPath.row]];
    }else if (_kin==2) {
        [cell setInfWithdic:_dataArray2[indexPath.row]];

    }else{
        [cell setInfWithdic:_dataArray3[indexPath.row]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}

-(void)refresh{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (_kin==1) {
        isRefresh1=YES;
        _page1=1;
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page1] forKey:@"page"];
        [dic setObject:@"趣味" forKey:@"tp_Type"];

    }else if (_kin==2) {
        isRefresh2=YES;
        _page2=1;
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page2] forKey:@"page"];
        [dic setObject:@"专业" forKey:@"tp_Type"];

    }else{
        isRefresh3=YES;
        _page3=1;
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page3] forKey:@"page"];
        [dic setObject:@"定制" forKey:@"tp_Type"];

    }
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:_userDic[@"id"] forKey:@"u_id"];
    
    [self loadData:dic];

}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (_kin==1) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page1] forKey:@"page"];
        [dic setObject:@"趣味" forKey:@"tp_Type"];
        
    }else if (_kin==2) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page2] forKey:@"page"];
        [dic setObject:@"专业" forKey:@"tp_Type"];
        
    }else{
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page3] forKey:@"page"];
        [dic setObject:@"定制" forKey:@"tp_Type"];
        
    }
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:_userDic[@"id"] forKey:@"u_id"];
    
    [self loadData:dic];
}

- (void)loadData:(NSMutableDictionary *)diction{
    [SVProgressHUD showWithStatus:@"数据获取中..." maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:CLListUrl parameters:diction success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (_kin==1) {
            if (isRefresh1) {
                [_dataArray1 removeAllObjects];
            }
        }else if (_kin==2) {
            if (isRefresh2) {
                [_dataArray2 removeAllObjects];
            }
        }else{
            if (isRefresh3) {
                [_dataArray3 removeAllObjects];
            }
        }
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

      //  NSLog(@"dddd%@",dict);

        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功！"];
            NSArray *arr=dict[@"result"];
            if (arr.count>0) {
                if (_kin==1) {
                    isRefresh1=NO;
                    _page1++;
                    for (NSDictionary *dic in arr) {
                        [_dataArray1 addObject:dic];
                        
                    }
                }else if (_kin==2) {
                    isRefresh2=NO;
                    _page2++;
                    for (NSDictionary *dic in arr) {
                        [_dataArray2 addObject:dic];
                        
                    }
                }else{
                    isRefresh3=NO;
                    _page3++;
                    for (NSDictionary *dic in arr) {
                        [_dataArray3 addObject:dic];
                    }
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无数据！"];
            
        }
        
        if (_kin==1) {
            if (_dataArray1.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }else if (_kin==2) {
            if (_dataArray2.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }else{
            if (_dataArray3.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (_kin==1) {
            if (_dataArray1.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }else if (_kin==2) {
            if (_dataArray2.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }else{
            if (_dataArray3.count==0) {
                _sigView.hidden=NO;
            }else{
                _sigView.hidden=YES;
                
            }
        }
    }];
}

- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
