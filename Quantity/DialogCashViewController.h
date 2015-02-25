//
//  DialogCashViewController.h
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ViewController.h"

@interface DialogCashViewController : ViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *cambioLabel;
@property (weak, nonatomic) IBOutlet UITextField *pagoTextField;
- (IBAction)botonConfirmacion:(id)sender;

@property (nonatomic,strong) NSString* total;

@end
