//
//  TCVc.m
//  TCTopAlertViewExample
//
//  Created by 程天聪 on 15/5/7.
//  Copyright (c) 2015年 Tc. All rights reserved.
//

#import "TCVc.h"
#import "TCTopAlertView.h"

@interface TCVc () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation TCVc

- (IBAction)success:(id)sender {
    [TCTopAlertView showMessage:_textField.text completion:nil];
}

- (IBAction)warning:(id)sender {

}


- (IBAction)error:(id)sender {

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

#pragma mark - TextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
