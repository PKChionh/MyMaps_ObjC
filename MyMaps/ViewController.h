//
//  ViewController.h
//  MyMaps
//
//  Created by ITSAdmin on 7/11/17.
//  Copyright © 2017 ITE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)btnFindMe:(id)sender;

@end
