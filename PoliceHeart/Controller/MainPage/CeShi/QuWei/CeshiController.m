//
//  CeshiController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/15.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "CeshiController.h"
#import "TextAnsCell.h"
#import "ImageAnsCell.h"
#import "ResultController.h"
#import "ControllerOne.h"
#import "MainController.h"
#import "ReportController.h"

#import "WoDeCLController.h"

#import "MasageController.h"

@interface CeshiController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_ansArray;
    NSMutableArray *_myAns;
    CGFloat Hig;
    BOOL _isfin;
    NSInteger _total,_index;
    NSString *_ua_id;
    
}
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (strong, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UILabel *ceshiTit;
@property (weak, nonatomic) IBOutlet UILabel *SUBTIT;
@property (weak, nonatomic) IBOutlet UILabel *progress;

@property (weak, nonatomic) IBOutlet UILabel *timu;
@property ( nonatomic)  UIImageView *tupian;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;
@property (strong, nonatomic) IBOutlet UIView *heaView;


@end

@implementation CeshiController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titLab.text=self.kinStr;
    _dataArray =[NSMutableArray new];
    _ansArray =[NSMutableArray new];
    _myAns=[NSMutableArray new];
    _index=1;
    _isfin=NO;
    _NavHig=SCREEN_HEIGHT>800?83:64;
    [self createHead];
    [self createTableView];

    [self getTest];
}
- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    _heaView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH,106 );
    [self.view addSubview:_heaView];
    
    
}
-(void)getTest{
    
    self.ceshiTit.text=self.testDic[@"tp_Name"];
    self.SUBTIT.text=[NSString stringWithFormat:@"题数:%@  平均用时:%@分钟  已完成人数:%@",self.testDic[@"tp_Counts"],self.testDic[@"tp_Long"],self.testDic[@"tp_TestCount"]];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10000" forKey:@"rows"];
   // [dic setValue:@"25" forKey:@"tp_id"];
    
    [dic setValue:self.testDic[@"id"] forKey:@"tp_id"];
    
    if (_userDic!=nil) {
        
        [dic setValue:self.userDic[@"id"] forKey:@"u_id"];
        [self loadData:dic url:DZSJUrl];


    }else{
        [dic setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"]] forKey:@"ua_BH"];
        //[dic setValue:[NSString stringWithFormat:@"%@",@"ddd"] forKey:@"ua_BH"];
        [self loadData:dic url:QWZYUrl];
    }
    
}

- (void)retest{
    _index=1;
    [_myAns removeAllObjects];
    
    NSDictionary *dic=_dataArray[_index-1];
    _ansArray=[_dataArray[_index-1][@"andArr"] mutableCopy];
    
    [self setNewTest:dic[@"que"] subText:dic[@"dis"] image:dic[@"image"] kind:[dic[@"kind"] integerValue]];
    _progress.text=[NSString stringWithFormat:@"进度:%ld/%ld",(long)_index,(long)_total];
    [_tableView reloadData];
}

- (void)loadData:(NSMutableDictionary *)dict url:(NSString *)url{
    [SVProgressHUD showWithStatus:@"试卷获取中..."  maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"试题-----%@",dict);

        if ([dict[@"Message"] isEqualToString:@"OK"]) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功!"];
            _total=[dict[@"totalRows"] integerValue];
            for (NSDictionary *dicssss in dict[@"result"]) {
                
                NSMutableDictionary *queDci=[NSMutableDictionary new];
                
                [queDci setValue:dicssss[@"tqb_First"] forKey:@"que"];
                
                if (dicssss[@"tqb_Second"]==[NSNull null]||[dicssss[@"tqb_Second"] isEqualToString:@"null"]||[dicssss[@"tqb_Second"] isEqualToString:@"<null>"]||[dicssss[@"tqb_Second"] isEqualToString:@""]) {
                    if (dicssss[@"tqb_Three"]==[NSNull null]||[dicssss[@"tqb_Three"] isEqualToString:@"null"]||[dicssss[@"tqb_Three"] isEqualToString:@"<null>"]||[dicssss[@"tqb_Three"] isEqualToString:@""]) {
                        
                        [queDci setValue:@"0" forKey:@"dis"];
                        [queDci setValue:@"0" forKey:@"image"];

                        [queDci setValue:@"2" forKey:@"kind"];

                    }else{
                        [queDci setValue:dicssss[@"tqb_Three"] forKey:@"dis"];
                        [queDci setValue:@"0" forKey:@"image"];
                        [queDci setValue:@"3" forKey:@"kind"];

                    }
                }else{
                    if (dicssss[@"tqb_Three"]==[NSNull null]||[dicssss[@"tqb_Three"] isEqualToString:@"null"]||[dicssss[@"tqb_Three"] isEqualToString:@"<null>"]||[dicssss[@"tqb_Three"] isEqualToString:@""]) {
                        [queDci setValue:@"1" forKey:@"kind"];
                        [queDci setValue:@"0" forKey:@"dis"];
                        [queDci setValue:dicssss[@"tqb_Second"] forKey:@"image"];
                    }else{
                        [queDci setValue:dicssss[@"tqb_Three"] forKey:@"dis"];
                        [queDci setValue:dicssss[@"tqb_Second"] forKey:@"image"];
                        [queDci setValue:@"0" forKey:@"kind"];
                    }
                }
                
                NSMutableArray *ansArr=[NSMutableArray new];
                ansArr=[dicssss[@"sj_TestQuestionsAnswer"] mutableCopy];
                [queDci setValue:ansArr forKey:@"andArr"];
                
                _ua_id=[NSString stringWithFormat:@"%@",dicssss[@"ua_id"]];

                [_dataArray addObject:queDci];
            }

            [self setDataWithIndex];
           //NSLog(@"dddd%d",_dataArray.count);
            
            
            
            
        }else{
            [SVProgressHUD showSuccessWithStatus:@"获取失败!"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];

}

- (void)setDataWithIndex{
    
    NSDictionary *dic=_dataArray[_index-1];
    _ansArray=[_dataArray[_index-1][@"andArr"] mutableCopy];
    
    [self setNewTest:dic[@"que"] subText:dic[@"dis"] image:dic[@"image"] kind:[dic[@"kind"] integerValue]];
    _progress.text=[NSString stringWithFormat:@"进度:%ld/%ld",(long)_index,(long)_total];
    
}

- (void)setNewTest:(NSString *)test subText:(NSString *)subText image:(NSString *)urlStr kind:(NSInteger)kin{
    /*
     0--题目，图片，描述
     1--题目，图片
     2--题目
     */
    
    if (_tupian==nil) {
        _tupian=[[UIImageView alloc]init];
        
        _tupian.contentMode=UIViewContentModeScaleToFill;
        [_secView addSubview:_tupian];

    }
   // NSLog(@"%@---\n%@\n%@",test,subText,urlStr);

    if (kin==0) {
        Hig=[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32]+(SCREEN_WIDTH-100*Rat)/49*40+[NSString stringPhsHight:subText font:15 width:SCREEN_WIDTH-32]+32;
        _timu.text=test;
        _miaoshu.text=subText;
        
        _tupian.frame=CGRectMake(50*Rat, 16+[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32], SCREEN_WIDTH-100*Rat, (SCREEN_WIDTH-100*Rat)/49*40);
        
        [_tupian setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,urlStr]]];
        [_secView addSubview:_tupian];
        _tupian.hidden=NO;
        _miaoshu.hidden=NO;

    }else if (kin==1){
        Hig=[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32]+(SCREEN_WIDTH-100*Rat)/49*40+24;
        _timu.text=test;
        _tupian.frame=CGRectMake(50*Rat, 16+[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32], SCREEN_WIDTH-100*Rat, (SCREEN_WIDTH-100*Rat)/49*40);
        [_tupian setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,urlStr]]];

        [_secView addSubview:_tupian];
        
        _miaoshu.hidden=YES;
        _tupian.hidden=NO;
        
    }else if (kin==2){
        Hig=[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32]+16;
        _timu.text=test;
        
        _tupian.frame=CGRectMake(50*Rat, 16+[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32], SCREEN_WIDTH-100*Rat, (SCREEN_WIDTH-100*Rat)/49*40);
        [_tupian setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,urlStr]]];

        [_secView addSubview:_tupian];
        
        _miaoshu.hidden=YES;
        
        _tupian.hidden=YES;

    }else{
        Hig=[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32]+[NSString stringPhsHight:subText font:15 width:SCREEN_WIDTH-32]+32;
        _timu.text=test;
        _miaoshu.text=subText;
        
        _tupian.frame=CGRectMake(50*Rat, 16+[NSString stringPhsHight:test font:15 width:SCREEN_WIDTH-32], SCREEN_WIDTH-100*Rat, (SCREEN_WIDTH-100*Rat)/49*40);
        [_secView addSubview:_tupian];
        
        
        _tupian.hidden=YES;
        _miaoshu.hidden=NO;

    }
    _secView.frame=CGRectMake(0, 0, SCREEN_WIDTH, Hig);
    
    [_tableView reloadData];

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    
    return _secView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Hig;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _ansArray.count;
    //return 4;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isfin) {
        NSMutableDictionary *dicc=[NSMutableDictionary new];
        [dicc setObject:_ua_id forKey:@"ua_id"];
        [dicc setObject:_ansArray[indexPath.row][@"tqb_id"] forKey:@"tq_id"];
        [dicc setObject:_ansArray[indexPath.row][@"tqa_Option"] forKey:@"uad_Option"];
        [dicc setObject:_ansArray[indexPath.row][@"tqa_Answer"] forKey:@"uad_Answer"];
        [dicc setObject:@"0" forKey:@"uad_Duration"];
        [dicc setObject:_ansArray[indexPath.row][@"tqa_Score"] forKey:@"uad_Score"];
        [dicc setObject:_ansArray[indexPath.row][@"tqa_Remark"] forKey:@"uad_Remark"];
        
        [_myAns addObject:dicc];
    }


    if (_index<_dataArray.count) {
        _index++;
        [self performSelector:@selector(setDataWithIndex) withObject:nil afterDelay:0.3];
      //  [self setDataWithIndex];
    }else{
        _isfin=YES;
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否提交答案？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提 交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendAnswer:_myAns];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ControllerOne class]]) {
                    ControllerOne *revise =(ControllerOne *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }];
        [cancelAction setValue:RGBCOLOR(250, 74, 64) forKey:@"_titleTextColor"];
        

        
        [alertController addAction:okAction];           // A
        [alertController addAction:cancelAction];

        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig+106, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-106) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(255, 255, 255);
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"ImageAnsCell" bundle:nil] forCellReuseIdentifier:@"ImageAnsCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"TextAnsCell" bundle:nil] forCellReuseIdentifier:@"TextAnsCell"];//xib定制cell

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=_dataArray[_index-1][@"andArr"];
    NSDictionary *ddd=arr[indexPath.row];

    if (self) {
        TextAnsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TextAnsCell"];
        cell.optLab.text=ddd[@"tqa_Option"];
        cell.ansLab.text=ddd[@"tqa_Answer"];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        return cell;
    }else{
        
        ImageAnsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ImageAnsCell"];
        
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        return cell;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)sendAnswer:(NSMutableArray *)arr{
   // NSMutableDictionary *dic=[NSMutableDictionary new];
  //  [dic setObject:[self objArrayToJSON:arr] forKey:@""];
    
    [SVProgressHUD showWithStatus:@"提交答案中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *url=[NSURL URLWithString:SendAns];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:[[self objArrayToJSON:arr] dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *respone,
                                               NSData *data,
                                               NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([data length]>0 && error==nil) {
                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //  NSLog(@"答案-----%@",dict);
                 
                 if ([dict[@"Status"] integerValue]==1) {
                     [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
                     
                     ResultController *wbvc=[[ResultController alloc]init];
                     
                     wbvc.kinStr=self.kinStr;;
                     wbvc.AnsId=_ua_id;
                    // wbvc.testDic=[_testDic mutableCopy];
                     
                     wbvc.userDic=[_userDic mutableCopy];
                     wbvc.testPapper_id=self.testPapper_id ;

                     wbvc.enter=self.enter;
                     [wbvc setActionRetest:^(NSString *kind) {
                         [self retest];
                     }];
                     
                     [self.navigationController pushViewController:wbvc animated:YES];
                     
                     
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"提交失败！"];
                 }
                 
             }else{
                 [SVProgressHUD showErrorWithStatus:@"提交失败！"];
             }
         });
     }];
    
    
}

- (NSString *)objArrayToJSON:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    NSString * str2 = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    
    return jsonString;
}

- (IBAction)goBack:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出测量？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退 出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // [SVProgressHUD showWithStatus:@"答题卡删除中..." maskType:SVProgressHUDMaskTypeGradient];

        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setValue:_ua_id forKey:@"ua_id"];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manger.requestSerializer.timeoutInterval = 20.f;
        [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manger GET:DetAns parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            // NSLog(@"试卷列表%@",dict);
            
            if ([dict[@"Message"] isEqualToString:@"OK"]) {
               
             //   [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
            }else{
             //   [SVProgressHUD showErrorWithStatus:@"删除失败！"];

            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
           // [SVProgressHUD showErrorWithStatus:@"删除失败！"];
        }];
        
        
        
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

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [okAction setValue:RGBCOLOR(250, 74, 64) forKey:@"_titleTextColor"];
    
    
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
