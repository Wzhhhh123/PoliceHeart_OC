//
//  AllArticleCell.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/12.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "AllArticleCell.h"

@implementation AllArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)OptionKIn:(UIButton *)sender {
    
    
}

- (void)setInfo:(NSMutableDictionary *)dic{
    
    self.titLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Title"]]];
    self.author.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Author"]]];
    if ([NSString stringWithFormat:@"%@",dic[@"a_PublishTime"]].length>10) {
        self.time.text=[[NSString stringWithFormat:@"%@",dic[@"a_PublishTime"]] substringWithRange:NSMakeRange(0, 10)];
        
    }else{
        
        self.time.text=@"暂无";
        
    }
    //self.kinLab.text=[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_Brief"]]];
    
    [self.dianzan setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_LikeCount"]]] forState:UIControlStateNormal];
    [self.liuLan setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_ReadCount"]]] forState:UIControlStateNormal];
    [self.pingLun setTitle:[NSString checkStr:[NSString stringWithFormat:@"%@",dic[@"a_MsgCount"]]] forState:UIControlStateNormal];
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"a_ImgUrl"]]]];
    
    
    if ([dic[@"Is_Like"] integerValue]==1) {
        [self.dianzan setImage:[UIImage imageNamed:@"dianzai"] forState:UIControlStateNormal];
        
    }else{
        [self.dianzan setImage:[UIImage imageNamed:@"dianzai_n.png"] forState:UIControlStateNormal];
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

@end
