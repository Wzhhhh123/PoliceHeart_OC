//
//  ReportCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *sbuit;
@property (weak, nonatomic) IBOutlet UILabel *subTit2;

- (void)setInfWithdic:(NSDictionary *)dic;


@end
