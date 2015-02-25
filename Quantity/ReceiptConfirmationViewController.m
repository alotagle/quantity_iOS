//
//  ReceiptConfirmationViewController.m
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ReceiptConfirmationViewController.h"

@interface ReceiptConfirmationViewController ()

@end

@implementation ReceiptConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)botonEnviarConfirmacion:(id)sender {
    
    NSMutableDictionary *dictonaryConfirmation = [[NSMutableDictionary alloc]init];
    
    NSString *email = self.inputTextEmail.text;
    
    [dictonaryConfirmation setObject:email forKey:@"email"];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:INFO_PARA_RECIBO object:nil userInfo:dictonaryConfirmation];
    
    
}
@end
