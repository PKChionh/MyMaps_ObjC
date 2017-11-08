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
@end
