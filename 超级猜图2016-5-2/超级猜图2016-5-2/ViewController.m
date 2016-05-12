//
//  ViewController.m
//  超级猜图2016-5-2
//
//  Created by 十大大 on 16/5/2.
//  Copyright © 2016年 Y. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *TheImage;
@property (weak, nonatomic) IBOutlet UILabel *Indexing;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *coin;

@property (weak, nonatomic) IBOutlet UIButton *nextButton1;
@property (weak, nonatomic) IBOutlet UILabel *TheTitle;
@property (weak, nonatomic) IBOutlet UIView *AnswerView;
@property (weak, nonatomic) IBOutlet UIView *OptionView;

@property (weak, nonatomic) IBOutlet UIButton *BiggerButton;
@property (weak, nonatomic) IBOutlet UIButton *TipsButton;
@property CGRect allorigin;
@property (weak, nonatomic) UIButton *cover;
@property (nonatomic,assign)int index;
@property (nonatomic,assign)int state;
@property (nonatomic,assign)int state2;
@property (nonatomic,strong) NSArray* Question;
- (IBAction)TheNext;
- (IBAction)TheImageBigger;
- (IBAction)ImageBig:(UIButton *)sender;
-(void)setImageView:(Question *)Dict;
-(void)setAnswerView:(UIView *)AnswerView :(Question *)Dict;
-(void)optionButton:(Question *)Dict :(UIView *)OptionView;
-(void)optionButtonTouch;
@end

@implementation ViewController
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*-(BOOL)prefersStatusBarHidden
{
    return YES;
}*/

