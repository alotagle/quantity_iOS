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
    
    NSString *email = self.inputTextEmail.text;
    NSString *elError = nil;
    
    // VALIDACIÓN DE CORREO ELECTRÓNICO
    NSString *laExpresion = @"[A-Z0-9a-z_%+-]+(\\.[A-Z0-9a-z_%+-]+)*@[A-Za-z0-9]+([\\-]*[A-Za-z0-9])*(\\.[A-Za-z0-9]+([\\-]*[A-Za-z0-9])*)*\\.[A-Za-z]{2,}";
    
    // NSPredicate para ver si cuample una condición
    NSPredicate *pruebaEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", laExpresion];
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email isEqual:@""]) {
        elError = @"Ingresa tu correo electrónico";
    } else if([email length] < 6 || [email length] > 64) {
        elError = @"Longitud de correo electrónico incorrecta, mínimo 6 y máximo 64";
    } else if (![pruebaEmail evaluateWithObject:email]) {
        elError = @"No es una dirección de correo electrónico válida";
    }
    
    if (elError) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:elError delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [av show];
    } else {
        NSMutableDictionary *dictonaryConfirmation = [[NSMutableDictionary alloc] init];
        
        [dictonaryConfirmation setObject:email forKey:@"email"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:INFO_PARA_RECIBO object:nil userInfo:dictonaryConfirmation];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
