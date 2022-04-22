//
//  MPageCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/2.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kinLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIImageView *Pic;
@property (weak, nonatomic) IBOutlet UIButton *liulanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinlunBtn;
@property (weak, nonatomic) IBOutlet UIButton *dianzanBtn;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *sjLab;


- (void)setInfo:(NSMutableDictionary *)dic;
@end