//懒加载数据
- (NSArray*)Question
{
    if (_Question==nil) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"Question.plist" ofType:nil];
        NSArray *arrayDict=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *MyModel=[NSMutableArray array];
        for (NSDictionary *Dict in arrayDict) {
            Question *Model=[Question QuestionWithDict:Dict];
            [MyModel addObject: Model];
        }
        _Question=MyModel;
        
        
    }
    return _Question;
}
-(void)setviewDidLoad
{
    CGFloat TheImageX =(self.view.frame.size.width-self.TheImage.frame.size.width)/2;
    CGRect origin=self.TheImage.frame;
    origin.origin.x=TheImageX;
    self.TheImage.frame=origin;
    self.allorigin=self.TheImage.frame;
    CGRect nextButtonorigin;
    nextButtonorigin= self.nextButton1.frame;
    CGFloat nextButtonX =TheImageX+_TheImage.frame.size.width+10;
    nextButtonorigin.origin.x=nextButtonX;
    
    self.nextButton1.frame=nextButtonorigin;
    
    CGRect BiggerButtonorigin;
    BiggerButtonorigin= self.BiggerButton.frame;
    CGFloat BiggerButtonX;
    BiggerButtonX =TheImageX-self.BiggerButton.frame.size.width -10;
    BiggerButtonorigin.origin.x=BiggerButtonX;
    self.BiggerButton.frame=BiggerButtonorigin;
    
    CGRect TipsButtonorigin;
    TipsButtonorigin= self.TipsButton.frame;
    CGFloat TipsButtonX;
    TipsButtonX =BiggerButtonX;
    TipsButtonorigin.origin.x=TipsButtonX;
    self.TipsButton.frame=TipsButtonorigin;
    
    CGRect helpButtonorigin;
    helpButtonorigin=self.helpButton.frame;
    CGFloat helpButtonX=nextButtonX;
    helpButtonorigin.origin.x=helpButtonX;
    self.helpButton.frame=helpButtonorigin;
    
    CGFloat IndexingX=(self.view.frame.size.width-self.Indexing.frame.size.width)/2;
    CGRect Indexingorigin=self.Indexing.frame;
    Indexingorigin.origin.x=IndexingX;
    self.Indexing.frame=Indexingorigin;
    
    CGFloat theTitleX=(self.view.frame.size.width-self.TheTitle.frame.size.width)/2;
    CGRect thetitleorigin=self.TheTitle.frame;
    thetitleorigin.origin.x=theTitleX;
    self.TheTitle.frame=thetitleorigin;
    
    CGRect coinorigin=self.coin.frame;
    coinorigin.origin.x=self.view.frame.size.width-self.coin.frame.size.width;
    self.coin.frame=coinorigin;
}
//程序开始加载初始界面
- (void)viewDidLoad {
    
    [self setviewDidLoad];
    [super viewDidLoad];
    [self.AnswerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //self.index++;
    if (self.index==(_Question.count-1)) {
        _nextButton1.enabled=NO;
    }
    Question *Dict= self.Question[self.index];
    
    //设置上方显示图片、标题
    [self setImageView:Dict];
    
    //动态生成答案选择按钮
    [self setAnswerView:_AnswerView :Dict];

    [self optionButton:Dict :_OptionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//下一张 按钮
- (IBAction)TheNext {
    
    self.index++;
    
    if (self.index==(_Question.count-1)) {
        _nextButton1.enabled=NO;
    }       //超出图片数量禁用
    
    Question *Dict= self.Question[self.index];
    
    //设置上方显示图片、标题
    [self setImageView:Dict];
    
    //动态生成答案选择按钮
    [self setAnswerView:_AnswerView :Dict];
    
    [self optionButton:Dict :_OptionView];
}

//设置上方显示图片、标题(实现)
-(void)setImageView:(Question *)Dict
{
    [_TheImage setImage:[UIImage imageNamed:Dict.icon] forState:UIControlStateNormal];
    _TheTitle.text=Dict.title;
    int Num;
    Num=self.index;
    _Indexing.text=[NSString stringWithFormat:@"%i/10",Num+1];
}
//动态生成答案选择按钮(实现)
-(void)setAnswerView:(UIView *)AnswerView :(Question *)Dict
{
    NSInteger len=Dict.answer.length;
    [self.AnswerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //这里开始生成子控件
    for (int i=0; i<len; i++) {     //美观妥协
        if (len>5) {
            len=5;
        }
        CGFloat answerX;     //描述小选框答案的尺寸布局
        CGFloat answerY=0;
        CGFloat answerW=35;
        CGFloat answerH=35;
        CGFloat margin=5;
        CGFloat marginleft =(self.view.frame.size.width-len*answerW-(len-1)*margin)/2;
        
        
        UIButton *AnswerChoose=[[UIButton alloc]init];
        [self.AnswerView addSubview:AnswerChoose];
        answerX = marginleft +i*(answerW+margin);
        AnswerChoose.frame = CGRectMake(answerX, answerY, answerW, answerH);
        [AnswerChoose setBackgroundImage:[UIImage imageNamed:@"while"] forState:UIControlStateNormal];
        [AnswerChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
//图片直接点击放大 缩小
- (IBAction)TheImageBigger {
    if (self.state==NO) {
        [self biggerButton];
        self.state++;
    }
    else {
        
        [self smallerButton];
        self.state--;
    }
    
}
//点击放大按钮放大
- (IBAction)ImageBig:(UIButton *)sender {
    
    [self biggerButton];
    self.state++;
}
//点击暗处缩小
-(void)smaller
{
    [self smallerButton];
    
    self.state--;
}

//放大、缩小图片（实现）//暗处遮蔽（实现）
-(void)biggerButton
{
    //动态生成backImage
    UIButton *backImage=[[UIButton alloc]init];
    backImage.frame=self.view.bounds;
    backImage.backgroundColor=[UIColor blackColor];
    backImage.alpha=0;
    [self.view addSubview:backImage];
    [self.view bringSubviewToFront:self.TheImage];
    self.cover=backImage;
    CGFloat TheImageW=self.view.frame.size.width;
    CGFloat TheImageH=TheImageW;
    CGFloat TheImageY=(self.view.frame.size.height-TheImageH)/2;
    CGFloat TheImageX=0;
    
    [UIView animateWithDuration:0.7 animations:^{
        self.TheImage.frame=CGRectMake(TheImageX, TheImageY, TheImageW, TheImageH);
        backImage.alpha=0.6;
    }];
    [backImage addTarget:self action:@selector(smaller) forControlEvents:UIControlEventTouchUpInside];
}
-(void)smallerButton
{
    
    [UIView animateWithDuration:0.7 animations:^{
        //self.TheImage.frame=CGRectMake(origin, origin, origin, origin);
        self.TheImage.frame=self.allorigin;
        self.cover.alpha=0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.cover removeFromSuperview];
        }
    }];
}


-(void)optionButton:(Question *)Dict :(UIView *)OptionView
{
    
    [self.OptionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //设计按钮frame
    int colums=7;       //每行按钮个数
    
    
    CGFloat optionWeight=35;
    CGFloat optionHeight=35;
    CGFloat margin=10;  //边界
    CGFloat marginH=25;
    CGFloat marginW=15;
    CGFloat marginLeft=(OptionView.frame.size.width-colums*optionWeight-(colums-1)*marginW)/2 ;
    CGFloat marginTop =(OptionView.frame.size.height-(Dict.optional.count/colums)*optionHeight-Dict.optional.count/colums*marginH)/2;
    
    for (int i=0; i<Dict.optional.count; i++) {
        CGFloat optionX=marginLeft+(i%colums)*marginW+(i%colums)*optionWeight;
        CGFloat optionY=marginTop +(i/colums)*optionHeight+(i/colums)*marginH ;
        
        
        UIButton *optionbutton=[[UIButton alloc]init];
        optionbutton.frame=CGRectMake(optionX, optionY, 35, 35);
        [optionbutton setBackgroundImage:[UIImage imageNamed:@"while"] forState:UIControlStateNormal];
        NSArray *words=Dict.optional;
        [optionbutton setTitle:words[i] forState:UIControlStateNormal];
        [optionbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.OptionView addSubview:optionbutton];
        [optionbutton addTarget:self action:@selector(optionButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)optionButtonTouch:(UIButton *)sender
{
    BOOL stop=YES;
    sender.alpha=0.1;
    NSString *textOfChoiseButton= sender.currentTitle;
    //textOfChoiseButton=[sender titleForState:UIControlStateNormal];
    for (UIButton *option in self.AnswerView.subviews) {
        if (option.currentTitle==nil) {
            [option setTitle:textOfChoiseButton forState:UIControlStateNormal];
            stop=NO;
            break;
        }
        
    }
    
    if (stop) {
        self.OptionView.userInteractionEnabled=NO;
    }
}
@end
