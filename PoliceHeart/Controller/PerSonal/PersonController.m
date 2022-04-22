//
//  PersonController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/2.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "PersonController.h"
#import "LoginController.h"

#import "HisAndNewsController.h"
#import "GRXXController.h"
#import "WoDeCLController.h"

@interface PersonController (){

    
}
@property (strong, nonatomic) IBOutlet UIView *heardView;
@property (strong, nonatomic) IBOutlet UIView *menu;

@property ( nonatomic)  UIImageView *icon;

@property ( nonatomic)  UIButton *bacBtn1;
@property (nonatomic ) NSMutableDictionary *userDic;

@end

@implementation PersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    

    
    if([[DataDefault shareInstance]userInfor]==nil){
        
    }else{
        
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
        
    }
    
    [self createView];


}


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    if([[DataDefault shareInstance]userInfor]==nil){
        
    }else{
        
        _userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
        
        [_icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
        [_bacBtn1 setTitle:[NSString stringWithFormat:@"%@",_userDic[@"au_Nme"]] forState:UIControlStateNormal];
    }
}

- (IBAction)selMenu:(UIButton *)sender {
    if([[DataDefault shareInstance]userInfor]==nil){
        if(sender.tag==2){
            HisAndNewsController* svc=[[HisAndNewsController alloc]init];
            svc.kinStr=@"帮助中心";
            svc.userDic=[_userDic mutableCopy];
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"请登录！"];

        }
    }else{
        if (sender.tag==0) {
            WoDeCLController* vc=[[WoDeCLController alloc]init];
            vc.userDic=[_userDic mutableCopy];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(sender.tag==1){
            HisAndNewsController* svc=[[HisAndNewsController alloc]init];
            svc.kinStr=@"设置";
            svc.userDic=[_userDic mutableCopy];
            
            [svc setLoginOut:^(NSMutableDictionary *useInf) {
                _userDic=nil;
                
                if([[DataDefault shareInstance]userInfor]==nil){
                    [_icon setImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"] ];
                    [_bacBtn1 setTitle:@"登 录" forState:UIControlStateNormal];
                    
                    
                }else{
                    [_icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
                    [_bacBtn1 setTitle:[NSString stringWithFormat:@"%@",_userDic[@"au_Nme"]] forState:UIControlStateNormal];
                    
                    
                }
                
            }];
            [self.navigationController pushViewController:svc animated:YES];
            
        }else if(sender.tag==2){
            HisAndNewsController* svc=[[HisAndNewsController alloc]init];
            svc.kinStr=@"帮助中心";
            svc.userDic=[_userDic mutableCopy];
            [self.navigationController pushViewController:svc animated:YES];
            
        }else{
            GRXXController*  vc=[[GRXXController alloc]init];
            vc.userDic=[_userDic mutableCopy];
            [vc setChangeInfSuccess:^(NSMutableDictionary *useInf) {
                _userDic=[useInf mutableCopy];
                
                
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)createView{
    _heardView.frame=CGRectMake(0, 64, SCREEN_WIDTH, 150*Rat);
    
    [self.view addSubview:_heardView];
    _icon=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH*0.08, 75*Rat-SCREEN_WIDTH*0.08-40, SCREEN_WIDTH*0.16, SCREEN_WIDTH*0.16)];
    
    _icon.layer.masksToBounds=YES;
    _icon.layer.cornerRadius=SCREEN_WIDTH*0.08;
    [_heardView addSubview:_icon];
    _icon.contentMode=UIViewContentModeScaleToFill;
    
    
    
    _bacBtn1=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 75*Rat+SCREEN_WIDTH*0.08-40, 100, 30)];
    [_bacBtn1 setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [_bacBtn1 setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateHighlighted];
    _bacBtn1.titleLabel.font=[UIFont systemFontOfSize:18];
    [_bacBtn1 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_heardView addSubview:_bacBtn1];
    
    
    
    if([[DataDefault shareInstance]userInfor]==nil){
        [_icon setImage:[UIImage imageNamed:@"icon_frg_wode_avatar_defaults.png"] ];
        [_bacBtn1 setTitle:@"登 录" forState:UIControlStateNormal];


    }else{
        [_icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
        [_bacBtn1 setTitle:[NSString stringWithFormat:@"%@",_userDic[@"au_Nme"]] forState:UIControlStateNormal];


    }
    
    
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80+150*Rat, SCREEN_WIDTH, 177)];
    //[bgImage setContentMode:UIViewContentModeScaleToFill];
    bgImage.image = [[UIImage imageNamed:@"per_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 30, 30) resizingMode:UIImageResizingModeStretch];

   // [self.view addSubview:bgImage];

    
    _menu.frame=CGRectMake(16, 90+150*Rat, SCREEN_WIDTH-32, 145);
    
    _menu.layer.shadowColor=[UIColor grayColor].CGColor;
    _menu.layer.shadowOffset=CGSizeMake(0, 1);
    _menu.layer.shadowOpacity=0.8;
    _menu.layer.shadowRadius=3.f;
    
    _menu.layer.cornerRadius=4;

    [self.view addSubview:_menu];
    
}

- (void)login{
    if([[DataDefault shareInstance]userInfor]==nil){
        LoginController *pvc=[[LoginController alloc]init];
        [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
            
            [[DataDefault shareInstance]setUserInfor:useinf];
            _userDic=[useinf mutableCopy];
            
            
            [_icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_userDic[@"au_ImgUrl"]]]];
            [_bacBtn1 setTitle:[NSString stringWithFormat:@"%@",_userDic[@"au_Nme"]] forState:UIControlStateNormal];
        }];
        
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
