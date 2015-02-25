//
//  ReceiptConfirmationViewController.h
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ViewController.h"


#define INFO_PARA_RECIBO  @"RECIBO"
@interface ReceiptConfirmationViewController : ViewController

@property(nonatomic,strong) NSString* total;
- (IBAction)botonEnviarConfirmacion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputTextEmail;

@end
