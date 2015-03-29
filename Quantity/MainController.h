//
//  MainController.h
//  Quantity
//
//  Created by Luis Carino  on 2/16/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

#define PRODUCTOS_AGREGADOS @"productos_agregados" 
#define INFO_PARA_RECIBO  @"RECIBO"
#define PRODUCTO_SELECCIONADO @"seleccionado"
#define RECIBO_ENVIADO @"done_sending"
#define LIMPIA_DATOS @"LIMPIA"

@interface MainController : UIViewController <PayPalPaymentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelCambio;
- (IBAction)botonTarjeta:(id)sender;
@property NSMutableArray *productosParaRecibo;

@end
