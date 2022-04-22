//
//  WZDetCell.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/13.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "WZDetCell.h"


@interface WZDetCell ()<UIWebViewDelegate>


@end


@implementation WZDetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[SVProgressHUD showWithStatus:@"加载中..."  maskType:SVProgressHUDMaskTypeGradient];

    _detWeb.delegate=self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    
    [_detWeb stringByEvaluatingJavaScriptFromString:str];
    //[SVProgressHUD showSuccessWithStatus:@"加载完成！"];

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
