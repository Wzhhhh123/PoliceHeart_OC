//
//  QWCell.m
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "QWCell.h"

@implementation QWCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    _priceBtn.layer.masksToBounds=YES;
    _priceBtn.layer.cornerRadius=4;
}


- (void)setINf:(NSDictionary *)dic{
    if (dic[@"tp_Name"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"tp_Name"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"tp_Name"]] isEqualToString:@"<null>"]) {
        self.titLab.text=@" ";
        
    }else{
        self.titLab.text=[NSString stringWithFormat:@"%@",dic[@"tp_Name"] ];

    }
    
    
    
    if (dic[@"tp_Subtitle"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"tp_Subtitle"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"tp_Subtitle"]] isEqualToString:@"<null>"]) {
        self.detLab.text=@" ";

    }else{
        self.detLab.text=[NSString stringWithFormat:@"%@",dic[@"tp_Subtitle"] ];

    }
    [self.Imag setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"tp_BigImgUrl"]]]];
    
    
    if (dic[@"tp_Cost"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"tp_Cost"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"tp_Cost"]] isEqualToString:@"<null>"]) {
        [self.priceBtn setTitle:[NSString stringWithFormat:@"免费"] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:RGBCOLOR(21, 249, 155) forState:UIControlStateNormal];
        [self.priceBtn setBackgroundColor:RGBCOLOR(218, 250, 232)];
    }else{
        
        if ([dic[@"tp_Cost"] intValue]==0) {
            [self.priceBtn setTitle:[NSString stringWithFormat:@"免费"] forState:UIControlStateNormal];
            [self.priceBtn setTitleColor:RGBCOLOR(21, 249, 155) forState:UIControlStateNormal];
            [self.priceBtn setBackgroundColor:RGBCOLOR(218, 250, 232)];
        }else{
            
            [self.priceBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"tp_Cost"]] forState:UIControlStateNormal];
            [self.priceBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            [self.priceBtn setBackgroundColor:RGBCOLOR(60, 133, 190)];
        }
    }
    
    if (dic[@"tp_TestCount"] ==[NSNull null]||[[NSString stringWithFormat:@"%@",dic[@"tp_TestCount"]] isEqualToString:@"null"]||[[NSString stringWithFormat:@"%@",dic[@"tp_TestCount"]] isEqualToString:@"<null>"]) {
        self.numLab.text=[NSString stringWithFormat:@"0人测量过"];
        self.hitImage.hidden=YES;

    }else{
        self.numLab.text=[NSString stringWithFormat:@"%@人测量过",dic[@"tp_TestCount"]];

        if ([dic[@"tp_TestCount"] intValue]<50) {
            self.hitImage.hidden=YES;
        }else{
            self.hitImage.hidden=NO;
        }
    }
   
    
    
    
//    if ([dic[@"tp_Subtitle"] isKindOfClass:[NSNull class]]) {
//        self.detLab.text=@" ";
//
//    }else{
//        self.detLab.text=[NSString stringWithFormat:@"%@",dic[@"tp_Subtitle"] ];
//
//    }
//    [self.Imag setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,dic[@"tp_BigImgUrl"]]]];
//
//
//    if ([dic[@"tp_Cost"] isKindOfClass:[NSNull class]]) {
//        [self.priceBtn setTitle:[NSString stringWithFormat:@"免费"] forState:UIControlStateNormal];
//        [self.priceBtn setTitleColor:RGBCOLOR(21, 249, 155) forState:UIControlStateNormal];
//        [self.priceBtn setBackgroundColor:RGBCOLOR(218, 250, 232)];
//    }else{
//
//        if ([dic[@"tp_Cost"] intValue]==0) {
//            [self.priceBtn setTitle:[NSString stringWithFormat:@"免费"] forState:UIControlStateNormal];
//            [self.priceBtn setTitleColor:RGBCOLOR(21, 249, 155) forState:UIControlStateNormal];
//            [self.priceBtn setBackgroundColor:RGBCOLOR(218, 250, 232)];
//        }else{
//
//            [self.priceBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"tp_Cost"]] forState:UIControlStateNormal];
//            [self.priceBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
//            [self.priceBtn setBackgroundColor:RGBCOLOR(60, 133, 190)];
//        }
//    }
//
//    if ([dic[@"tp_TestCount"] isKindOfClass:[NSNull class]]) {
//        self.numLab.text=[NSString stringWithFormat:@"0人测量过"];
//        self.hitImage.hidden=YES;
//
//    }else{
//        self.numLab.text=[NSString stringWithFormat:@"%@人测量过",dic[@"tp_TestCount"]];
//
//        if ([dic[@"tp_TestCount"] intValue]<50) {
//            self.hitImage.hidden=YES;
//        }else{
//            self.hitImage.hidden=NO;
//        }
//    }
    
    
}
@end
