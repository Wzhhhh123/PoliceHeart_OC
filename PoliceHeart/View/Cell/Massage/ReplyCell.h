//
//  ReplyCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/12/12.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zjIcon;
@property (weak, nonatomic) IBOutlet UILabel *zjTit;
@property (weak, nonatomic) IBOutlet UILabel *hfCount;
@property (weak, nonatomic) IBOutlet UILabel *hfTime;

@property (weak, nonatomic) IBOutlet UIImageView *usIcon;
@property (weak, nonatomic) IBOutlet UILabel *usLiuyan;
@property (weak, nonatomic) IBOutlet UILabel *usTime;
@property (weak, nonatomic) IBOutlet UILabel *usName;
@property (weak, nonatomic) IBOutlet UILabel *sigLab;
@end
