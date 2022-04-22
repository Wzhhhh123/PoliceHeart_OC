//
//  MyPicker.m
//  DingEr
//
//  Created by Tcy on 2018/5/24.
//  Copyright © 2018年 Tcytachiever. All rights reserved.
//

#import "MyPicker.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
@interface MyPicker()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    NSInteger _selRow;
    
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MyPicker

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.alpha = 0;
        _selRow=0;
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
        contentV.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        
        [contentV addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [contentV addSubview:upVeiw];
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 52, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor clearColor];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [chooseButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), 0, SCREEN_WIDTH-104, 40)];
        [upVeiw addSubview:_titleL];
        _titleL.textColor = UIColorFromRGB(0x3f4548);
        _titleL.font = [UIFont systemFontOfSize:13];
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        //分割线
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 0.5)];
        splitView.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [upVeiw addSubview:splitView];

        [self.pickerView reloadAllComponents];
    }
    return self;
}

- (void)updatePickerWith:(NSMutableArray *)arr{
    _dataArr =[arr mutableCopy];
    _selRow=0;
    [self.pickerView reloadAllComponents];
    
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];

}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArr.count;
}
#pragma mark -- UIPickerViewDelegate
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 30)];
    label.font=[UIFont systemFontOfSize:16.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    label.text=_dataArr[row];

    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
        return SCREEN_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   _string =[NSString stringWithFormat:@"%@",[_dataArr objectAtIndex:row]];
    _selRow=row;
}



#pragma mark -- show and hidden
- (void)showDateTimePickerView{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220);
        _string =[NSString stringWithFormat:@"%@",[_dataArr objectAtIndex:0]];

    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideDateTimePickerView{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
}
#pragma mark - private
//取消的隐藏
- (void)cancelButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCancelMyTimePicker)]) {
        [self.delegate didClickCancelMyTimePicker];
    }
    
    [self hideDateTimePickerView];
    
}

//确认的隐藏
-(void)configButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishMyPicker:)]) {
        [self.delegate didClickFinishMyPicker:_string];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishPicker:)]) {
        [self.delegate didClickFinishPicker:_selRow];
    }
    [self hideDateTimePickerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideDateTimePickerView];
}

@end
