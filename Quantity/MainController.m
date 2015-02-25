//
//  MainController.m
//  Quantity
//
//  Created by Luis Carino  on 2/16/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "MainController.h"
#import "ConnectionHelper.h"
#import "DialogCashViewController.h"
#import "ConnectionHelper.h"


@interface MainController (){
    
    NSString *simpleTotal;
    
}

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.labelTotal setText:@"$ 0.00"];
    
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndSelectingItem:) name:PRODUCTOS_AGREGADOS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generaRecibo:) name:INFO_PARA_RECIBO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seAgregaElemento:) name:PROCUTO_SELECCIONADO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciboEnviado:) name:RECIBO_ENVIADO object:nil];
    
    
    self.productosParaRecibo = [[NSMutableArray alloc]init];
   
}


-(void)didEndSelectingItem:(NSNotification *)theNotification{
    NSDictionary *response = [theNotification userInfo];
   // NSLog([NSString stringWithFormat:@"En el callback de notificacion %@",response.description]);
    
    [self.labelCambio setText: [NSString stringWithFormat:@"TOTAL: $ %@",[response objectForKey:@"total"]]];
    simpleTotal = [NSString stringWithFormat:@"%@",[response objectForKey:@"total"]] ;
    
    
    //[self.productosParaRecibo addObject:response];
    
}

-(void)reciboEnviado:(NSNotification *)theNotification{
   // NSDictionary *response = [theNotification userInfo];
    //NSLog([NSString stringWithFormat:@"En el callback de notificacion recibo %@",response.description]);
    
}

-(void)generaRecibo:(NSNotification *)theNotification{
    NSDictionary *response = [theNotification userInfo];
     NSMutableString *theUrl = [[NSMutableString alloc]initWithString:@"https://quantitydgtic.appspot.com/_ah/api/recibos/v1/enviarRecibo?"];
    
    NSMutableString *theParameters = [[NSMutableString alloc]init];
    for(int i = 0; i < self.productosParaRecibo.count; i++){
        [theParameters appendString:[[self.productosParaRecibo objectAtIndex:i]objectForKey:@"descripcion"]];
        [theParameters appendString:@":"];
        [theParameters appendString:[[self.productosParaRecibo objectAtIndex:i]objectForKey:@"precio"]];
        
        if(i != self.productosParaRecibo.count-1)
           [theParameters appendString:@";"];
    }
    
    [theUrl appendString:@"cadenaProductos="];
    [theUrl appendString:theParameters];
    [theUrl appendString:@"&"];
    [theUrl appendString:@"correo="];
    [theUrl appendString:[response objectForKey:@"email"]];
    [theUrl appendString:@"&"];
    [theUrl appendString:@"mensaje="];
    [theUrl appendString:@"prueba"];
    [theUrl appendString:@"&nombre="];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    
    [theUrl appendString:username];
    
    NSString *stringFormat = [theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ConnectionHelper *cn = [[ConnectionHelper alloc] init];
    cn.opcionNotificacion = 3; //catalogos
    [cn consumeWebService:stringFormat];
    
    
   
}

-(void)seAgregaElemento:(NSNotification *)theNotification{
     NSDictionary *response = [theNotification userInfo];
     [self.productosParaRecibo addObject:response];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueToCash"]){
        DialogCashViewController *vc = [segue destinationViewController];
        
        vc.total = simpleTotal;
        
    }
}


- (IBAction)botonTarjeta:(id)sender {
}
@end
