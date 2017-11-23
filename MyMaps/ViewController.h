//
//  ViewController.h
//  MyMaps
//
//  Created by ITSAdmin on 7/11/17.
//  Copyright © 2017 ITE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) MKMapItem *destination;

- (IBAction)btnFindMe:(id)sender;

- (IBAction)btnGoChangi:(id)sender;
- (IBAction)btnClearOverlay:(id)sender;
@end















