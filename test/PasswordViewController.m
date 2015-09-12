//
//  PasswordViewController.m
//  test
//
//  Created by Adron on 15/9/12.
//  Copyright (c) 2015年 Adron. All rights reserved.
//

#import "PasswordViewController.h"
#import "SuccessViewController.h"

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height
#define oneBackgroundHeight screenHeight/4.0
#define oneButtonHeight screenHeight/5.0
#define oneButtonWidth screenWidth/3.0

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userPass = @"";
    [self initView];
}

#pragma mark 初始化界面
- (void)initView {
    // 高亮图层
    _highView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 0)];
    [_highView setBackgroundColor:[UIColor colorWithRed:49/255.0 green:213/255.0 blue:134/255.0 alpha:1.0]];
    [self.view addSubview:_highView];
    
    // 顶部的密码指示
    _password = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, screenWidth, oneButtonHeight / 2 - 15)];
    [_password setText:@""];
    [_password setFont:[UIFont systemFontOfSize:40]];
    [_password setTextColor:[UIColor whiteColor]];
    [_password setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_password];
    
    // 界面的按钮
    UIButton *button;
    for (NSInteger i = 1; i <= 12; i++) {
        button = [[UIButton alloc] init];
        [button setTitle:[[NSNumber numberWithInteger:i] stringValue] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        if (i >= 1 && i <= 3) {
            [button setFrame:CGRectMake((i-1) * oneButtonWidth, oneButtonHeight / 2.0, oneButtonWidth, oneButtonHeight)];
        } else if (i >= 4 && i <= 6) {
            [button setFrame:CGRectMake((i-4) * oneButtonWidth, oneButtonHeight * 3 / 2, oneButtonWidth, oneButtonHeight)];
        } else if (i >= 7 && i <= 9) {
            [button setFrame:CGRectMake((i-7) * oneButtonWidth, oneButtonHeight * 5 / 2, oneButtonWidth, oneButtonHeight)];
        } else if (i >= 10 && i <= 12) {
            [button setFrame:CGRectMake((i-10) * oneButtonWidth, oneButtonHeight * 7 / 2, oneButtonWidth, oneButtonHeight)];
            if (i == 10) {
                [button setTitle:@"X" forState:UIControlStateNormal];
            } else if (i == 11) {
                [button setTitle:@"0" forState:UIControlStateNormal];
            } else if (i == 12) {
                [button setTitle:@"<--" forState:UIControlStateNormal];
            }
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont systemFontOfSize:26]];
        [self.view addSubview:button];
    }
    
}

- (void)clickOneButton:(UIButton *)sender {
    if (sender.tag != 10 && sender.tag != 11 && sender.tag != 12) {
        if (_password.text.length >= 4) {
            return;
        }
        _userPass = [_userPass stringByAppendingString:[[NSNumber numberWithInteger:sender.tag] stringValue]];
        [_password setText:[_password.text stringByAppendingString:@"*"]];
    }
    
    if (sender.tag == 11) {
        if (_password.text.length >= 4) {
            return;
        }
        _userPass = [_userPass stringByAppendingString:[[NSNumber numberWithInteger:0] stringValue]];
        [_password setText:[_password.text stringByAppendingString:@"*"]];
    }
    
    if (sender.tag == 10) {
        _userPass = @"";
        [_password setText:@""];
    }
    
    if (sender.tag == 12) {
        if (_password.text.length < 1) {
            return;
        }
        _userPass = [_userPass substringWithRange:NSMakeRange(0, _userPass.length - 1)];
        [_password setText:[_password.text substringWithRange:NSMakeRange(0, _password.text.length - 1)]];
    }
    
    NSLog(@"****%@", _userPass);
    [self animationWithHighBack:_password.text.length];
}

- (void)animationWithHighBack:(NSInteger)length {
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    [anim setValue:[NSNumber numberWithInteger:length] forKey:@"haha"];
    [anim setDuration:0.2];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGRect rect = CGRectMake(_password.frame.origin.x, screenHeight - length * oneBackgroundHeight, CGRectGetWidth(_password.frame), length * oneBackgroundHeight);
    anim.toValue = [NSValue valueWithCGRect:rect];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        // 这里可以判断是否登录了，如果输入的数字==4，则可以判断密码是否正确了
        if (_password.text.length >= 4 && [[anim valueForKey:@"haha"] integerValue] == 4) {
            // 判断用户密码是否正确
            NSLog(@"判断用户密码是否正确");
            if ([_userPass isEqualToString:@"1314"]) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                UIViewController *success = [story instantiateViewControllerWithIdentifier:@"success"];
                //由navigationController推向我们要推向的view
                [self.navigationController pushViewController:success animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"嘿嘿" message:@"你忘记你的密码啦~\(≧▽≦)/~啦啦啦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
    [_highView pop_addAnimation:anim forKey:@"fade"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
