//
//  UPViewController.m
//  UIpong
//
//  Created by Adriel Tan on 8/9/15.
//  Copyright (c) 2015 Aydereal. All rights reserved.
//

#import "UPViewController.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface UPViewController ()
@property (nonatomic) NSTimer *myTimer;
@property (nonatomic) float enemySpeed;
@property (nonatomic) float ballSpeedX;
@property (nonatomic) float ballSpeedY;
@property (nonatomic) float prevRoundBallSpeed;
@property (nonatomic) int playerScore;
@property (nonatomic) int enemyScore;
@property (nonatomic) BOOL isBallMoving;

-(void) animateEnemy;
@end

@implementation UPViewController
static const float kEnemySpeed = 0.75;
static const float kMaxWindowWidth = 320;
static const float kMinWindowWidth = 0;
static const float kMaxWindowHeight = 480;
static const float kBallSpeedX = 2.0;
static const float kBallSpeedY = 2.0;
static const float kBallSpeedIncrement = 0.2;


- (void)viewDidLoad
{
    self.enemyLabel.transform = CGAffineTransformMakeRotation(degreesToRadian(180));
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self newGame];
}

-(void)newGame
{
    self.enemyScore = 0;
    self.playerScore = 0;
    UIAlertView *myAlert =[[UIAlertView alloc]initWithTitle: (NSString *)@"Pong"
                                                    message: (NSString *)@"Are you ready to play?"
                                                   delegate: self
                                          cancelButtonTitle: (NSString *)@"YEAH!"
                                          otherButtonTitles: nil];
    [myAlert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self newRound];
    }
}

- (void)newRound
{
    self.ball.center = CGPointMake(kMaxWindowWidth/2, kMaxWindowHeight/2);
    self.ballSpeedX = (((arc4random()%2)*2)-1.0)*kBallSpeedX;
    self.ballSpeedY = (((arc4random()%2)*2)-1.0)*kBallSpeedY;
    NSLog(@"X: %f", self.ballSpeedX);
    NSLog(@"Y: %f", self.ballSpeedY);
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/50.0 target:self selector:@selector(timerAnimate) userInfo:nil repeats:YES];
    self.enemySpeed = kEnemySpeed;
    self.isBallMoving = YES;
    [self displayScores];
}

- (void) endRound: (NSString *)winner
{
    self.isBallMoving = NO;
    [self.myTimer invalidate];
    self.myTimer = nil;
    if([winner isEqualToString:@"green"]){
        self.enemyScore += 1;
    }else{
        self.playerScore += 1;
    }
    if(self.enemyScore >= 5){
        self.enemyLabel.text = @"Winner!";
        self.playerLabel.text= @"Loser";
        [self newGame];
        return;
    } else if(self.playerScore >= 5){
        self.enemyLabel.text = @"Loser";
        self.playerLabel.text= @"Winner!";
        [self newGame];
        return;
    }else{
        NSString *alertText = [NSString stringWithFormat:@"%@ wins this round.", winner];
        UIAlertView *myAlert =[[UIAlertView alloc]initWithTitle: (NSString *)@"Pong"
                                                        message: (NSString *)alertText
                                                       delegate: self
                                              cancelButtonTitle: (NSString *)@"Next round"
                                              otherButtonTitles: nil];
        [myAlert show];
    }
}

- (void) displayScores
{
    NSString *labelText = [NSString stringWithFormat:@"%d", self.enemyScore];
    self.enemyLabel.text = labelText;
    NSString *labelText2 = [NSString stringWithFormat:@"%d", self.playerScore];
    self.playerLabel.text = labelText2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches){
        CGPoint playerPaddlePoint = self.playerPaddle.center;
        CGPoint enemyPaddlePoint = self.enemyPaddle.center;
        CGPoint touchieTouchie  = [touch locationInView:self.view];
        NSLog(@"X: %f   Y: %f", touchieTouchie.x, touchieTouchie.y);
        float newX = touchieTouchie.x;
        if(touchieTouchie.x < kMinWindowWidth+self.enemyPaddle.frame.size.width/2){
            newX = kMinWindowWidth+self.enemyPaddle.frame.size.width/2;
        }
        else if(touchieTouchie.x > kMaxWindowWidth-self.enemyPaddle.frame.size.width/2){
            newX = kMaxWindowWidth-self.enemyPaddle.frame.size.width/2;
        }
        if(touchieTouchie.y>kMaxWindowHeight/2){
            self.playerPaddle.center = CGPointMake(newX, playerPaddlePoint.y);
        } else {
            self.enemyPaddle.center = CGPointMake(newX, enemyPaddlePoint.y);
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
}

-(void)timerAnimate
{
    [self animateBall];
}

-(void) animateEnemy
{
    CGPoint paddlePoint = self.enemyPaddle.center;
    CGSize paddleSize = self.enemyPaddle.frame.size;
    
    if(self.enemySpeed > 0 && (paddlePoint.x+paddleSize.width/2) > kMaxWindowWidth){
        self.enemySpeed = -kEnemySpeed;
    } else if(self.enemySpeed < 0 && (paddlePoint.x-paddleSize.width/2) < kMinWindowWidth){
        self.enemySpeed = kEnemySpeed;
    }
    self.enemyPaddle.center = CGPointMake(paddlePoint.x + self.enemySpeed, paddlePoint.y);
}

-(void) animateBall
{
    if(self.isBallMoving){
        CGPoint ballPoint = self.ball.center;
        CGSize ballSize = self.ball.frame.size;
        
        if(self.ballSpeedX > 0 && (ballPoint.x+ballSize.width/2) > kMaxWindowWidth){
            self.ballSpeedX = -kBallSpeedX;
        } else if(self.ballSpeedX < 0 && (ballPoint.x-ballSize.width/2) < kMinWindowWidth){
            self.ballSpeedX = kBallSpeedX;
        }
        if(ballPoint.y > (kMaxWindowHeight+ballSize.width)){
            [self endRound: @"green"];
            return;
        }else if(ballPoint.y < (0-ballSize.width)){
            [self endRound: @"blue"];
            return;
        }
        if(CGRectIntersectsRect(self.ball.frame, self.enemyPaddle.frame)){
            self.ballSpeedY = fabsf(self.ballSpeedY) + kBallSpeedIncrement;
            if(self.ballSpeedX>0){
                self.ballSpeedX = fabsf(self.ballSpeedX) + kBallSpeedIncrement;
            }else{
                self.ballSpeedX = -fabsf(self.ballSpeedX) - kBallSpeedIncrement;
            }
        }else if (CGRectIntersectsRect(self.ball.frame, self.playerPaddle.frame)){
            self.ballSpeedY = -fabsf(self.ballSpeedY) - kBallSpeedIncrement;
            if(self.ballSpeedX>0){
                self.ballSpeedX = fabsf(self.ballSpeedX) + kBallSpeedIncrement;
            }else{
                self.ballSpeedX = -fabsf(self.ballSpeedX) - kBallSpeedIncrement;
            }
        }
        self.ball.center = CGPointMake(ballPoint.x + self.ballSpeedX, ballPoint.y + self.ballSpeedY);
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
