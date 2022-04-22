//
//  ControllerOne.m
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ControllerOne.h"
#import "ViewCommon.h"
#import "QWCell.h"

#import "QWController.h"

#import "SeachController.h"

@interface ControllerOne ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *_signLab;

    NSInteger _page;
    BOOL _isRefresh;
    
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIButton *tuijianBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (strong, nonatomic) IBOutlet UIView *secView;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *headText;
@property (weak, nonatomic) IBOutlet UILabel *perLan;

@property (weak, nonatomic) IBOutlet UIView *seaView;
@property (weak, nonatomic) IBOutlet UITextField *seaField;
@property (weak, nonatomic) IBOutlet UIButton *seaBtn;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation ControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _NavHig=SCREEN_HEIGHT>800?83:64;

    _dataArray=[NSMutableArray new];
    _titLab.text=_kinStr;
    [self createHead];
    [self refresh];
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

- (IBAction)secKind:(UIButton *)sender {
    if (sender.tag==0) {
        _tuijianBtn.backgroundColor=RGBCOLOR(32, 143, 254);
        [_tuijianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        _allBtn.backgroundColor=RGBCOLOR(224, 224, 224);
        [_allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        
        _allBtn.backgroundColor=RGBCOLOR(32, 143, 254);
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _tuijianBtn.backgroundColor=RGBCOLOR(224, 224, 224);
        [_tuijianBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        
        
    }
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _secView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 94);
    
    _tuijianBtn.layer.masksToBounds=YES;
    _tuijianBtn.layer.cornerRadius=6;

    _allBtn.layer.masksToBounds=YES;
    _allBtn.layer.cornerRadius=6;
    return _secView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 94;
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
    wbvc.testPapper_id=_dataArray[indexPath.row][@"id"] ;
   // wbvc.testDic=[_dataArray[indexPath.row] mutableCopy];
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
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"QWCell" bundle:nil] forCellReuseIdentifier:@"QWCell"];//xib定制cell
    
    CGFloat h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?180:200):220;
    _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, h);
    _tableView.tableHeaderView=_headView;
    
    //[self setLabelSpace:_headText withValue:_headText.text withFont:[UIFont systemFontOfSize:16]];
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterPullToRefreshText:@"加载更多..."];
    

    
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
    if ([self.kinStr isEqualToString:@"趣味测量"]) {
        [dic setValue:@"趣味" forKey:@"tp_Type"];

    }else if([self.kinStr isEqualToString:@"专业测量"]){
        [dic setValue:@"专业" forKey:@"tp_Type"];

    }else if([self.kinStr isEqualToString:@"定制测量"]){
        [dic setValue:@"定制" forKey:@"tp_Type"];

    }
    
    [self loadData:dic];
    
}

- (void)loadMore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    if ([self.kinStr isEqualToString:@"趣味测量"]) {
        [dic setValue:@"趣味" forKey:@"tp_Type"];
        
    }else if([self.kinStr isEqualToString:@"专业测量"]){
        [dic setValue:@"专业" forKey:@"tp_Type"];
        
    }else if([self.kinStr isEqualToString:@"定制测量"]){
        [dic setValue:@"定制" forKey:@"tp_Type"];
        
    }
    
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
    
    [manger GET:SJUrl parameters:dicd success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}




- (IBAction)seachAction:(UIButton *)sender {
    SeachController *sss=[[SeachController alloc]init];
    sss.userDic=[self.userDic mutableCopy];
    sss.kinStr=self.kinStr;
    [self.navigationController pushViewController:sss animated:YES];

   
}


#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    SeachController *sss=[[SeachController alloc]init];
    sss.userDic=[self.userDic mutableCopy];
    sss.kinStr=self.kinStr;
    [self.navigationController pushViewController:sss animated:YES ];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_seaField resignFirstResponder];
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



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
