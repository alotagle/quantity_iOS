//
//  MainController.h
//  Quantity
//
//  Created by Luis Carino  on 2/16/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PRODUCTOS_AGREGADOS @"productos_agregados" 
#define INFO_PARA_RECIBO  @"RECIBO"
#define PROCUTO_SELECCIONADO @"seleccionado"
#define RECIBO_ENVIADO @"done_sending"

@interface MainController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelCambio;
- (IBAction)botonTarjeta:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *botonEfectivo;


@property NSMutableArray *productosParaRecibo;



@end
