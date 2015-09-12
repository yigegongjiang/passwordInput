//
//  PasswordViewController.h
//  test
//
//  Created by Adron on 15/9/12.
//  Copyright (c) 2015年 Adron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface PasswordViewController : UIViewController

@property (nonatomic, strong) UILabel *password;// 用户的密码，用*显示出来
@property (nonatomic, strong) NSString *userPass;// 用户的密码，隐藏显示
@property (nonatomic, strong) UIView *highView;// 显示用户密码输入数目的动态背景

@end
