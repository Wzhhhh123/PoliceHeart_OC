//
//  GRXXController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "GRXXController.h"
#import "SheZhiCell.h"
#import "DateTimePickerView.h"
#import "MyPicker.h"

@interface GRXXController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MyPickerDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIImage *_icon;
    NSInteger selInt;
    
    UIView *foot;
}

@property (nonatomic, strong) DateTimePickerView *datePickerView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) MyPicker *xbPicker;
@property (nonatomic, strong) MyPicker *hyPicker;
@property (nonatomic, strong) MyPicker *xlPicker;

@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;


@end

@implementation GRXXController
- (UIImagePickerController *)imagePicker{
    if (nil == _imagePicker) {
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        {
            self.navigationController.navigationBar.translucent = NO;
        }
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
        
        _imagePicker.view.backgroundColor = [UIColor whiteColor];
        [_imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"photoHeader.png"] forBarMetrics:UIBarMetricsDefault];
        _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(22, 22, 22)};
        [[UINavigationBar appearance] setTintColor:RGBCOLOR(22, 22, 22)];
        
        
        //  _imagePicker.navigationBar.backgroundColor=RGBCOLOR(48, 88, 123);
    }
    return _imagePicker;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _NavHig=SCREEN_HEIGHT>800?83:64;
    [self createHead];
    NSLog(@"gggggg%@",_userDic);
    [self createData];
    [self createTableView];
    [self createMaskView];
}

- (void)createHead{
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
}

- (void)createData{
    NSArray *arr=@[@"头像",@"昵称",@"性别",@"生日",@"婚姻状况",@"学历",@"职业"];
    _dataArray =[NSMutableArray new];
    [_dataArray addObjectsFromArray:arr];
    
}

- (void)createMaskView{
    self.datePickerView = [[DateTimePickerView alloc] init];
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateMode;
    [self.view addSubview:_datePickerView];
    
    self.xbPicker = [[MyPicker alloc] init];
    _xbPicker.delegate = self;
    _xbPicker.dataArr =@[@"男",@"女",];
    [self.view addSubview:_xbPicker];
    
    self.hyPicker = [[MyPicker alloc] init];
    _hyPicker.dataArr =@[@"已婚",@"未婚"];
    _hyPicker.delegate = self;
    [self.view addSubview:_hyPicker];
    
    self.xlPicker = [[MyPicker alloc] init];
    _xlPicker.delegate = self;
    _xlPicker.dataArr =@[@"小学",@"初中",@"高中",@"专科",@"本科",@"硕士研究生",@"博士研究生"];
    [self.view addSubview:_xlPicker];
    

}

- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
   if (indexPath.row==0) {
       [self showActSheet];
    }else if (indexPath.row==1) {
        [self showAlertView:indexPath.row];
    }else if (indexPath.row==2) {
        selInt=2;
        [_xbPicker showDateTimePickerView];
    }else if (indexPath.row==3) {
        [_datePickerView showDateTimePickerView];

    }else if (indexPath.row==4) {
        selInt=4;
        [_hyPicker showDateTimePickerView];

    }else if (indexPath.row==5) {
        selInt=5;
        [_xlPicker showDateTimePickerView];

    }else if (indexPath.row==6) {
        [self showAlertView:indexPath.row];

    }
}
- (void)showAlertView:(NSInteger )inta{
    NSString *str;
    if (inta==1) {
        str=@"请输入昵称";
    }else{
        str=@"请输入职业";

    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = str;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框文本
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        if (envirnmentNameTextField.text.length>0) {
            if (inta==1) {
                [_userDic setValue:envirnmentNameTextField.text forKey:@"au_Nickname"];
                [_userDic setValue:envirnmentNameTextField.text forKey:@"au_Nme"];
            }else{
                
                [_userDic setValue:envirnmentNameTextField.text forKey:@"au_Position"];

            }
            [_tableView reloadData];

        }
        //输出 检查是否正确无误
       // NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        
    }]];
    
    //添加一个取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cancelAction setValue:RGBCOLOR(250, 74, 64) forKey:@"_titleTextColor"];

    //present出AlertView
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];

}
#pragma mark - MyPicker delegate
-(void)didClickFinishMyPicker:(NSString *)str{
    if (selInt==2) {
        [_userDic setValue:str forKey:@"au_Sex"];
    }else  if (selInt==4) {
        [_userDic setValue:str forKey:@"au_Marriage"];
    }else{
        
        [_userDic setValue:str forKey:@"au_Education"];
        
    }
    [_tableView reloadData];
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    [_userDic setValue:date forKey:@"au_Birthday"];

    [_tableView reloadData];

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
    
    [_tableView registerNib:[UINib nibWithNibName:@"SheZhiCell" bundle:nil] forCellReuseIdentifier:@"SheZhiCell"];//xib定制cell

    
    foot=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-10 ,SCREEN_WIDTH, 10)];
    foot.backgroundColor=[UIColor clearColor];
    [self.view addSubview:foot];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SheZhiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SheZhiCell"];
    cell.titLab.text=_dataArray[indexPath.row];
    
    if (indexPath.row==0) {
        cell.iconImage.hidden=NO;
        
        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
        
    }else{
        cell.iconImage.hidden=YES;
        if (indexPath.row==1) {
            cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Nme"]];

        }else if (indexPath.row==2) {
            cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Sex"]];

        }else if (indexPath.row==3) {
            if ([NSString stringWithFormat:@"%@",_userDic[@"au_Birthday"]].length>10) {
                cell.detLab.text=[NSString stringWithFormat:@"%@ >",[[NSString stringWithFormat:@"%@",_userDic[@"au_Birthday"]] substringWithRange:NSMakeRange(0, 10)]];

            }else{

                cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Birthday"]];
                
            }

        }else if (indexPath.row==4) {
            cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Marriage"]];

        }else if (indexPath.row==5) {
            cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Education"]];

        }else {
            cell.detLab.text=[NSString stringWithFormat:@"%@ >",_userDic[@"au_Position"]];

        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 60;
    }else{
        return 52;
    }
}

