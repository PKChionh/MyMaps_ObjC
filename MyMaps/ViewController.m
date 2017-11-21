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
