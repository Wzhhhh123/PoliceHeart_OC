//
//  SeachController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/8.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "SeachController.h"
#import "ViewCommon.h"
#import "QWCell.h"

#import "QWController.h"
@interface SeachController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *_signLab;
    
    NSInteger _page;
    BOOL _isRefresh;
}



@property (weak, nonatomic) IBOutlet UIView *seaView;
@property (weak, nonatomic) IBOutlet UITextField *seaField;
@property (weak, nonatomic) IBOutlet UIButton *seaBtn;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation SeachController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _NavHig=SCREEN_HEIGHT>800?83:64;

    _dataArray=[NSMutableArray new];
    [self createHead];
    [self createTableView];
    [self createSeachPage];
    
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}
- (void)createSeachPage{
    
    _seaField.delegate=self;
    
    _seaView.layer.borderColor=RGBCOLOR(200, 200, 200).CGColor;
    _seaView.layer.borderWidth=1;
    _seaView.layer.cornerRadius=8;
    _seaView.layer.masksToBounds=YES;

    
}


- (void)viewWillAppear:(BOOL)animated{
    [_seaField becomeFirstResponder];
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
    
    return  _dataArray.count;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QWController *wbvc=[[QWController alloc]init];
    wbvc.enter=1;
    
    wbvc.kinStr=self.kinStr;
    wbvc.testDic=[_dataArray[indexPath.row] mutableCopy];
    wbvc.userDic=[_userDic mutableCopy];
    
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"QWCell" bundle:nil] forCellReuseIdentifier:@"QWCell"];//xib定制cell
    

    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    _signLab =[[UILabel alloc]initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-200)];
    _signLab.textAlignment=NSTextAlignmentCenter;
    _signLab.textColor=RGBCOLOR(88, 88, 88);
    _signLab.backgroundColor=[UIColor clearColor];
    _signLab.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:_signLab];
    _signLab.text=@"暂无数据";
    //_signLab.hidden=YES;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QWCell *cell=[tableView dequeueReusableCellWithIdentifier:@"QWCell"];
    
    [cell setINf:_dataArray[indexPath.row]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}


-(void)refresh{
    _page=1;
    _isRefresh=YES;
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setValue:self.kinStr forKey:@"tp_Type"];
    [dic setValue:_seaField.text forKey:@"tp_Name"];
    
    [self loadData:dic];
    
}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dic setValue:self.kinStr forKey:@"tp_Type"];
    [dic setValue:_seaField.text forKey:@"tp_Name"];
    
    [self loadData:dic];
}


- (void)loadData:(NSMutableDictionary *)dicd{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //[manger.requestSerializer setValue:[NSString stringWithFormat:@"BasicAuth%@",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Basic%@%@",@" ",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    [manger GET:SJChaXun parameters:dicd success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (_isRefresh) {
            [_dataArray removeAllObjects];
        }
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // NSLog(@"试卷列表%@",dict);
        
        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            NSMutableArray *dic=dict[@"result"];
            if (dict.count>0) {


                [_dataArray addObjectsFromArray:dic];
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
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }
    }];
    
}




- (IBAction)seachAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [_dataArray removeAllObjects];
        [_seaField resignFirstResponder];
        [_seaBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _seaField.text=nil;
        [_tableView reloadData];
    }else{
        [_seaField becomeFirstResponder];
        
    }
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }
  
}


#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_seaBtn setTitle:@"取消" forState:UIControlStateNormal];
    
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }

    [_tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_seaField.text.length>0) {
        [textField resignFirstResponder];
        
 
        [self refresh];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"关键字不能为空！"];
    }
    
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
