//
//  ReportCell.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfWithdic:(NSDictionary *)dic{
    if (dic[@"tp_Name"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"tp_Name"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"tp_Name"]] isEqualToString:@"<null>"]) {
        self.titLab.text=@" ";
        
    }else{
        self.titLab.text=[NSString stringWithFormat:@"%@",dic[@"tp_Name"]];

    }
//    if (dic[@"ua_Brief"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"ua_Brief"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"ua_Brief"]] isEqualToString:@"<null>"]) {
//        self.sbuit.text=@" ";
//        
//    }else{
//        self.sbuit.text=[NSString stringWithFormat:@"%@",dic[@"ua_Brief"]];
//
//    }
    if (dic[@"ua_StartTime"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"ua_StartTime"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"ua_StartTime"]] isEqualToString:@"<null>"]) {
        self.subTit2.text=@" ";
        
    }else{
        self.subTit2.text=[NSString stringWithFormat:@"%@",dic[@"ua_StartTime"]];

    }
    

    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"tp_BigImgUrl"]]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
