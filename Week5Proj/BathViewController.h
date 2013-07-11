//
//  BathViewController.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BathViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgWater;
- (IBAction)btnToggleCold:(id)sender;
- (IBAction)btnToggleHot:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCold;
@property (weak, nonatomic) IBOutlet UIButton *btnHot;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeatMeter;
@property (weak, nonatomic) IBOutlet UILabel *lblCapacity100;
@property (weak, nonatomic) IBOutlet UILabel *lblCapacity10;
@property (weak, nonatomic) IBOutlet UILabel *lblCapacity1;
@property (strong, nonatomic) NSNumber *currentTemp;
@property (strong, nonatomic) NSNumber *toggleHot;
@property (strong, nonatomic) NSNumber *toggleCold;


@end
