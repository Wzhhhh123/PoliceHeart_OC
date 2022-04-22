//
//  ReportController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/7.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ReportController.h"
#import "ReportCell.h"

#import "ResultController.h"
#import "RepDetController.h"

#import "LoginController.h"

@interface ReportController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    CGFloat cHig,Khig;
    
    NSInteger kin;
    
    NSInteger _page;
    BOOL isRefresh;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *igImage;
@property (strong, nonatomic) IBOutlet UIView *sigView;

@property (nonatomic ) NSMutableDictionary *userDic;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation ReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    _dataArray=[NSMutableArray new];
    _NavHig=SCREEN_HEIGHT>800?83:64;
    
    [self createHead];
    
    if([[DataDefault shareInstance]userInfor]==nil){
        [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];

    }else{
        [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];

        _sigView.hidden=YES;
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
       // [self createTableView];

        [self refresh];
        
        
    }
    [self createTableView];

    _sigView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH,  SCREEN_WIDTH);
    [self.view addSubview:_sigView];
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;

    if([[DataDefault shareInstance]userInfor]==nil){
        [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];
        [_dataArray removeAllObjects];
        isRefresh=YES;
        _page=1;
        [_tableView reloadData];
    }else{
        [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
        
        _sigView.hidden=YES;
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
        
        //[self refresh];
        
        
    }
    
}
- (IBAction)Login:(id)sender {
    
    if([[DataDefault shareInstance]userInfor]==nil){
        LoginController *pvc=[[LoginController alloc]init];
        [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
            [[DataDefault shareInstance]setUserInfor:useinf];
            _userDic=[useinf mutableCopy];
            
            [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
            _sigView.hidden=YES;
            
            [self createTableView];
            
            [self refresh];
            
        }];
        
        [self.navigationController pushViewController:pvc animated:YES];
    }else{

        
        
    }
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
    
   // return  20;
    return  _dataArray.count;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataArray[indexPath.row][@"rp_Url"] length]>0) {
        RepDetController *wbvc=[[RepDetController alloc]init];
        //  wbvc.kinStr=self.kinStr;
        wbvc.infDic=[_dataArray[indexPath.row] mutableCopy];
        // wbvc.userDic=[_userDic mutableCopy];
        
        [self.navigationController pushViewController:wbvc animated:YES];
    }else{
        ResultController *wbvc=[[ResultController alloc]init];
        wbvc.kinStr=_dataArray[indexPath.row][@"tp_Type"];
        wbvc.AnsId=_dataArray[indexPath.row][@"id"];
        wbvc.testDic=[_dataArray[indexPath.row] mutableCopy];
        wbvc.userDic=[_userDic mutableCopy];
        wbvc.enter=2;

        [self.navigationController pushViewController:wbvc animated:YES];
    }
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellReuseIdentifier:@"ReportCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReportCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
    
    [cell setInfWithdic:_dataArray[indexPath.row]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}

-(void)refresh{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    isRefresh=YES;
    _page=1;
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:_userDic[@"id"] forKey:@"u_id"];
    [self loadData:dic];
    
    
    
}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:_userDic[@"id"] forKey:@"u_id"];
    [self loadData:dic];
    
}

- (void)loadData:(NSMutableDictionary *)dict{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:BaoGaoListUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (isRefresh) {
            [_dataArray removeAllObjects];
        }
       // NSLog(@"dddd%@",dict);
        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            NSArray *arr=dict[@"result"];
            if (arr.count>0) {
                isRefresh=NO;
                _page++;
                for (NSDictionary *dic in arr) {
                    [_dataArray addObject:dic];
                    
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无数据！"];
            
        }
        if (_dataArray.count==0) {
            _sigView.hidden=NO;

        }else{
            _sigView.hidden=YES;

        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        if (_dataArray.count==0) {
            _sigView.hidden=NO;
            
        }else{
            _sigView.hidden=YES;
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
