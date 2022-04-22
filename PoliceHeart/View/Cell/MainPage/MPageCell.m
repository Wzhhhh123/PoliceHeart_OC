//
//  MPageCell.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/2.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "MPageCell.h"

@implementation MPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setInfo:(NSMutableDictionary *)dic{
    
    self.titLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Title"]]];
    self.timeLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Author"]]];
    if ([NSString stringWithFormat:@"%@",dic[@"a_PublishTime"]].length>10) {
        self.sjLab.text=[[NSString stringWithFormat:@"%@",dic[@"a_PublishTime"]] substringWithRange:NSMakeRange(0, 10)];

    }else{
        
        self.sjLab.text=@"暂无";

    }
    self.kinLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Brief"]]];
    
    [self.dianzanBtn setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_LikeCount"]]] forState:UIControlStateNormal];
    [self.liulanBtn setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_ReadCount"]]] forState:UIControlStateNormal];
    [self.pinlunBtn setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_MsgCount"]]] forState:UIControlStateNormal];
    
    [self.Pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"a_ImgUrl"]]]];

    if ([dic[@"Is_Like"] integerValue]==1) {
        [self.dianzanBtn setImage:[UIImage imageNamed:@"dianzai"] forState:UIControlStateNormal];

    }else{
        [self.dianzanBtn setImage:[UIImage imageNamed:@"dianzai_n.png"] forState:UIControlStateNormal];

    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    
    _footView.backgroundColor=RGBACOLOR(44, 44, 44, 0.4);
    // Configure the view for the selected state
}
- (IBAction)dianzan:(UIButton *)sender {
    
    NSLog(@"点赞第%ld个",(long)self.tag);
}

@end
