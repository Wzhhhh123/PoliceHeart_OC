//
//  CLListCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImag;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


- (void)setInfWithdic:(NSDictionary *)dic;
@end
