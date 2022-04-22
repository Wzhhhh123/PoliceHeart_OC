//
//  HisAndNewsController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/6.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "HisAndNewsController.h"
#import "SZAndXXCell.h"
#import "HelpCell.h"
#import "AboutController.h"

@interface HisAndNewsController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_opeArray;
}

@property (weak, nonatomic) IBOutlet UILabel *titLAB;

@property (strong, nonatomic) IBOutlet UIView *changePassView;
@property (strong, nonatomic) IBOutlet UIView *sureVIew;

@property (weak, nonatomic) IBOutlet UITextField *oldPass;
@property (weak, nonatomic) IBOutlet UITextField *surePass;
@property (weak, nonatomic) IBOutlet UITextField *passNew;
@property (strong, nonatomic) IBOutlet UIView *logOutView;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation HisAndNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.titLAB.text=self.kinStr;
    _dataArray=[NSMutableArray new];
    _NavHig=SCREEN_HEIGHT>800?83:64;

    [self createHead];
    [self createdata];
    [self createTableView];
    [self createPassView];
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

- (void)createdata{
    if ([self.kinStr isEqualToString:@"设置"]) {
        NSArray *arr=@[@{@"tit":@"修改密码",@"det":@">"},
                       @{@"tit":@"消息通知",@"det":@">"},
                       @{@"tit":@"清除缓存",@"det":@">"},
                       @{@"tit":@"关于我们",@"det":@">"}];
        [_dataArray addObjectsFromArray:arr];
    }else{
        _opeArray=[NSMutableArray new];
        NSArray *arr1=@[@0,@0,@0,@0];
        [_opeArray addObjectsFromArray:arr1];

        NSArray *arr=@[@{@"tit":@"1、什么是心理测量？",@"det":@"主要是指对人在智力、学习能力、学业成就、兴趣爱好、品德、个性等心理属性的行为样本进行客观的、标准化的量化测定。"},
                       @{@"tit":@"2、与物理特性的测量相比，心理测量有哪些特点？",@"det":@"1、间接性： 外显的行为样本反映内在的心理特性\n2、度量的参照点和单位是人为的、相对的，主要属于等级量表水平；\n3、测量误差大，测量结果精确度和稳定性较低。"},
                       @{@"tit":@"3、心理测量的一般原则",@"det":@"（一）标准化原则\n所谓标准化原则是指测验的：①标准化工具；②标准化指导语；③标准施测方法；④固定施测条件；⑤标准记分方法；⑥代表性常模。\n（二）保密原则\n保密涉及两个方面，一是测验工具的保密，二是测验结果的保密。任何一个心理测验的编制都是非常复杂的，是很多人经过多年辛勤工作的成果。一旦测验失去其价值，这些编制者的工作也就毁于一旦了。\n（三）客观性原则\n尽管测验结果有一定的预测性，然而不能依据一次测验结果来下定论。"},
                       @{@"tit":@"4、正确地对待和使用测验",@"det":@" 1.测验是研究心理学的一个重要方法和作决策的辅助工具\n 2.测验作为一个研究手段和测量工具尚不完善\n 3.为了更好发挥测验的效能，必须防止测验的乱编滥用"}];
        [_dataArray addObjectsFromArray:arr];
    }
    
}

- (void)createPassView{
    CGFloat shig=SCREEN_WIDTH>320?(SCREEN_HEIGHT>375?155:150):145;

    _changePassView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.view addSubview:_changePassView];
    
    
    
    _oldPass.delegate = self;
    _passNew.delegate = self;
    _surePass.delegate = self;
    
    _sureVIew.frame=CGRectMake(0, 250, SCREEN_WIDTH, shig);
    [_changePassView addSubview:_sureVIew];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.kinStr isEqualToString:@"设置"]) {
        UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        vv.backgroundColor=[UIColor clearColor];
        return vv;
    }else{

        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.kinStr isEqualToString:@"设置"]) {
        return 10.0;

    }else{
        
        return 0.00001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.kinStr isEqualToString:@"设置"]) {
        CGFloat h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?115:110):108;

        _logOutView.frame=CGRectMake(0, 0, SCREEN_WIDTH, h);
        _logOutView.backgroundColor=[UIColor clearColor];
        return _logOutView;
    }else{
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.kinStr isEqualToString:@"设置"]) {
        CGFloat h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?115:110):108;

        return h;

    }else{
        
        return 0.00001;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataArray.count;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.kinStr isEqualToString:@"设置"]) {
        if (indexPath.row==0) {
            [UIView animateWithDuration:0.4 animations:^{
                _changePassView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

            }];
        }
        if (indexPath.row==1) {
            
        }
        if (indexPath.row==2) {
            [self clearnCaches];
        }
        if (indexPath.row==3) {
            AboutController *abvc=[[AboutController alloc]init];
            [self.navigationController pushViewController:abvc animated:YES];
        }
    }else{
        BOOL op=![_opeArray[indexPath.row] boolValue];
        [_opeArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:op]];
        
        [_tableView reloadData];
    }
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    if ([self.kinStr isEqualToString:@"设置"]) {
        _tableView.backgroundColor=[UIColor clearColor];

    }else{
        
        _tableView.backgroundColor=[UIColor whiteColor];
    }
    
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"SZAndXXCell" bundle:nil] forCellReuseIdentifier:@"SZAndXXCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"HelpCell" bundle:nil] forCellReuseIdentifier:@"HelpCell"];//xib定制cell

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.kinStr isEqualToString:@"设置"]) {
        SZAndXXCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SZAndXXCell"];
        if (indexPath.row==1) {
            cell.detLab.hidden=YES;
        }else{
            cell.swit.hidden=YES;
        }
        cell.titLab.text=_dataArray[indexPath.row][@"tit"];
        cell.detLab.text=_dataArray[indexPath.row][@"det"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        HelpCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HelpCell"];
        if ([_opeArray[indexPath.row] boolValue]) {
            cell.queLab.text=[NSString stringWithFormat:@"%@\n%@",_dataArray[indexPath.row][@"tit"],_dataArray[indexPath.row][@"det"]];

        }else{
            cell.queLab.text=_dataArray[indexPath.row][@"tit"];

        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.kinStr isEqualToString:@"设置"]) {
        return 50;

    }else{
        if ([_opeArray[indexPath.row] boolValue]) {
            
            return [NSString stringPhsHight:[NSString stringWithFormat:@"%@\n%@",_dataArray[indexPath.row][@"tit"],_dataArray[indexPath.row][@"det"]] font:15 width:SCREEN_WIDTH-16]+50;
            
        }else{
            
            return [NSString stringPhsHight:_dataArray[indexPath.row][@"tit"] font:15 width:SCREEN_WIDTH-16]+50;
        }
    }
}

