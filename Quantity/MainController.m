//
//  MainController.m
//  Quantity
//
//  Created by Luis Carino  on 2/16/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "MainController.h"
#import "ConnectionHelper.h"


@interface MainController () {
    NSString *simpleTotal;
}

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end


@implementation MainController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
        
        _payPalConfiguration.languageOrLocale = @"es_MX";
        _payPalConfiguration.alwaysDisplayCurrencyCodes = YES;
        _payPalConfiguration.presentingInPopover = NO;
        _payPalConfiguration.disableBlurWhenBackgrounding = YES;
        _payPalConfiguration.merchantName = @"Quantity";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productosParaRecibo = [[NSMutableArray alloc] init];
    
    [self limpiaDatos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndSelectingItem:) name:PRODUCTOS_AGREGADOS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generaRecibo:) name:INFO_PARA_RECIBO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seAgregaElemento:) name:PRODUCTO_SELECCIONADO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciboEnviado:) name:RECIBO_ENVIADO object:nil];
}


-(void)didEndSelectingItem:(NSNotification *)theNotification {
    NSDictionary *response = [theNotification userInfo];

    simpleTotal = [NSString stringWithFormat:@"%@",[response objectForKey:@"total"]];
    
    [self.labelCambio setText: [NSString stringWithFormat:@"TOTAL: $ %@.00", simpleTotal]];
}

-(void)reciboEnviado:(NSNotification *)theNotification {

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Se ha enviado correctamente su recibo al correo electrónico proporcionado" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [av show];
    
    [self limpiaDatos];
}

-(void)generaRecibo:(NSNotification *)theNotification {
    
    if (self.productosParaRecibo.count < 1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"No ha agregado ningún alimento" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [av show];
    } else {
        NSDictionary *response = [theNotification userInfo];
        NSMutableString *theUrl = [[NSMutableString alloc] initWithString:@"https://quantitydgtic.appspot.com/_ah/api/recibos/v1/enviarRecibo?"];
        NSMutableString *theParameters = [[NSMutableString alloc] init];
        
        for(int i = 0; i < self.productosParaRecibo.count; i++) {
            [theParameters appendString:[[self.productosParaRecibo objectAtIndex:i] objectForKey:@"descripcion"]];
            [theParameters appendString:@":"];
            [theParameters appendString:[[self.productosParaRecibo objectAtIndex:i] objectForKey:@"precio"]];
            
            if(i != self.productosParaRecibo.count - 1)
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
        
        NSLog(@"%@", theUrl);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:@"username"];
        
        [theUrl appendString:username];
        
        NSString *stringFormat = [theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ConnectionHelper *cn = [[ConnectionHelper alloc] init];
        cn.opcionNotificacion = 3; //catalogos
        [cn consumeWebService:stringFormat];
    }
}

-(void)seAgregaElemento:(NSNotification *)theNotification {
    NSDictionary *response = [theNotification userInfo];
    [self.productosParaRecibo addObject:response];
}

- (IBAction)botonTarjeta:(id)sender {

    if (simpleTotal == (id)[NSNull null] || simpleTotal.length == 0 || [simpleTotal isEqualToString:@"0"]) {

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"No ha agregado ningún alimento" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [av show];
        
    } else {
        [self pay];
    }
}

- (IBAction)pay {
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:simpleTotal];
    payment.currencyCode = @"MXN";
    payment.shortDescription = @"Cuenta Quantity";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    //payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    // Create a PayPalPaymentViewController.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                configuration:self.payPalConfiguration
                                                                delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    //    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self limpiaDatos];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
//    // Send the entire confirmation dictionary
//    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
//                                                options:0
//                                                error:nil];
//    
//    // Send confirmation to your server; your server should verify the proof of payment
//    // and give the user their goods or services. If the server is not reachable, save
//    // the confirmation and try again later.
//}

-(void)limpiaDatos {
    [[NSNotificationCenter defaultCenter] postNotificationName:LIMPIA_DATOS object:nil userInfo:nil];
}

@end
