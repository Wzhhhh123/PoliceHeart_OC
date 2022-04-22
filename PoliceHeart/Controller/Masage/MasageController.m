//
//  MasageController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/7.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "MasageController.h"
#import "MasCell.h"

#import "LoginController.h"

#import "ReplyCell.h"

#import "ResultController.h"
#import "OneDetController.h"


@interface MasageController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    
    CGFloat cHig,Khig;
    
    NSInteger _kin;
    
    NSInteger _page1,_page2;
    BOOL isRefresh1,isRefresh2;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *igImage;
@property (weak, nonatomic) IBOutlet UIView *sigImage;
@property (weak, nonatomic) IBOutlet UIView *sigView;

@property (nonatomic ) NSMutableDictionary *userDic;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation MasageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    _NavHig=SCREEN_HEIGHT>800?83:64;

    _sigView.frame=CGRectMake(SCREEN_WIDTH/2-60, 58, 45, 4);
    _dataArray1=[NSMutableArray new];
    _dataArray2=[NSMutableArray new];
    
    _page1=_page2=1;
    isRefresh1=isRefresh1=YES;
    
    _kin=1;
    
    [self createHead];
    
    if([[DataDefault shareInstance]userInfor]==nil){
        [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];
        
    }else{
        [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
        
        _sigImage.hidden=YES;
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
        // [self createTableView];
        
        [self refresh];
        
        
    }
    
    [self createTableView];
    
    _sigImage.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:_sigImage];
}


- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    
    if([[DataDefault shareInstance]userInfor]==nil){
        [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];
        [_dataArray1 removeAllObjects];
        [_dataArray2 removeAllObjects];
        _page1=_page2=1;
        isRefresh1=isRefresh1=YES;
        
        [_tableView reloadData];
    }else{
        [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
        
        _sigImage.hidden=YES;
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
        
        //[self refresh];
        
        
    }
    
}


- (IBAction)oginView:(id)sender {
    if([[DataDefault shareInstance]userInfor]==nil){
        LoginController *pvc=[[LoginController alloc]init];
        [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
            [[DataDefault shareInstance]setUserInfor:useinf];
            _userDic=[useinf mutableCopy];
            
            [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
            _sigImage.hidden=YES;
            
            
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
    if (_kin==1) {
        return  _dataArray1.count;
        
    }else{
        
       // return  _dataArray2.count;
         return  0;

    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataArray1[indexPath.row][@"sm_ObjType"] isEqualToString:@"文章"]) {
        OneDetController *wbvc=[[OneDetController alloc]init];
//        wbvc.kinStr=_dataArray1[indexPath.row][@"tp_Type"];
//        wbvc.AnsId=_dataArray1[indexPath.row][@"id"];
//        wbvc.testDic=[_dataArray1[indexPath.row] mutableCopy];
        wbvc.userDic=[_userDic mutableCopy];
//        wbvc.enter=2;
        
        wbvc.kinStr=2;
        wbvc.lm_ObjId=_dataArray1[indexPath.row][@"sm_ObjId"];

        [self.navigationController pushViewController:wbvc animated:YES];
        
        
    }else{
        ResultController *wbvc=[[ResultController alloc]init];
        wbvc.kinStr=_dataArray1[indexPath.row][@"tp_Type"];
        wbvc.AnsId=_dataArray1[indexPath.row][@"sm_ObjId"];
        wbvc.testDic=[_dataArray1[indexPath.row] mutableCopy];
        wbvc.userDic=[_userDic mutableCopy];
        wbvc.enter=4;
        
        [self.navigationController pushViewController:wbvc animated:YES];
        
    }

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
    
    [_tableView registerNib:[UINib nibWithNibName:@"MasCell" bundle:nil] forCellReuseIdentifier:@"MasCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"ReplyCell" bundle:nil] forCellReuseIdentifier:@"ReplyCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_kin==1) {
        UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了关注");
            
            // 收回左滑出现的按钮(退出编辑模式)
            tableView.editing = NO;
        }];
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [_dataArray1 removeObjectAtIndex:indexPath.row];
            
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        return @[action1, action0];
    }else{
        
        UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了关注");
            
            // 收回左滑出现的按钮(退出编辑模式)
            tableView.editing = NO;
        }];
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [_dataArray2 removeObjectAtIndex:indexPath.row];
            
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        return @[action1, action0];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_kin==1) {
        
        
        ReplyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReplyCell"];
        
        [cell.zjIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_dataArray1[indexPath.row][@"sm_ReplyImg"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
        cell.hfCount.text=[NSString stringWithFormat:@"%@",_dataArray1[indexPath.row][@"sm_Content"]];
        cell.hfTime.text=[NSString stringWithFormat:@"%@",_dataArray1[indexPath.row][@"sm_Time"]];
        cell.zjTit.text=[NSString stringWithFormat:@"%@ ",_dataArray1[indexPath.row][@"sm_ReplyUser"]];

        [cell.usIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
        cell.usLiuyan.text=[NSString stringWithFormat:@"%@",_dataArray1[indexPath.row][@"sm_LeaveCon"]];
        cell.usTime.text=[NSString stringWithFormat:@"%@",_dataArray1[indexPath.row][@"sm_Time"]];
        cell.usName.text=[NSString stringWithFormat:@"%@",_dataArray1[indexPath.row][@"sm_UserName"]];

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        MasCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MasCell"];
        

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_kin==1) {
                return 180+[NSString stringPhsHight:_dataArray1[indexPath.row][@"sm_Content"] font:14 width:SCREEN_WIDTH-32]+[NSString stringPhsHight:_dataArray1[indexPath.row][@"sm_LeaveCon"] font:14 width:SCREEN_WIDTH-52];


    }else{
        return 86;
        
    }
}



- (IBAction)MassOrNotice:(UIButton *)sender {

    if (sender.tag==0) {
        _kin=1;
        if (_sigView.frame.origin.x==SCREEN_WIDTH/2+15) {
            [UIView animateWithDuration:0.2 animations:^{
                _sigView.frame=CGRectMake(SCREEN_WIDTH/2-60, 58, 45, 4);
                
            }];
        }
    }else{
        _kin=2;
        if (_sigView.frame.origin.x==SCREEN_WIDTH/2-60) {
            [UIView animateWithDuration:0.2 animations:^{
                _sigView.frame=CGRectMake(SCREEN_WIDTH/2+15, 58, 45, 4);
                
            }];
        }
        
    }
    
    [_tableView reloadData];

    if (_kin==1) {
        self.tabBarController.tabBar.hidden=NO;

        if([[DataDefault shareInstance]userInfor]==nil){
            [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];
            [_dataArray1 removeAllObjects];
            [_dataArray2 removeAllObjects];
            _page1=_page2=1;
            isRefresh1=isRefresh1=YES;
            
            [_tableView reloadData];
        }else{
            [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
            
            _sigImage.hidden=YES;
            _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
            
            if (_dataArray1.count==0) {
                [self refresh];
            }else{
                [_tableView reloadData];
            }
            
        }
        

    }else{
        self.tabBarController.tabBar.hidden=NO;
        
        if([[DataDefault shareInstance]userInfor]==nil){
            [_igImage setImage:[UIImage imageNamed:@"noLogin.png"]];
            [_dataArray1 removeAllObjects];
            [_dataArray2 removeAllObjects];
            _page1=_page2=1;
            isRefresh1=isRefresh1=YES;
            
            [_tableView reloadData];
        }else{
            [_igImage setImage:[UIImage imageNamed:@"noneInf.png"]];
            
            _sigImage.hidden=YES;
            _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
            
            if (_dataArray2.count==0) {
                [self refresh];
            }else{
                [_tableView reloadData];
            }
            
        }
        

    }
}


- (IBAction)readAll:(id)sender {
    
    
}





-(void)refresh{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (_kin==1) {
        isRefresh1=YES;
        _page1=1;
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page1] forKey:@"page"];
        [dic setObject:@"10" forKey:@"rows"];
        [dic setObject:@"0" forKey:@"sm_IsRead"];

    }else{
        
        isRefresh2=YES;
        _page2=1;
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page2] forKey:@"page"];
        [dic setObject:@"10" forKey:@"rows"];
    }
    [dic setObject:_userDic[@"id"] forKey:@"sm_UserID"];
    
    [self loadData:dic];
    
}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (_kin==1) {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page1] forKey:@"page"];
        [dic setObject:@"10" forKey:@"rows"];
        [dic setObject:@"0" forKey:@"sm_IsRead"];

    }else{
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page2] forKey:@"page"];
        [dic setObject:@"10" forKey:@"rows"];
    }
    [dic setObject:_userDic[@"id"] forKey:@"sm_UserID"];
    
    [self loadData:dic];
}