- (IBAction)logOut:(id)sender {
    [[DataDefault shareInstance]setUserInfor:nil];
    if (self.loginOut) {
        self.loginOut(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)sureChange:(id)sender {
    if (_oldPass.text.length>0) {
        if ([_passNew.text isEqualToString:_surePass.text]) {
            if (_passNew.text.length>5) {
                
                if ([_oldPass.text isEqualToString:_userDic[@"au_Password"]]) {
                    [SVProgressHUD showWithStatus:@"提交中..."  maskType:SVProgressHUDMaskTypeGradient];
                    NSMutableDictionary *diction=[NSMutableDictionary new];
                    [diction setValue:_userDic[@"id"] forKey:@"id"];
                    [diction setValue:_passNew.text forKey:@"au_Password"];
                    
                    
                    
                    NSURL *url=[NSURL URLWithString:XiuGaiUrl];
                    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPMethod:@"POST"];
                    [request setTimeoutInterval:20];
                    [request setHTTPBody:[[self objDictionToJSON:diction] dataUsingEncoding:NSUTF8StringEncoding]];
                    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
                    
                    [NSURLConnection sendAsynchronousRequest:request queue:queue
                                           completionHandler:^(NSURLResponse *respone,
                                                               NSData *data,
                                                               NSError *error)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([data length]>0 && error==nil) {
                                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                 // NSLog(@"答案-----%@",dict);
                                 
                                 if ([dict[@"Status"] integerValue]==1) {
                                     [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
                                     
                                     [_userDic setValue:_passNew.text forKey:@"au_Password"];

                                     [[DataDefault shareInstance]setUserInfor:_userDic];
                                     [UIView animateWithDuration:0.4 animations:^{
                                         _changePassView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                                         _oldPass.text=nil;
                                         _passNew.text=nil;
                                         _surePass.text=nil;
                                         [_oldPass resignFirstResponder];
                                         [_passNew resignFirstResponder];
                                         [_surePass resignFirstResponder];
                                     }];
                                     
                                 }else{
                                     [SVProgressHUD showErrorWithStatus:@"修改失败！"];
                                 }
                                 
                             }else{
                                 [SVProgressHUD showErrorWithStatus:@"修改失败！"];
                             }
                         });
                     }];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"旧密码错误!"];

                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"新密码最少6位！"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"新密码不一致！"];

        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码！"];
    }
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

- (IBAction)cancleChange:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        _changePassView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        _oldPass.text=nil;
        _passNew.text=nil;
        _surePass.text=nil;
        [_oldPass resignFirstResponder];
        [_passNew resignFirstResponder];
        [_surePass resignFirstResponder];
    }];
}

#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}


- (void)clearnCaches{
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    CGFloat fileSize=[self folderSizeAtPath:libPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存文件共%1.fM，是否清除？",fileSize] preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD showWithStatus:@"清理中..." maskType:SVProgressHUDMaskTypeGradient];

        NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        CGFloat fileSize=[self folderSizeAtPath:libPath];
        
        //  NSLog(@"jjjj%f",fileSize);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        
        //        NSLog(@"jjjj%f",[self folderSizeAtPath:path]);
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *p in files) {
            NSString *Path = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                //清理缓存,保留Preference,里面含有NSUserDefaults保存的信息
                if (![Path containsString:@"Preferences"]) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:nil];
                }
            }else{
                
            }
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"缓存清除成功！\n清除缓存%.1fM",fileSize]];
        
      //  [[DataDefault shareInstance] setIdArr:nil];
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
