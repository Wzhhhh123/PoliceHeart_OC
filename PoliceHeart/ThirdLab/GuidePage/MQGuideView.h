//
//  MQGuideView.h
//  MQGuideView
//
//  Created by irs on 16/9/22.
//  Copyright © 2016年 zmq. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MQGuideViewDelegate <NSObject>
//代理方法 跳过引导页
-(void)onPassButtonPressed;
@end


@interface MQGuideView: UIView
@property (nonatomic,weak)  id<MQGuideViewDelegate> delegate;

@end
