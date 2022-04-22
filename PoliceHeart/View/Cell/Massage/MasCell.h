//
//  MasCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
