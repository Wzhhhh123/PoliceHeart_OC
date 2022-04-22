//
//  WZListController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/9.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "WZListController.h"
#import "MPageCell.h"
#import "AllArticleCell.h"
#import "OneDetController.h"

@interface WZListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_resultArray;
    
    UILabel *_signLab;
    
    BOOL isSearch;
    
    BOOL _isSeaRefresh;
    NSInteger _seaPage;
    
    CGFloat cHig,Khig;
    
    NSInteger kin;
    
    BOOL _isRefresh;
    NSInteger _page;
    
    
    
}

@property (weak, nonatomic) IBOutlet UIButton *tuijianBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (strong, nonatomic) IBOutlet UIView *secView;


@property (weak, nonatomic) IBOutlet UIView *seaView;
@property (weak, nonatomic) IBOutlet UITextField *seaField;
@property (weak, nonatomic) IBOutlet UIButton *seaBtn;

@property ( nonatomic)  CGFloat NavHig;

@property (weak, nonatomic) IBOutlet UIView *mutHead;


@end

@implementation WZListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    cHig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?110:106):94;
    Khig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?270:260):256;
    _NavHig=SCREEN_HEIGHT>800?83:64;

    kin=0;
    
    _dataArray=[NSMutableArray new];
    _resultArray=[NSMutableArray new];
    
    isSearch=NO;
    
    _NavHig=SCREEN_HEIGHT>800?83:64;

    [self createHead];
    
    [self createTableView];
    [self createSeachPage];
    
    [self refresh];
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);

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
    
    //    _seaBg.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    //    [self.view addSubview:_seaBg];
    //    _seaBg.hidden =YES;
    
    //    for (int i=0; i<_titArray.count; i++) {
    //        CGFloat sw=[NSString stringWidth:[NSString stringWithFormat:@"%@",_titArray[i]] font:14]+34;
    //        if (_w+sw>self.frame.size.width-20) {
    //            _w=10;
    //            _l++;
    //
    //        }
    //
    //        IconBtn *iconView=[[IconBtn alloc]initWithFrame:CGRectMake(_w, 6+(48)*_l, sw, 45)];
    //        [iconView.titLab setText:[NSString stringWithFormat:@"%@",_titArray[i]]];
    //        if (self.model==0) {
    //            [iconView.closeBtn setImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    //        }else{
    //            [iconView.closeBtn setImage:[UIImage imageNamed:@"selectBtn.png"] forState:UIControlStateNormal];
    //
    //        }
    //        iconView.tag=i;
    //        [scrollView addSubview:iconView];
    //        _w=_w+sw;
    //
    //        [iconView setActionClose:^(NSInteger ta) {
    //            if (self.actionCloseView) {
    //                self.actionCloseView(ta);
    //            }
    //        }];
    //
    //    }
    
}


- (IBAction)secKind:(UIButton *)sender {
    if (sender.tag==0) {
        kin=0;
        _tuijianBtn.backgroundColor=RGBCOLOR(32, 143, 254);
        [_tuijianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _allBtn.backgroundColor=RGBCOLOR(224, 224, 224);
        [_allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        kin=1;
        _allBtn.backgroundColor=RGBCOLOR(32, 143, 254);
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _tuijianBtn.backgroundColor=RGBCOLOR(224, 224, 224);
        [_tuijianBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!isSearch) {
        _secView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 50);
        
        _tuijianBtn.layer.masksToBounds=YES;
        _tuijianBtn.layer.cornerRadius=6;
        
        _allBtn.layer.masksToBounds=YES;
        _allBtn.layer.cornerRadius=6;
        return _secView;
    }else{
        
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!isSearch) {
        return 50;
        
    }else{
        
        return 0.00001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isSearch) {
        return  _dataArray.count;
        
    }else{
        return  _resultArray.count;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OneDetController *wbvc=[[OneDetController alloc]init];
    if (!isSearch) {
        wbvc.inf=[_dataArray[indexPath.row] mutableCopy];
        wbvc.lm_ObjId=_dataArray[indexPath.row][@"id"];

    }else{
        wbvc.inf=[_resultArray[indexPath.row] mutableCopy];
        wbvc.lm_ObjId=_resultArray[indexPath.row][@"id"];

    }
    wbvc.userDic=[_userDic mutableCopy];
    
    wbvc.intage=indexPath.row;
    
    
    wbvc.kinStr=1;

    [wbvc setActionDianZan:^(NSMutableDictionary *infDic, NSInteger indx) {
        if (!isSearch) {
            [_dataArray replaceObjectAtIndex:indx withObject:infDic];
            
        }else{
            [_resultArray replaceObjectAtIndex:indx withObject:infDic];

        }
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"MPageCell" bundle:nil] forCellReuseIdentifier:@"MPageCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"AllArticleCell" bundle:nil] forCellReuseIdentifier:@"AllArticleCell"];//xib定制cell

    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    
    
    _signLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _signLab.textAlignment=NSTextAlignmentCenter;
    _signLab.textColor=RGBCOLOR(88, 88, 88);
    _signLab.backgroundColor=[UIColor clearColor];
    _signLab.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:_signLab];
    _signLab.text=@"暂无数据";
    _signLab.hidden=YES;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!isSearch) {
        if (kin==0) {
            MPageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MPageCell"];
            [cell setInfo:_dataArray[indexPath.row]];
            
            
            //    cell.titLab.text=_dataArray[indexPath.row][@"tit"];
            //    cell.detLab.text=_dataArray[indexPath.row][@"det"];
            //    [cell.Imag setImage:[UIImage imageNamed:_dataArray[indexPath.row][@"ima"]]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            AllArticleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllArticleCell"];
            [cell setInfo:_dataArray[indexPath.row]];
            
            //    cell.titLab.text=_dataArray[indexPath.row][@"tit"];
            //    cell.detLab.text=_dataArray[indexPath.row][@"det"];
            //    [cell.Imag setImage:[UIImage imageNamed:_dataArray[indexPath.row][@"ima"]]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        MPageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MPageCell"];
        [cell setInfo:_resultArray[indexPath.row]];
        
        
        //    cell.titLab.text=_dataArray[indexPath.row][@"tit"];
        //    cell.detLab.text=_dataArray[indexPath.row][@"det"];
        //    [cell.Imag setImage:[UIImage imageNamed:_dataArray[indexPath.row][@"ima"]]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kin==0) {
        return Khig;
        
    }else{
        
        return cHig;
        
    }
}



-(void)refresh{
    if (!isSearch) {
        _page=1;
        _isRefresh=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        //  [dic setObject:@1 forKey:@"page"];
        [dic setObject:@10 forKey:@"rows"];
        [dic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
            [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];
            
        }else{
            
            [dic setValue:@"ios " forKey:@"au_RegistrationId"];
            
        }
        [self loadData:dic url:WZList];
    }else{
        
        _seaPage=1;
        _isSeaRefresh=YES;
        
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:@10 forKey:@"rows"];
        [dic setValue:[NSNumber numberWithInteger:_seaPage] forKey:@"page"];
        [dic setValue:_seaField.text forKey:@"a_Title"];
        [self loadData:dic url:WZXhaXun];
        
    }
    
    
}

- (void)loadMore{
    if (!isSearch) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:@10 forKey:@"rows"];
        [dic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
            [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];
            
        }else{
            
            [dic setValue:@"ios " forKey:@"au_RegistrationId"];
            
        }
        [self loadData:dic url:WZList];
    }else{
        
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:@10 forKey:@"rows"];
        [dic setValue:[NSNumber numberWithInteger:_seaPage] forKey:@"page"];
        [dic setValue:_seaField.text forKey:@"a_Title"];
            
        
        [self loadData:dic url:WZXhaXun];
        
    }
    
    
}


