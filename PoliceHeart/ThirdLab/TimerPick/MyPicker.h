//
//  MyPicker.h
//  DingEr
//
//  Created by Tcy on 2018/5/24.
//  Copyright © 2018年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyPickerDelegate <NSObject>
@optional
/**
 * 确定按钮
 */
-(void)didClickFinishMyPicker:(NSString*)str;
-(void)didClickFinishPicker:(NSInteger)rows   ;
/**
 * 取消按钮
 */
-(void)didClickCancelMyTimePicker;

@end

@interface MyPicker : UIView

/**
 * 现实数据
 */
@property(nonatomic, strong)NSArray *dataArr;
/**
 * 设置中心标题文字
 */
@property(nonatomic, strong)UILabel *titleL;

@property(nonatomic, strong)id<MyPickerDelegate>delegate;

/**
 * 掩藏
 */
- (void)hideDateTimePickerView;
/**
 * 显示
 */
- (void)showDateTimePickerView;

- (void)updatePickerWith:(NSMutableArray *)arr;

@end
