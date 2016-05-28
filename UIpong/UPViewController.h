//
//  UPViewController.h
//  UIpong
//
//  Created by Adriel Tan on 8/9/15.
//  Copyright (c) 2015 Aydereal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *enemyPaddle;
@property (weak, nonatomic) IBOutlet UIView *playerPaddle;
@property (weak, nonatomic) IBOutlet UIView *ball;
@property (weak, nonatomic) IBOutlet UILabel *enemyLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;

@end
