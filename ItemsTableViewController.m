//
//  ItemsTableViewController.m
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ItemsTableViewController.h"

@interface ItemsTableViewController ()

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // se inicializa el arreglo que contendra los articulos seleccionados
    self.productosarray = [[NSMutableArray alloc] init];
    
    // se suscribe para obtener la notificacion de seleccion de producto
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productoSeleccionado:) name:PROCUTO_SELECCIONADO object:nil];
    
    // se suscribe para limpiar los datos
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limpiaDatos) name:LIMPIA_DATOS object:nil];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}


-(void)productoSeleccionado:(NSNotification *)theNotification {
    NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithDictionary: [theNotification userInfo]];
    BOOL repetido = NO;
    
    for (NSObject *elemento in self.productosarray) {

        if ([[response valueForKey:@"id"]isEqualToString:[elemento valueForKey:@"id"]]) {

            repetido = YES;
            int uno = 1.0;
            int actual = [[elemento valueForKey:@"cantidad"] integerValue] + uno;
            [elemento setValue:[NSString stringWithFormat: @"%d", actual] forKey:@"cantidad"];
        }
    }
    
    if (!repetido) {
        [response setValue:@1 forKey:@"cantidad"];
        [self.productosarray addObject:response];
    }
    
    [self.tableView reloadData];
    
    [self actualizaTotal];
}


-(double)calculaTotal{
    double  total = 0.0;
    
    for(int i = 0; i < self.productosarray.count; i++){
        NSMutableDictionary *tempItem = [self.productosarray objectAtIndex:i];
        total += ([[tempItem objectForKey:@"precio"] doubleValue] * [[tempItem objectForKey:@"cantidad"] doubleValue]);
    }
    
    return total;
}


-(void)actualizaTotal {
    NSNumber *total = [[NSNumber alloc] initWithDouble:[self calculaTotal]];
    NSMutableDictionary *totalDictionary = [[NSMutableDictionary alloc] init];
    [totalDictionary setValue:total forKey:@"total"];
    
    // Se envía una notificación de que se han agregado los elementos a la vista y calculado la suma total
    [[NSNotificationCenter defaultCenter] postNotificationName:PRODUCTOS_AGREGADOS object:nil userInfo:totalDictionary];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.productosarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"tableElement"];
    UILabel *precio;
    UILabel *titulo;
    UILabel *cantidad;
    
    // Se obtiene el elemento del arreglo
    NSDictionary *elObjetoSeleccionado = [self.productosarray objectAtIndex:indexPath.row];
    
    precio = (UILabel *)[cell viewWithTag:1];
    [precio setText:[NSString stringWithFormat:@"$%@.00",[elObjetoSeleccionado objectForKey:@"precio"]]];
    
    titulo = (UILabel *)[cell viewWithTag:2];
    [titulo setText:[NSString stringWithFormat:@"%@",[elObjetoSeleccionado objectForKey:@"descripcion"]]];
    
    cantidad = (UILabel *)[cell viewWithTag:3];
    [cantidad setText:[NSString stringWithFormat:@"%@",[elObjetoSeleccionado objectForKey:@"cantidad"]]];
    
    // Se actualizan los campos de la celda
    //    cell.textLabel.text = [NSString stringWithFormat:@"$%@ %@",[elObjetoSeleccionado objectForKey:@"precio"],[elObjetoSeleccionado objectForKey:@"descripcion"]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.productosarray removeObjectAtIndex:indexPath.row];
        [self actualizaTotal];
        [self.tableView reloadData];
    }
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)limpiaDatos {
    self.productosarray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self actualizaTotal];
}

@end
