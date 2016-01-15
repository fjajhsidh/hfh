//
//  HomeViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "LogineViewController.h"
#import "LinkViewController.h"
#import "KindsPickerView.h"
#import "JSBadgeView.h"
#import "AppDelegate.h"


@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *status; 
@property (weak, nonatomic) IBOutlet UIButton *myUnDo;
@property (weak, nonatomic) IBOutlet UIButton *myWaiteApprove;
@property (weak, nonatomic) IBOutlet UIButton *myMsg;

@property (weak, nonatomic) IBOutlet UIView *shouYeView;

@end

@implementation HomeViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginVC) name:@"logout" object:nil];
        NSLog(@"DA");
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([DataManager shareManager].account != nil){
        [self requestHomeData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureEnabel = NO;

    if ([DataManager shareManager].account == nil) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSLog(@"class:%@",[delegate.window.rootViewController class]);
        [self showLoginVC];
    }
    else{
        AccountModel *model = [DataManager shareManager].account;
        [self initInformation:model];
        //[self requestHomeData];
    }
    // Do any additional setup after loading the view.
    
    self.shouYeView.backgroundColor=[UIColor colorWithPatternImage:[[UIImage imageNamed:@"thinkape.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.shouYeView.contentMode=UIViewTintAdjustmentModeAutomatic;
}

- (void)showLoginVC{
    LogineViewController *log = [[LogineViewController alloc] init];
    log.logSuccess = ^(AccountModel *model){
        [self initInformation:model];
        [self requestHomeData];
    };
    [self presentViewController:log animated:NO completion:nil];
}

- (void)initInformation:(AccountModel *)model{
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.PicPath] placeholderImage:Default_Head_Image];
    self.userName.text = [NSString stringWithFormat:@"%@，欢迎您",model.Uname];
    NSLog(@"2223333333333333333333333333%@",model.Uname);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    self.time.text = [formatter stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestHomeData{
    //http://27.115.23.126:3032/Ashx/Mobilenew.ashx?ac=GetFirstInfo&u=1
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetFirstInfo&u=%@",self.uid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSLog(@"respons %@",responseObject);
                          /*
                           {
                           ac: "MyUnReceive", 我的未付款
                
                           },
                           {
                           ac: "Msg",  我的消息
                           num: "100"
                           },
                           {
                           ac: "myWaiteApprove",  我的待审批
                           num: "111"
                           },
                           {
                           ac: "MyUnComplete", 我的未完成
                           num: "111"
                           }
                           
                           */
                          
                          [SVProgressHUD dismiss];
                          NSArray *arr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          NSString *str = @"";
                          UIButton *tempBtn;
                          NSString *text;
                          for (NSDictionary *dic in arr) {
                              if (/*[[dic objectForKey:@"ac"] isEqualToString:@"审批中"] || */ [[dic objectForKey:@"ac"] isEqualToString:@"MyUnReceive"]) {
                                  
                                  str = [NSString stringWithFormat:@"%@待付款条数:%@   ",str,[dic objectForKey:@"num"]];
                                 // break;
                              }
                              else if ([[dic objectForKey:@"ac"] isEqualToString:@"Msg"]) {
                                  
                                 
                                  tempBtn = self.myMsg;
                                  if ([[dic objectForKey:@"num"]isEqualToString:@"0"]) {
                                      text=@"";
                                  }
                                  else{
                                  text = [dic objectForKey:@"num"];
                                  }
                              }
                              else if ([[dic objectForKey:@"ac"] isEqualToString:@"MyUnComplete"]){
                                  tempBtn = self.myUnDo;
                                  if ([[dic objectForKey:@"num"]isEqualToString:@"0"]) {
                                      text=@"";
                                  }else
                                  {
                                  text = [dic objectForKey:@"num"];
                                  }
                              }
                              else if ([[dic objectForKey:@"ac"] isEqualToString:@"myWaiteApprove"]){
                                  tempBtn = self.myWaiteApprove;
                                  if ([[dic objectForKey:@"num"]isEqualToString:@"0"]) {
                                      text=@"";
                                  }
                                  else{
                                  text = [dic objectForKey:@"num"];
                                  }
                              }
                              if (tempBtn) {
                                  JSBadgeView *view = (JSBadgeView *)[tempBtn viewWithTag:1024];
                                  if (!view) {
                                      view = [[JSBadgeView alloc] initWithParentView:tempBtn alignment:JSBadgeViewAlignmentTopRight];
                                      view.tag = 1024;
                                  }
                                  view.badgeText = text;
                              }
                          }
                          if (str.length == 0) {
                              str = @"审批中:元   待付款:元";
                          }
                         self.status.text = str;
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"unComplantToList"]){
        id toVC = segue.destinationViewController;
        [toVC setValue:@"未完成审批" forKey:@"titleStr"];
    
        [toVC setValue:[NSNumber numberWithBool:NO] forKey:@"undo"];
        self.istobe=NO;
        //wo
        AppDelegate * app=[UIApplication sharedApplication].delegate;
        app.danJu=@"未完成审批";
    }
    if ([segue.identifier isEqualToString:@"complantToList"]) {
        id toVC = segue.destinationViewController;
        [toVC setValue:@"已完成审批" forKey:@"titleStr"];
        [toVC setValue:[NSNumber numberWithBool:YES] forKey:@"undo"];
        self.istobe=YES;
        //wo
        AppDelegate * app=[UIApplication sharedApplication].delegate;
        app.danJu=@"已完成审批";
    }
    if ([segue.identifier isEqualToString:@"LinkVC"]) {
        LinkViewController *link = (LinkViewController *)segue.destinationViewController;
        link.linkStyle = 0;
        link.titleStr = @"联系人";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
