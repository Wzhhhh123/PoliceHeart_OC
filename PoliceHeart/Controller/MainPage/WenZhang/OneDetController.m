//
//  OneDetController.m
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "OneDetController.h"
#import "EvaluateCell.h"
#import "LoginController.h"

#import "ReplyCell.h"

@interface OneDetController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate>{
    
    UITableView *_tableView;
    CGFloat headHig;
    NSMutableArray *_dataArray;
    
}

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *hdImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *dianzan;

@property (weak, nonatomic) IBOutlet UIButton *liulan;
@property (weak, nonatomic) IBOutlet UIButton *pinglun;

@property (strong, nonatomic) IBOutlet UIView *secView;
@property (strong, nonatomic) IBOutlet UIView *plView;
@property (weak, nonatomic) IBOutlet UITextField *plField;

@property (weak, nonatomic) IBOutlet UIButton *dzBtn;
@property (strong, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet UIWebView *webDet;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@end

@implementation OneDetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _dataArray =[NSMutableArray new];
    headHig=200;
    _NavHig=SCREEN_HEIGHT>800?83:64;
    
    [self createHead];
    if (self.kinStr==1) {
        [self setDate];
        [self createTableView];
    }else{
        
        [self loadeArticleData];
    }
    
    
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
- (void)loadeArticleData{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:_lm_ObjId forKey:@"WZ_ArticleID"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
        [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];
    }else{
        [dic setValue:@"ios " forKey:@"au_RegistrationId"];
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:ArtDet parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"sddddd文章列表%@",dic);
        
        
        if ([dic[@"Message"] isEqualToString:@"OK"]) {
          
            _inf=[dic[@"result"][0] mutableCopy];
            
            [self setDate];
            [self createTableView];
        }else{
            //[SVProgressHUD showErrorWithStatus:@"暂无留言！"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取文章失败！"];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [_webDet.scrollView removeObserver:self forKeyPath:@"contentSize"];

    
    [_inf setObject:[NSString stringWithFormat:@"%d",[_inf[@"a_ReadCount"] integerValue]+1] forKey:@"a_ReadCount"];
    if (self.actionDianZan) {
        self.actionDianZan(_inf, self.intage);
    }
}
- (void)setDate{
    
    self.titLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_Title"]]];
    self.author.text=[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_Author"]]];
    if ([NSString stringWithFormat:@"%@",_inf[@"a_PublishTime"]].length>10) {
        self.timeLab.text=[[NSString stringWithFormat:@"%@",_inf[@"a_PublishTime"]] substringWithRange:NSMakeRange(0, 10)];
    }else{
        self.timeLab.text=@"暂无";
    }
    [self.dianzan setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_LikeCount"]]] forState:UIControlStateNormal];
    if ([_inf[@"Is_Like"] integerValue]==0) {
        [self.dianzan setImage:[UIImage imageNamed:@"dianzai_g.png"] forState:UIControlStateNormal];
        [self.dzBtn setImage:[UIImage imageNamed:@"dianzai_bg.png"] forState:UIControlStateNormal];
    }else{
        [self.dianzan setImage:[UIImage imageNamed:@"dianzai"] forState:UIControlStateNormal];
        [self.dzBtn setImage:[UIImage imageNamed:@"dianzai_b"] forState:UIControlStateNormal];

    }
    [self.liulan setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_ReadCount"]]] forState:UIControlStateNormal];
    [self.pinglun setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_MsgCount"]]] forState:UIControlStateNormal];
    
    [self.hdImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_inf[@"a_ImgUrl"]]]];
    
    _webDet.delegate=self;
    
    
    
    NSString *head = @"<head><style>* {font-size:15px}{color:#212121;}img{ width:100%; height: auto; }</style></head>";
    NSString *resultStr = [NSString stringWithFormat:@"<html>%@<body>%@</body></html>",head,_inf[@"a_Content"]];
    
    
    [_webDet loadHTMLString:[NSString stringWithFormat:@"%@",resultStr] baseURL:nil];
    
   // headHig=500+SCREEN_WIDTH*385/750+120;

    
    
    _webDet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webDet.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];


    [SVProgressHUD showWithStatus:@"文章加载中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    
    [_webDet stringByEvaluatingJavaScriptFromString:str];
    [SVProgressHUD showSuccessWithStatus:@"加载完成！"];
    _webDet.scrollView.scrollEnabled = NO;

    //[_tableView reloadData];
    
    [self loadeLiuYan];

}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGPoint point = [change[@"new"] CGPointValue];
        
        CGFloat height = point.y;
       // NSLog(@"point.y---%f",height);
        
        CGSize fittingSize = [_webDet sizeThatFits:CGSizeZero];
        
        CGFloat webHeight = fittingSize.height;
        
        headHig=webHeight+70;

        [_tableView reloadData];

    }
}


- (void)loadeLiuYan{
    
    [_dataArray removeAllObjects];

    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:_lm_ObjId forKey:@"lm_ObjId"];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger GET:WZLYList parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
      //  NSLog(@"sddddd文章列表%@",dic);
        
        
        if ([dic[@"Message"] isEqualToString:@"OK"]) {
            NSArray *liuyanArr=dic[@"result"];

            for (NSDictionary *dict in liuyanArr) {
                NSMutableDictionary *diction=[NSMutableDictionary new];
                [diction setObject:[NSString stringWithFormat:@"%@",dict[@"au_ImgUrl"]] forKey:@"au_ImgUrl"];
                [diction setObject:[NSString stringWithFormat:@"%@",dict[@"lm_Content"]] forKey:@"lm_Content"];
                [diction setObject:[NSString stringWithFormat:@"%@",dict[@"lm_Time"]] forKey:@"lm_Time"];
                [diction setObject:[NSString stringWithFormat:@"%@",dict[@"lm_Name"]] forKey:@"lm_Name"];
                NSArray *arrres=dict[@"wz_ArticleLeaveMeg"];
                if ([arrres count]>0) {
                    for (NSDictionary *dictionary in arrres) {
                        NSMutableArray *arr=[NSMutableArray new];
                        
                        NSMutableDictionary *liuyan=[NSMutableDictionary new];
                        [liuyan setObject:[NSString stringWithFormat:@"%@",dictionary[@"au_ImgUrl"]] forKey:@"au_ImgUrl"];
                        [liuyan setObject:[NSString stringWithFormat:@"%@",dictionary[@"lm_Content"]] forKey:@"lm_Content"];
                        [liuyan setObject:[NSString stringWithFormat:@"%@",dictionary[@"lm_Time"]] forKey:@"lm_Time"];
                        [liuyan setObject:[NSString stringWithFormat:@"%@",dictionary[@"lm_Name"]] forKey:@"lm_Name"];
                        
                        [arr addObject:liuyan];
                        [diction setObject:arr forKey:@"lm_LeaveMessage"];
                        [_dataArray addObject:diction];
                    }
                }else{
                    //NSArray *arr;
                    //[diction setObject:arr forKey:@"lm_LeaveMessage"];
                    [_dataArray addObject:diction];
                }
            }

            [_tableView reloadData];
            
        }else{
            //[SVProgressHUD showErrorWithStatus:@"暂无留言！"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取留言失败！"];
        
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        _secView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
        return _secView;

    
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

        return  _dataArray.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-60) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(255, 255, 255);
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"EvaluateCell" bundle:nil] forCellReuseIdentifier:@"EvaluateCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"ReplyCell" bundle:nil] forCellReuseIdentifier:@"ReplyCell"];//xib定制cell

    _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH*385/750+90 );
    _tableView.tableHeaderView=_headView;
    
    
    _maskView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_maskView];
    _maskView.hidden=YES;
    _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [self.view addSubview:_plView];
    
    _plField.delegate=self;

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
            
            [cell.zjIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_dataArray[indexPath.row][@"au_ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
            cell.hfCount.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Content"]];
            cell.hfTime.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"lm_Time"]];
            cell.zjTit.text=[NSString stringWithFormat:@"%@ ",_dataArray[indexPath.row][@"lm_Name"]];
            
            cell.zjTit.textColor=[UIColor darkGrayColor];
            cell.sigLab.hidden=YES;
            
            
            [cell.usIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"au_ImgUrl"]]]];
            cell.usLiuyan.text=[NSString stringWithFormat:@"%@",dic[@"lm_Content"]];
            cell.usTime.text=[NSString stringWithFormat:@"%@",dic[@"lm_Time"]];
            cell.usName.text=[NSString stringWithFormat:@"%@ 回复",dic[@"lm_Name"]];

            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            EvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EvaluateCell"];
            
            [cell.ico setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_dataArray[indexPath.row][@"au_ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"]];
            cell.user.text=[NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"lm_Name"]];
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