- (void)loadData:(NSMutableDictionary *)diction url:(NSString *)url{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //[manger.requestSerializer setValue:[NSString stringWithFormat:@"BasicAuth%@",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Basic%@%@",@" ",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    [manger GET:url parameters:diction success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (!isSearch) {
            if (_isRefresh) {
                [_dataArray removeAllObjects];
            }
        }else{
            
            if (_isSeaRefresh) {
                [_resultArray removeAllObjects];
            }
        }
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //  NSLog(@"dddd%@",dict);
        
        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            NSMutableArray *dictio=dict[@"result"];
            
            
            if (!isSearch) {
                [_dataArray addObjectsFromArray:dictio];
                _page++;
                _isRefresh=NO;
                [_tableView reloadData];
            }else{
                
                [_resultArray addObjectsFromArray:dictio];
                _seaPage++;
                _isSeaRefresh=NO;
                [_tableView reloadData];
            }
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无更多数据！"];
            
        }
        
        if (!isSearch) {
            if (_dataArray.count==0) {
                _signLab.hidden=NO;
            }else{
                _signLab.hidden=YES;
                
            }
        }else{
            if (_resultArray.count==0) {
                _signLab.hidden=NO;
            }else{
                _signLab.hidden=YES;
            }
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (!isSearch) {
            if (_dataArray.count==0) {
                _signLab.hidden=NO;
            }else{
                _signLab.hidden=YES;
                
            }
        }else{
            if (_resultArray.count==0) {
                _signLab.hidden=NO;
            }else{
                _signLab.hidden=YES;
            }
        }
    }];
    
}



- (IBAction)seachAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        // _seaBg.hidden =YES;
        
        [_seaField resignFirstResponder];
        [_seaBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _seaField.text=nil;
        isSearch=NO;
        [_tableView reloadData];
    
    }else{

        [_seaField becomeFirstResponder];
        // _seaBg.hidden =NO;
        
    }
    if (!isSearch) {
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }
    }else{
        if (_resultArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
        }
    }
    
}


#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_seaBtn setTitle:@"取消" forState:UIControlStateNormal];
    isSearch=YES;
    _seaPage=1;
    _isSeaRefresh=YES;
    // _seaBg.hidden =NO;
    [_resultArray removeAllObjects];

    if (!isSearch) {
        if (_dataArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
            
        }
    }else{
        if (_resultArray.count==0) {
            _signLab.hidden=NO;
        }else{
            _signLab.hidden=YES;
        }
    }
    [_tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_seaField.text.length>0) {
        [textField resignFirstResponder];
        
        NSMutableDictionary *dic=[NSMutableDictionary new];
        _seaPage=1;
        isSearch=YES;
        _isSeaRefresh=YES;
        
        [dic setObject:@10 forKey:@"rows"];
        [dic setValue:[NSNumber numberWithInteger:_seaPage] forKey:@"page"];
        [dic setValue:_seaField.text forKey:@"a_Title"];
        [self loadData:dic url:WZXhaXun];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"关键字不能为空！"];
    }
    
    return YES;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@8.5f;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
}


//计算UILabel的高度(带有行间距的情况)

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
