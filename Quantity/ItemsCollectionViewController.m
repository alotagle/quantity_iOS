//
//  ItemsCollectionViewController.m
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ItemsCollectionViewController.h"
#import "MainController.h"
#import "ConnectionHelper.h"
#import "ItemCollectionViewCell.h"



@interface ItemsCollectionViewController ()

@end

@implementation ItemsCollectionViewController

static NSString * const reuseIdentifier = @"ItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    [self requestCatalogService];
    // Se subscribe a las notificaciones de repsuesta cuando este listo
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reponseCatalogService:) name:CATALOGO_DESCARGADO object:nil];
}

//se ejecuta una vez que se ha recibido la notificacion para la descarga de catalogo
- (void) reponseCatalogService: (NSNotification *)laNotificacion {
    NSDictionary *response = [laNotificacion userInfo];
    self.productosDictionaries = [[NSMutableDictionary alloc] init];
    
    self.productosarray = [response objectForKey:@"productos"];
    
    for(int i = 0; i < self.productosarray.count; i++){
        [self.productosDictionaries setObject:[self.productosarray objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.collectionView reloadData];
    
}

-(void)requestCatalogService{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    
    NSString *theUrl = [NSString stringWithFormat:@"https://quantitydgtic.appspot.com/_ah/api/productos/v1/listaProductos?usuario=%@",username];
    ConnectionHelper *cn = [[ConnectionHelper alloc] init];
    cn.opcionNotificacion = 2; //catalogos
    [cn consumeWebService:theUrl];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.productosDictionaries.count; //numero de items
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    
    NSDictionary *itemDictionary =[self.productosarray objectAtIndex:indexPath.row];
    NSString *itemDescription =[itemDictionary objectForKey:@"descripcion"];
    NSString *itemPrice = [itemDictionary objectForKey:@"precio"];
    NSString *itemImage = [itemDictionary objectForKey:@"imagen"];

    
    // Configure the cell
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    cell.itemDescription.text = itemDescription;
    cell.itemPrice.text = [NSString stringWithFormat:@"$ %@.00",itemPrice];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",itemImage]];
    
    [cell.itemImage setImage:image];
    
    
//    static NSString *identifier = @"Cell";    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //se envia una notificacion de que seleccinoalgo del collection view y se envia
    [[NSNotificationCenter defaultCenter] postNotificationName:PROCUTO_SELECCIONADO object:nil userInfo:[self.productosarray objectAtIndex:indexPath.row]];
    NSLog(@"selecteditem ");
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
