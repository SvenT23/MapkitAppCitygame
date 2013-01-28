//
//  ViewController.h
//  MapkitAppCitygame
//
//  Created by Wim on 14/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


- (IBAction)clearMap:(id)sender;

- (IBAction)refresh:(id)sender;
@end
