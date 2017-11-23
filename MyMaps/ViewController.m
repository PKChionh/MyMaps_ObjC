//
//  ViewController.m
//  MyMaps
//
//  Created by ITSAdmin on 7/11/17.
//  Copyright © 2017 ITE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Map
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [locationManager requestWhenInUseAuthorization];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(1.364324, 103.991563);
    myAnnotation.title = @"Changi Airport";
    myAnnotation.subtitle = @"Terminal 1";
    [self.mapView addAnnotation:myAnnotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"RedPin_32x.png"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plane_32x.png"]];
            pinView.leftCalloutAccessoryView = iconView;
            
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Changi Airport");
    }
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Changi Airport"
                                 message:@"This is where you fly overseas!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];

    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFindMe:(id)sender
{
    // Retrieve current user location
    MKUserLocation *userLocation = self.mapView.userLocation;
    
    // Define region to zoom in
    // The 2 numbers represent the width/height of region (in meters)
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500, 500);
    
    // Set region to MapView
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)btnGoChangi:(id)sender
{
    // Retrieve current user location
    MKUserLocation *userLocation = self.mapView.userLocation;
    
    // Define region to zoom in
    // The 2 numbers represent the width/height of region (in meters)
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 30000, 30000);
    
    // Set region to MapView
    [self.mapView setRegion:region animated:YES];
    
    // Set coordinates for destination Changi
    double latitude = 1.364324;
    double longitude = 103.991563;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"Changi Airport"];
    
    // Store Changi mapItem info into 'destination' variable
    self.destination = mapItem;
    
    // Start search to destination
    [self getDirections];
}

- (IBAction)btnClearOverlay:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)getDirections
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = self.destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline
                           level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor yellowColor];
    renderer.lineWidth = 4.0;
    return renderer;
}


@end
