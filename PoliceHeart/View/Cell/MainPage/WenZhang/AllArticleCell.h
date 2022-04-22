//
//  AllArticleCell.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/12.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *dianzan;
@property (weak, nonatomic) IBOutlet UIButton *liuLan;
@property (weak, nonatomic) IBOutlet UIButton *pingLun;
@property (weak, nonatomic) IBOutlet UILabel *author;

- (void)setInfo:(NSMutableDictionary *)dic;
@end
