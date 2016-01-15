//
//  LogineViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/26.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "LogineViewController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"


@interface LogineViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) UIView *netView;

@property(strong,nonatomic)NSString * password;


@end

@implementation LogineViewController
{
    BOOL _wasKeyboardManagerEnabled;
    CGFloat textFiled_Y;
    CGFloat distance;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    textFiled_Y = 0;
    distance = 0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    self.userText.placeholder=@"请输入用户名";
    self.passwordText.placeholder=@"请出入密码";
    
    [self readNSUserDefaults];
}
- (IBAction)textFiledHideen:(id)sender {
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
}

#pragma mark -NSNotificationCenter

- (void)keyboardShow:(NSNotification *)notification{
    NSDictionary *keyBoardInfo = [notification userInfo];
    NSValue *aValue = [keyBoardInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [aValue CGRectValue];
    CGFloat keyBoard_Y = rect.origin.y;
    if (textFiled_Y > keyBoard_Y && textFiled_Y != 0) {
        distance = textFiled_Y - keyBoard_Y + 100;
        self.view.frame = CGRectMake(0, -distance, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)keyboardHiden:(NSNotification *)notification{
    textFiled_Y = 0;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - TextFiledDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _userText) {
        textFiled_Y = _userView.frame.origin.y + textField.frame.size.height + 5;
    }
    else if (textField == _passwordText){
        textFiled_Y = _passwordView.frame.origin.y + textField.frame.size.height + 5;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClick:(id)sender {
    
    if (self.userText.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
    }
    else if (self.passwordText.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
    }
    else{
        [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=Login&u=%@&pwd=%@",_userText.text,_passwordText.text]
                       parameters:nil
                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                              NSDictionary *msgDic = [responseObject objectForKey:@"msg"];
                              AccountModel *account = [AccountModel objectWithKeyValues:msgDic];
                              [[DataManager shareManager] saveAccount:msgDic];
                              [SVProgressHUD dismiss];
                              if (self.logSuccess) {
                                  self.logSuccess(account);
                              }
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                          }];
        
    }
    
    [self saveNSUserDefaults];

}


//wo保存用户名和密码到NSUserDefaults中
-(void)saveNSUserDefaults{
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.userText.text.length!=0) {
        if (self.passwordText.text!=0) {
            
            [userDefaults setObject:self.passwordText.text forKey:@"password"];
            [userDefaults setObject:self.userText.text forKey:@"user"];
            
            [userDefaults synchronize];
        }
    }
    



}
//wo提取NSUserDefaults中的用户名和密码
-(void)readNSUserDefaults{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.userText.text=[userDefaultes stringForKey:@"user"];
    self.passwordText.text=[userDefaultes stringForKey:@"password"];

}



- (IBAction)chooseNetSet:(UIButton *)sender {
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
    [self clickSetNet];
}

- (void)clickSetNet{
    
    UIAlertView *netSetAlert = [[UIAlertView alloc]initWithTitle:@"服务器地址设置"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
    netSetAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [netSetAlert textFieldAtIndex:0];
    textfield.placeholder = @"输入服务器地址";
    textfield.keyboardType = UIKeyboardTypeASCIICapable;
    textfield.text = [DataManager shareManager].webDomain;
    [netSetAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        [DataManager shareManager].webDomain = textfield.text;
    }
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
