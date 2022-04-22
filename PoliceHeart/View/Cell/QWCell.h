//
//  QWCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UIImageView *Imag;
@property (weak, nonatomic) IBOutlet UILabel *detLab;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *hitImage;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

- (void)setINf:(NSDictionary *)dic;


@end