- (void)loadData:(NSMutableDictionary *)dict{
    NSString *urlStr;
    if (_kin==1) {
        urlStr=[NSString stringWithFormat:@"%@",XXList];
    }else{
        urlStr=[NSString stringWithFormat:@"%@",TZList];
        
    }
   // [SVProgressHUD showWithStatus:@"数据获取中..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:urlStr parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_kin==1) {
            if (isRefresh1) {
                [_dataArray1 removeAllObjects];
            }
        }else if (_kin==2) {
            if (isRefresh2) {
                [_dataArray2 removeAllObjects];
            }
        }
        
        NSLog(@"dddd消息：%@",dict);
        if ([dict[@"Message"] isEqualToString:@"OK"]) {
          //  [SVProgressHUD showSuccessWithStatus:@"获取成功！"];
            
            NSArray *arr=dict[@"result"];
            if (arr.count>0) {
                if (_kin==1) {
                    isRefresh1=NO;
                    _page1++;
                    for (NSDictionary *dic in arr) {

                            [_dataArray1 addObject:dic];
                    }
                }else{
                    isRefresh2=NO;
                    _page2++;
                    for (NSDictionary *dic in arr) {

                        // [_dataArray2 addObject:dic];
                    }
                    
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无数据！"];
            
        }
        if (_kin==1) {
            if (_dataArray1.count==0) {
                _sigImage.hidden=NO;
            }else{
                _sigImage.hidden=YES;
                
            }
        }else{
            
            if (_dataArray2.count==0) {
                _sigImage.hidden=NO;
            }else{
                _sigImage.hidden=YES;
                
            }
        }
        
        
        
        
        [_tableView reloadData];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       // [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (_kin==1) {
            if (_dataArray1.count==0) {
                _sigImage.hidden=NO;
            }else{
                _sigImage.hidden=YES;
                
            }
        }else{
            
            if (_dataArray2.count==0) {
                _sigImage.hidden=NO;
            }else{
                _sigImage.hidden=YES;
                
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
