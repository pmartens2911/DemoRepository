//
//  BathViewController.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "BathViewController.h"
#import "JSONManager.h"

NSNumber *bathCapacity;
NSNumber *hotFlow;
NSNumber *hotTemp;
NSNumber *coldFlow;
NSNumber *coldTemp;
NSNumber *currentHot;
NSNumber *currentCold;
NSNumber *currentTotal;

@interface BathViewController ()
@end

@implementation BathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bathCapacity = [NSNumber numberWithInt:150];
    hotFlow = [NSNumber numberWithFloat:(10.0f/120.0f)]; //.083~ Litres per half second
    //hotTemp = [NSNumber numberWithInt:50];
    coldFlow = [NSNumber numberWithFloat:(12.0f/120.0f)]; //.1 Litres per half second
    //coldTemp = [NSNumber numberWithInt:10];
    NSArray *tempArray = [JSONManager readTemperatures];
    hotTemp = [tempArray objectAtIndex:0];
    coldTemp = [tempArray objectAtIndex:1];
    self.toggleCold = [NSNumber numberWithBool:NO];
    self.toggleHot = [NSNumber numberWithBool:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateBath) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (CGFloat)degreesToRadians:(CGFloat)degrees
{
    return (degrees * M_PI / 180);
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBath
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Update water amount
        NSNumber *currentHotT = currentHot;
        NSNumber *currentColdT = currentCold;
        if([self.toggleHot boolValue] && ([currentTotal floatValue] < [bathCapacity floatValue])) {
            currentHotT = [NSNumber numberWithFloat:[currentHot floatValue] + [hotFlow floatValue]];
        }
        if([self.toggleCold boolValue] && ([currentTotal floatValue] < [bathCapacity floatValue])) {
            currentColdT = [NSNumber numberWithFloat:[currentCold floatValue] + [coldFlow floatValue]];
        }
        
        //Calculate current total water
        NSNumber *currentTotalT = [NSNumber numberWithFloat:[currentHotT floatValue] + [currentColdT floatValue]];
        //Update the labels
        NSNumber *currentTotalInt = [NSNumber numberWithInt:[currentTotalT intValue]];
        NSString *waterLevel = [currentTotalInt stringValue];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [waterLevel length]; i++) {
            NSString *ch = [waterLevel substringWithRange:NSMakeRange(i, 1)];
            [array addObject:ch];
        }
        //Main thread update labels
        dispatch_async(dispatch_get_main_queue(), ^{
            switch ([array count]) {
                case 1:
                    self.lblCapacity1.text = [array objectAtIndex:0];
                    break;
                case 2:
                    self.lblCapacity10.text = [array objectAtIndex:0];
                    self.lblCapacity1.text = [array objectAtIndex:1];
                    break;
                case 3:
                    self.lblCapacity100.text = [array objectAtIndex:0];
                    self.lblCapacity10.text = [array objectAtIndex:1];
                    self.lblCapacity1.text = [array objectAtIndex:2];
                    break;
                case 0:
                    self.lblCapacity1.text = @"0";
                    self.lblCapacity10.text = @"0";
                    self.lblCapacity100.text = @"0";
                    break;
                default:
                    break;
            }
        });
        
        //Update water levels
        // 360 to 264 (96)
        // 2 to 100 (98)
        NSNumber *percentCapacity = [NSNumber numberWithFloat:[currentTotalT floatValue] / [bathCapacity floatValue]];
        NSNumber *waterY = [NSNumber numberWithFloat:(360 - (96 * [percentCapacity floatValue]))];
        NSNumber *waterHeight = [NSNumber numberWithFloat:(2 + (98 * [percentCapacity floatValue]))];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgWater.frame = CGRectMake(self.imgWater.frame.origin.x, [waterY floatValue], self.imgWater.frame.size.width, [waterHeight floatValue]);
        });
        //Calculate current temperature
        NSNumber *vtc = [NSNumber numberWithFloat:[currentColdT floatValue] * [coldTemp floatValue]];
        NSNumber *vth = [NSNumber numberWithFloat:[currentHotT floatValue] * [hotTemp floatValue]];
        NSNumber *totalTemp = [NSNumber numberWithFloat:([vtc floatValue] + [vth floatValue]) / [currentTotalT floatValue]];
        
        //Transform the bar meter
        //Calculate the degrees
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([totalTemp floatValue] < 30) {
                //-90 @ 10
                //10 - 30 range
                NSNumber *dialPercent;
                NSNumber *degrees;
                dialPercent = [NSNumber numberWithFloat:1.0f - (([totalTemp floatValue] - 10.0f)/20.0f)];
                degrees = [NSNumber numberWithFloat:[dialPercent floatValue] * -90.0f];
                //Rotate Dial
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:.5];
                self.imgHeatMeter.transform = CGAffineTransformMakeRotation([self degreesToRadians:[degrees floatValue]]);
                [UIView commitAnimations];
            } else if([totalTemp floatValue] > 30) {
                //90 @ 10
                //30 - 50 range
                NSNumber *dialPercent;
                NSNumber *degrees;
                dialPercent = [NSNumber numberWithFloat:([totalTemp floatValue] - 30.0f)/20.0f];
                degrees = [NSNumber numberWithFloat:[dialPercent floatValue] * 90.0f];
                //Rotate Dial
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:.5];
                self.imgHeatMeter.transform = CGAffineTransformMakeRotation([self degreesToRadians:[degrees floatValue]]);
                [UIView commitAnimations];
            } else {
                self.imgHeatMeter.transform = CGAffineTransformMakeRotation([self degreesToRadians:0]);
            }
            currentHot = [NSNumber numberWithFloat:[currentHotT floatValue]];
            currentCold = [NSNumber numberWithFloat:[currentColdT floatValue]];
            currentTotal = [NSNumber numberWithFloat:[currentColdT floatValue] + [currentHotT floatValue]];
        });
    });
  /*((Va * Ta) + (Vb * Tb)) / (Va+Vb) = Tf
    Va = volume in tank A whose temperature is Ta
    Vb = volume in tank B whose temperature is Tb
    Tf = the temperature of the water after mixing.*/
}

- (IBAction)btnToggleCold:(id)sender {
    if([self.toggleCold boolValue]) {
        self.toggleCold = [NSNumber numberWithBool:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        self.btnCold.transform = CGAffineTransformMakeRotation([self degreesToRadians:0]);
        [UIView commitAnimations];
        
    } else {
        self.toggleCold = [NSNumber numberWithBool:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        self.btnCold.transform = CGAffineTransformMakeRotation([self degreesToRadians:45]);
        [UIView commitAnimations];
    }
}

- (IBAction)btnToggleHot:(id)sender {
    if([self.toggleHot boolValue]) {
        self.toggleHot = [NSNumber numberWithBool:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        self.btnHot.transform = CGAffineTransformMakeRotation([self degreesToRadians:0]);
        [UIView commitAnimations];
    } else {
        self.toggleHot = [NSNumber numberWithBool:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        self.btnHot.transform = CGAffineTransformMakeRotation([self degreesToRadians:45]);
        [UIView commitAnimations];
    }
}
@end
