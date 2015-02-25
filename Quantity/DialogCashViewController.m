//
//  DialogCashViewController.m
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "DialogCashViewController.h"

@interface DialogCashViewController ()

@end

@implementation DialogCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.totalLabel.text =[ NSString stringWithFormat:@"$ %@",[self total]];
    
    [self.pagoTextField addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingChanged];
    
}



- (void)textFieldDidEnd:(UITextField *)textField{
    NSLog(@"Termino de editar");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    NSLog(@"On prepare for segue");
//}


- (IBAction)botonConfirmacion:(id)sender {
}

- (IBAction)cancelarButton:(id)sender {
    
    
}
@end