- (IBAction)baoCun:(id)sender {
    
    [SVProgressHUD showWithStatus:@"保存中..."  maskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *url=[NSURL URLWithString:XiuGaiUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:[[self dictoJSONString:_userDic] dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *respone,
                                               NSData *data,
                                               NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([data length]>0 && error==nil) {
                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 if ([dict[@"Status"] integerValue]==1) {
                     [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                     
                     [[DataDefault shareInstance]setUserInfor:_userDic];
                     if (self.changeInfSuccess) {
                         self.changeInfSuccess(_userDic);
                     }
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"保存失败！"];
                 }
                 
             }else{
                 [SVProgressHUD showErrorWithStatus:@"保存失败！"];
             }
         });
     }];
}


- (void)showActSheet{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    
    [mediaTypes addObject:( NSString *)kUTTypeImage];
    
    [mediaTypes addObject:( NSString *)kUTTypeMovie];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if(status == PHAuthorizationStatusRestricted ||
           status == PHAuthorizationStatusDenied){
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置-隐私”选项中，允许访问您的相册。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePicker.mediaTypes = [NSArray arrayWithObject:mediaTypes[0]];//设置媒体类型为public.image
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }
        }
    }];
    
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        BOOL hasPermission = YES;
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            hasPermission = NO;
        }
        if (!hasPermission) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置-隐私”选项中，允许访问您的相机。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker.mediaTypes =[NSArray arrayWithObject:mediaTypes[0]];//设置媒体类型为public.image
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
                NSLog(@"camera is no available!");
            }
        }
        
    }];
    
    [alertC addAction:action0];
    [alertC addAction:action1];
    [alertC addAction:action2];
    
    if([self deviceIsPhone]){
        
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [alertC popoverPresentationController];
        popPresenter.sourceView = foot; // 这就是挂靠的对象
        popPresenter.sourceRect =  foot.bounds;
        [self presentViewController:alertC animated:YES completion:nil];
    }
}


#pragma mark - 上传图片

- (void)upLoadImage:(UIImage *)image {
    
    [SVProgressHUD showWithStatus:@"上传头像中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *urlstring=UpIconUrl;
    //NSString *poststr=@"";
    NSData *imgData=UIImageJPEGRepresentation(image, 0.9f);
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary, nil];
    
    NSURL *url=[NSURL URLWithString:urlstring];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"iphonefile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *respone,
                                               NSData *data,
                                               NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([data length]>0 && error==nil) {
                 
                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 if([dict[@"Return_Url"] length]>0){
                     [SVProgressHUD showSuccessWithStatus:@"上传成功！"];
                     [_userDic setValue:dict[@"Return_Url"] forKey:@"au_ImgUrl"];
                     
                     [_tableView reloadData];
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"上传失败！"];
                 }
             }else{
                 [SVProgressHUD showErrorWithStatus:@"上传失败！"];
             }
         });
        
     }
     ];
}




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _icon = [UIImage simpleImage:orgImage];
    
    [self upLoadImage:[UIImage simpleImage:orgImage]];
    
}

- (NSString *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.7f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    UIImage *datImage=[UIImage imageWithData:data];
    NSData *imagedata = UIImageJPEGRepresentation(datImage, 0.7f);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return image64;
    
}

- (NSString *)dictoJSONString:(NSMutableDictionary *)arr {
    [arr removeObjectForKey:@"au_Password"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


- (BOOL)deviceIsPhone{
    
    BOOL _isIdiomPhone = YES;// 默认是手机
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    // 项目里只用到了手机和pad所以就判断两项
    // 设备是手机
    if (currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        _isIdiomPhone = YES;
    }
    // 设备室pad
    else if (currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        
        _isIdiomPhone = NO;
    }
    
    return _isIdiomPhone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
