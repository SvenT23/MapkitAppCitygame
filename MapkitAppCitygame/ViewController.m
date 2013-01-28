//
//  ViewController.m
//  MapkitAppCitygame
//
//  Created by Wim on 14/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //defines the background queue
#define webserviceURL [NSURL URLWithString:@"http://webservice.citygamephl.be/CityGameWS/resources/generic/getLocations/1/2/Jager"] //Defines the URL for the hunters
#define webserviceURLprey [NSURL URLWithString:@"http://webservice.citygamephl.be/CityGameWS/resources/generic/getLocations/1/2/Prooi"] //Defines the URL for the prey

#import "ViewController.h"
//annotation klassen importeren
#import "JagerAnnotation.h"
#import "ProoiAnnotation.h"

#import "WebserviceConnection.h" //WS klasse importeren

@interface ViewController ()
@property CLLocationCoordinate2D userLocation;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end


@implementation ViewController


@synthesize userLocation = _userLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    
    NSTimer *interval = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                       selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)clear{
    //deletes the previous annotations on the map
    [self.mapView removeAnnotations:self.mapView.annotations];
}

-(void)tick{
    // calls the function to empty the map
    [self clear];
    
    // makes the background queue and calls the fetched data function for the hunters
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        webserviceURL];
        [self performSelectorOnMainThread:@selector(hunterData:) withObject:data waitUntilDone:YES];
    });
    
    // sets up the prey connection
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        webserviceURLprey];
        [self performSelectorOnMainThread:@selector(preyData:) withObject:data waitUntilDone:YES];
    });
}

- (void)hunterData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    for (NSDictionary *user in json) {
        // Gets the values of the prey (there should only be one, so the for loop shouldn't be necessary
        NSString* name = [user objectForKey:@"player"];
        NSNumber* longitude = [user objectForKey:@"longitude"];
        NSNumber* latitude = [user objectForKey:@"latitude"];
        
        // logs the data
        NSLog(@"%@ is at longitude: %@ and latitude: %@", name, longitude, latitude);
        
        // adds the location to the map
        JagerAnnotation *jager = [[JagerAnnotation alloc] init];
        jager.titel = @"Groep1";
        jager.subTitel= name;
        CLLocationCoordinate2D test;
        test.latitude = [latitude doubleValue];
        test.longitude = [longitude doubleValue];
        jager.coordinaat = test;
        
        [self.mapView addAnnotation:jager];
    }
}

- (void)preyData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    for (NSDictionary *user in json) {
        // Gets the values of the different hunters
        NSString* name = [user objectForKey:@"player"];
        NSNumber* longitude = [user objectForKey:@"longitude"];
        NSNumber* latitude = [user objectForKey:@"latitude"];
        
        // logs the data
        NSLog(@"%@ is at longitude: %@ and latitude: %@", name, longitude, latitude);
        
        // adds the location to the map
        CLLocationCoordinate2D test;
        
        ProoiAnnotation *prooi = [[ProoiAnnotation alloc] init];
        prooi.titel = @"Konijntje";
        prooi.subTitel= name;
        test.latitude = [latitude doubleValue];
        test.longitude = [longitude doubleValue];
        prooi.coordinaat = test;
        [self.mapView addAnnotation:prooi];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLocation
{
    //Dwingt de kaart zich te beperken tot een regio van 800 op 800 rond de locatie van de gebruiker
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance
    (_userLocation, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region]
                   animated:YES];
}

//User locatie wordt geupdate
-	(void)mapView:(MKMapView *)mapView didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _userLocation = userLocation.coordinate;
    
    //Punt toevoegen aan de kaart
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(50.9377, 5.3458);
    //titel en subtitel geven aan het punt
    point.title = @"Opdracht2";
    point.subtitle = @"Dans!";
    
    [self.mapView addAnnotation:point];
}

//methode wwordt opgeroepen bij plaatsen van pin op kaart
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
        MKAnnotationView *pinView = nil;
        //controleren of de annotatie == locatie gebruiker
        if(annotation != _mapView.userLocation)
        {
            if ([annotation isKindOfClass:[JagerAnnotation class]]) // Indien om het om een jager gaat
            {
                static NSString *defaultPinID = @"com.invasivecode.pin";
                pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
                if ( pinView == nil )
                    pinView = [[MKAnnotationView alloc]
                               initWithAnnotation:annotation reuseIdentifier:defaultPinID];
                
                //pinView.pinColor = MKPinAnnotationColorGreen;
                pinView.canShowCallout = YES;
                //pinView.animatesDrop = YES;
                //de pin een custom image toewijzen
                pinView.image = [UIImage imageNamed:@"Elmer-Fudd-Hunting-icon.png"];
            }else if ([annotation isKindOfClass:[ProoiAnnotation class]]){ //Als het om de prooi gaat
                static NSString *defaultPinID = @"com.invasivecode.pin";
                pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
                if ( pinView == nil )
                    pinView = [[MKAnnotationView alloc]
                               initWithAnnotation:annotation reuseIdentifier:defaultPinID];
                
                //pinView.pinColor = MKPinAnnotationColorGreen;
                pinView.canShowCallout = YES;
                //pinView.animatesDrop = YES;
                pinView.image = [UIImage imageNamed:@"Prooi.png"];            }
        }
        else {
            [_mapView.userLocation setTitle:@"Ik ben hier"];
        }
        return pinView;
}

- (IBAction)clearMap:(id)sender {
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist

}

- (IBAction)refresh:(id)sender {
    [self showLocation];
}

@end