- (IBAction)dianzan:(id)sender {
    
    [self dianZanGongNeng];

    
}

- (void)dianZanGongNeng{
    
    NSMutableDictionary *dicc=[NSMutableDictionary new];
    [dicc setValue:_inf[@"id"] forKey:@"lr_Object"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] length]>0) {
        [dicc setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"] forKey:@"au_RegistrationId"];
    }else{
        [dicc setValue:@"ios " forKey:@"au_RegistrationId"];
    }
    
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Basic%@%@",@" ",_userDic[@"Ticket"]] forHTTPHeaderField:@"Authorization"];
    
    [manger GET:WZDZ parameters:dicc success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
      //  NSLog(@"点赞-----%@",dict);
        
        if ([dict[@"Status"] integerValue]==1) {
            _inf=[dict[@"Data"][0] mutableCopy];

            if ([_inf[@"Is_Like"] integerValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功!"];
                [self.dzBtn setImage:[UIImage imageNamed:@"dianzai_bg"] forState:UIControlStateNormal];

                [self.dianzan setImage:[UIImage imageNamed:@"dianzai_g.png"] forState:UIControlStateNormal];
                if ([[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_LikeCount"]]] integerValue]>1) {
                    [self.dianzan setTitle:[NSString stringWithFormat:@"%ld",[[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_LikeCount"]]] integerValue]] forState:UIControlStateNormal];
                    
                }else{
                    [self.dianzan setTitle:@"0" forState:UIControlStateNormal];
                    
                }
                
            }else{
                [SVProgressHUD showSuccessWithStatus:@"点赞成功!"];
                [self.dzBtn setImage:[UIImage imageNamed:@"dianzai_b"] forState:UIControlStateNormal];

                [self.dianzan setImage:[UIImage imageNamed:@"dianzai"] forState:UIControlStateNormal];
                if ([[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_LikeCount"]]] integerValue]>1) {
                    [self.dianzan setTitle:[NSString stringWithFormat:@"%ld",[[NSString checkStr:[NSString stringWithFormat:@"%@",_inf[@"a_LikeCount"]]] integerValue]] forState:UIControlStateNormal];
                    
                }else{
                    [self.dianzan setTitle:@"1" forState:UIControlStateNormal];
                    
                }
                
            }

            
        }else{
                
                
            [SVProgressHUD showErrorWithStatus:@"点赞失败！"];

        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"点赞失败！"];
    }];
    
}

- (IBAction)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)resignInput:(id)sender {
    [_plField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50);
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        
    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
        _plField.text=nil;
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
        
        _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50-height);
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
        _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50);
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        
    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
        
    }];
}


#pragma mark--TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    _maskView.hidden=NO;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        CGFloat h=SCREEN_WIDTH>321?(SCREEN_WIDTH>376?271:258):253;
//
//        _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50-h);
//        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50-h, SCREEN_WIDTH, 50);
//    } completion:^(BOOL finished) {
//
//    }];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig-50);
        _plView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);

    } completion:^(BOOL finished) {
        _maskView.hidden=YES;
        
        [self sendLiuYan];
    }];
    return YES;
}

- (void)sendLiuYan{
    if (_plField.text.length>0) {
        
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
    [dicc setValue:self.lm_ObjId forKey:@"lm_ObjId"];
    [dicc setValue:[NSString nowTimeStyle4] forKey:@"lm_Time"];
    [dicc setValue:@"文章" forKey:@"lm_Type"];
    [dicc setValue:_userDic[@"au_Nme"] forKey:@"lm_Name"];
    [dicc setValue:_plField.text forKey:@"lm_Content"];
    [dicc setValue:@"ios" forKey:@"lm_Remark"];
    
    [SVProgressHUD showWithStatus:@"提交留言中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *url=[NSURL URLWithString:WZLY];
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
                   // NSLog(@"答案-----%@",dict);
                 
                 if ([dict[@"Status"] integerValue]==1) {
                     [SVProgressHUD showSuccessWithStatus:@"留言成功!"];
                     
                     _plField.text=nil;
                     [self loadeLiuYan];
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



- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString

{
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
