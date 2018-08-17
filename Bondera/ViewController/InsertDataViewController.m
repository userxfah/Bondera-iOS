//
//  InsertDataViewController.m
//  Bondera
//
//  Created by Arjun Dobaria on 20/06/18.
//  Copyright © 2018 Arjun Dobaria. All rights reserved.
//

#import "InsertDataViewController.h"
#import "ResultViewController.h"
#import "LocationSearchTableViewCell.h"


@import GoogleMobileAds;

@interface InsertDataViewController ()<UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, GADInterstitialDelegate, GMSAutocompleteViewControllerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFrom;
}
@property (strong, nonatomic) IBOutlet UIView *PickerMainView;
@property (weak, nonatomic) IBOutlet UIView *FromView;
@property (weak, nonatomic) IBOutlet UIView *ToView;
@property (weak, nonatomic) IBOutlet UIButton *GasButton;
@property (weak, nonatomic) IBOutlet UIButton *CurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *UnitButton;
@property (weak, nonatomic) IBOutlet UIButton *SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *FromText;
@property (weak, nonatomic) IBOutlet UITextField *ToText;
@property (weak, nonatomic) IBOutlet UITextField *TypeOfCar;
@property (weak, nonatomic) IBOutlet UITextField *NumberOfPeopleText;
@property (weak, nonatomic) IBOutlet UITextField *PricePerLiterText;
@property (weak, nonatomic) IBOutlet UITextField *ServiceFeesPerKMText;
@property (weak, nonatomic) IBOutlet UITextField *ConsuptionRatePerKMText;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeesKM;
@property (weak, nonatomic) IBOutlet UILabel *ConsuptionRateKM;
@property (weak, nonatomic) IBOutlet UILabel *priceperLiter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapConstraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *conButton;
@property (strong, nonatomic) NSArray *searchResults;
@property (nonatomic, assign) BOOL isCurrencyButton;
@property (nonatomic, assign) BOOL isFromText;
@property (nonatomic, assign) BOOL isUnitButton;
@property (nonatomic, assign) BOOL isGasButton;
@property (nonatomic, assign) BOOL isDateButton;
@property (nonatomic, assign) BOOL isConButton;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

NSArray *DropdownForGasType;
#define L 4
UIPickerView *GasPickerView;
UIDatePicker *datePicker;
NSMutableArray *dataArray;
NSMutableArray *currnecyArray;
NSMutableArray *unitArray;
NSMutableArray *consuptionArray;
NSMutableArray *consuptionArray1;
UIView *toolbar;
UIButton *done;
NSString *selectedCon;
NSString *selectedDate;
NSString *selectedGas;
NSString *selectedCurrency;
NSString *selectedUnit;
double lat1;
double lng1;
double lat2;
double lng2;
NSString *fromaddress;
NSString *toaddress;
NSString *Kilometer;
double answer;
double costPerPerson;
double consuptionRate;
double priceperliter;
double servicefees;
double newLocation;
double oldLocation;
int numberofpeople;
CLLocation *center1;
CLLocation *center2;
NSMutableArray *location;

CLGeocoder *geocoder;
CLPlacemark *placemark;

GADRequest *request;

@implementation InsertDataViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    geocoder = [[CLGeocoder alloc] init];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    
    self.interstitial = [self createAndLoadInterstitial];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"EEE dd/MM/yy hh:mm a"];
    
    [self.SelectDate setTitle:[NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    if(IS_IPHONE_X)
    {
        self.mapConstraintHeight.constant = 400;
        self.ConsuptionRateKM.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
    }
    else if(IS_IPHONE_6P)
    {
        self.mapConstraintHeight.constant = 350;
        self.ConsuptionRateKM.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
    }
    else if(IS_IPHONE_6)
    {
        self.mapConstraintHeight.constant = 300;
        self.ConsuptionRateKM.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
    }
    else if(IS_IPHONE_5)
    {
        self.mapConstraintHeight.constant = 250;
        self.ConsuptionRateKM.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
    }
    
    self.isGasButton = NO;
    self.isCurrencyButton = NO;
    self.isUnitButton = NO;
    self.isFromText = NO;
    
    self.serviceFeesKM.text = @"Service Fees (per KM)";
    self.ConsuptionRateKM.text = @"Consumption rate (L/100KM)";
    self.priceperLiter.text = @"Price per Liter";
    self.ConsuptionRatePerKMText.text = @"10";
    self.PricePerLiterText.text = @"6.75";
    
    dataArray = [[NSMutableArray alloc] init];
    currnecyArray = [[NSMutableArray alloc] init];
    unitArray = [[NSMutableArray alloc] init];
    consuptionArray1 = [[NSMutableArray alloc] init];
    consuptionArray = [[NSMutableArray alloc] init];
    
    selectedGas = @"Regular/92";
    selectedCurrency = @"EGP";
    selectedUnit = @"Liters";
    
    [dataArray addObject:@"Regular/92"];
    [dataArray addObject:@"Premium/95"];
    [dataArray addObject:@"Diesel"];
    
    [consuptionArray1 addObject:@"Economy - 2.6 G/100km"];
    [consuptionArray1 addObject:@"Luxury - 3.1 G/100km"];
    [consuptionArray1 addObject:@"Custom"];
    
    [consuptionArray addObject:@"Economy - 10 L/100km"];
    [consuptionArray addObject:@"Luxury - 12 L/100km"];
    [consuptionArray addObject:@"Custom"];
    
    [currnecyArray addObject:@"EGP"];
    [currnecyArray addObject:@"USD"];
    [currnecyArray addObject:@"EUR"];
    [currnecyArray addObject:@"INR"];
    [currnecyArray addObject:@"Dinar"];
    [currnecyArray addObject:@"Riyal"];
    [currnecyArray addObject:@"Dirham"];
    [currnecyArray addObject:@"Lira"];
    [currnecyArray addObject:@"Pound"];
    
    [unitArray addObject:@"Liters"];
    [unitArray addObject:@"Gallons"];
    
    [self setMaskTo:self.FromView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self setMaskTo:self.ToView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    self.PricePerLiterText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PricePerLIter"] != nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"PricePerLIter"] : @"6.75";
    [self.GasButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"TypeOfGas"] != nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"TypeOfGas"] : @"Regular/92" forState:UIControlStateNormal];
    self.ConsuptionRatePerKMText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ConsumptionRate"] != nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"ConsumptionRate"] : @"10";
    self.TypeOfCar.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TypeOfCar"] != nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"TypeOfCar"] : nil;
    [self.CurrencyButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"] != nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"] : @"EGP" forState:UIControlStateNormal];
    
    
    
    UIView *locview = [[UIView alloc] init];
    locview.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 40, self.mapConstraintHeight.constant - 40, 30, 30);
    locview.layer.cornerRadius = 15;
    locview.layer.masksToBounds = YES;
    [locview setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *gpsbtn = [[UIButton alloc] init];
    gpsbtn.frame = CGRectMake(0, 0, 30, 30);
    gpsbtn.layer.cornerRadius = 15;
    gpsbtn.layer.masksToBounds = YES;
    [gpsbtn setBackgroundColor:[UIColor clearColor]];
    [gpsbtn addTarget:self action:@selector(getmylocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *locButton = [[UIButton alloc] init];
    locButton.frame = CGRectMake(locview.bounds.size.width/2 - 7.5, locview.bounds.size.height/2 - 7.5, 15, 15);
    [locButton setBackgroundImage: [UIImage imageNamed:@"gps"] forState:UIControlStateNormal];
    
    [locview addSubview:locButton];
    [locview addSubview:gpsbtn];
    [self.mapView addSubview:locview];
}

#pragma mark - Location

-(void)getmylocation
{
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = locations.lastObject;
    GMSCameraPosition *fancy = [GMSCameraPosition cameraWithTarget:loc.coordinate zoom:11.0];
    [self.mapView setCamera:fancy];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            lat1 = placemark.location.coordinate.latitude;
            lng1 = placemark.location.coordinate.longitude;
            NSArray *add = [[NSArray alloc] init];
            NSString *address = @"";
            add = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
            for (int i = 0; i<add.count; i++) {
                NSLog(@"Location : %@",add[i]);
                address = [address stringByAppendingString:add[i]];
                address = [NSString stringWithFormat:@"%@ ",address];
                NSLog(@"address : %@",address);
            }
            self.FromText.text = address;
            
            fromaddress = address;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    [locationManager stopUpdatingLocation];
}

#pragma mark - button actions

- (IBAction)NextBtnClick:(id)sender {
    
    if([self.FromText.text isEqualToString:@""])
    {
        [self.view makeToast:@"Please enter route (From,To)"];
    }
    else if([self.ToText.text isEqualToString:@""])
    {
        [self.view makeToast:@"Please enter to text"];
    }
    else if([self.NumberOfPeopleText.text isEqualToString:@""] || [self.NumberOfPeopleText.text isEqualToString:@"0"])
    {
        [self.view makeToast:@"Please enter how many people you are?"];
    }
    else if([self.TypeOfCar.text isEqualToString:@""])
    {
        [self.view makeToast:@"Please enter type of car"];
    }
    else if([self.PricePerLiterText.text isEqualToString:@""] || [self.PricePerLiterText.text isEqualToString:@"0"])
    {
        [self.view makeToast:@"Please enter price per unit > 0"];
    }
    else if ([self.ConsuptionRatePerKMText.text isEqualToString:@""] || [self.ConsuptionRatePerKMText.text isEqualToString:@"0"])
    {
        [self.view makeToast:@"Please enter counsumption rate > 0"];
    }
    else if ([Kilometer isEqualToString:@"0"])
    {
        [self.view makeToast:@"No route found"];
    }
    else{
        request = [GADRequest request];
        [self.interstitial loadRequest:request];
        
        NSString *kmstr = Kilometer;
        
        kmstr = [kmstr stringByReplacingOccurrencesOfString:@","
                                                 withString:@""];
        CLLocationDistance km = [kmstr doubleValue];
        
        NSString *servicefeesstr = self.ServiceFeesPerKMText.text;
        
        servicefeesstr = [servicefeesstr stringByReplacingOccurrencesOfString:@","
                                                                   withString:@"."];
        NSString *consuptionRatesstr = self.ConsuptionRatePerKMText.text;
        
        consuptionRatesstr = [consuptionRatesstr stringByReplacingOccurrencesOfString:@","
                                                                           withString:@"."];
        NSString *priceperliterstr = self.PricePerLiterText.text;
        
        priceperliterstr = [priceperliterstr stringByReplacingOccurrencesOfString:@","
                                                                       withString:@"."];
        consuptionRate = [consuptionRatesstr doubleValue];
        priceperliter = [priceperliterstr doubleValue];
        servicefees = [servicefeesstr doubleValue];
        numberofpeople = [self.NumberOfPeopleText.text intValue];
        
        /*
         Total Cost = (Distance (from google maps) * consumption rate/100 * price per litre) + (service fee/km * distance)
         Cost per person = Total Cost / number of people
         */
        
        answer = (km * (consuptionRate/100) * priceperliter) + (servicefees*km);
        costPerPerson = answer / numberofpeople;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.PricePerLiterText.text forKey:@"PricePerLIter"];
        [[NSUserDefaults standardUserDefaults] setObject:self.GasButton.titleLabel.text forKey:@"TypeOfGas"];
        [[NSUserDefaults standardUserDefaults] setObject:self.ConsuptionRatePerKMText.text forKey:@"ConsumptionRate"];
        [[NSUserDefaults standardUserDefaults] setObject:self.TypeOfCar.text forKey:@"TypeOfCar"];
        [[NSUserDefaults standardUserDefaults] setObject:self.CurrencyButton.titleLabel.text forKey:@"Currency"];
        
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
        
        ResultViewController *result = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
        result.totalCost = [NSString stringWithFormat:@"%.01f",answer];
        result.perPersonCost = [NSString stringWithFormat:@"%.01f",costPerPerson];
        result.numberOfPeople = self.NumberOfPeopleText.text;
        result.carType = [NSString stringWithFormat:@"%@",self.TypeOfCar.text];
        result.pricePerLiter = self.PricePerLiterText.text;
        result.serviceFees = self.ServiceFeesPerKMText.text;
        
//        if([self.ConsuptionRatePerKMText.text isEqualToString:@"10"] || [self.ConsuptionRatePerKMText.text isEqualToString:@"2.6"])
//        {
//            result.consuptionRate = @"Economy";
//        }
//        else if([self.ConsuptionRatePerKMText.text isEqualToString:@"12"] || [self.ConsuptionRatePerKMText.text isEqualToString:@"3.1"])
//        {
//            result.consuptionRate = @"Luxury";
//        }
//        else
//        {
            result.consuptionRate = consuptionRate;
//        }
        result.typeOfGas = selectedGas;
        result.typeOfUnit = selectedUnit;
        result.typeOfCurrency = [NSString stringWithFormat:@"%@",self.CurrencyButton.titleLabel.text];
        result.fromAddress = fromaddress;
        result.toAddress = toaddress;
        result.when = self.SelectDate.titleLabel.text;
        result.distance = [NSString stringWithFormat:@"%.01f",km];
        [self.navigationController pushViewController:result animated:YES];
        
    }
}
- (IBAction)selectDate:(id)sender {
    self.isGasButton = NO;
    self.isCurrencyButton = NO;
    self.isUnitButton = NO;
    self.isDateButton = YES;
    self.isConButton = NO;
    [self setupPickerView];
}
- (IBAction)conButton:(id)sender {
    self.isGasButton = NO;
    self.isCurrencyButton = NO;
    self.isUnitButton = NO;
    self.isDateButton = NO;
    self.isConButton = YES;
    [self setupPickerView];
}

- (IBAction)GasButtonClick:(id)sender {
    self.isGasButton = YES;
    self.isConButton = NO;
    self.isCurrencyButton = NO;
    self.isUnitButton = NO;
    self.isDateButton = NO;
    [self setupPickerView];
}
- (IBAction)CurrencyButtonClick:(id)sender {
    self.isGasButton = NO;
    self.isConButton = NO;
    self.isCurrencyButton = YES;
    self.isUnitButton = NO;
    self.isDateButton = NO;
    [self setupPickerView];
}
- (IBAction)UnitButtonClick:(id)sender {
    self.isGasButton = NO;
    self.isConButton = NO;
    self.isCurrencyButton = NO;
    self.isUnitButton = YES;
    self.isDateButton = NO;
    [self setupPickerView];
}

- (IBAction)clickToSelectFromLocation:(id)sender {
    isFrom = true;
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (IBAction)clickToSelectToLocation:(id)sender {
    isFrom = false;
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

#pragma mark- Map

// Handle the user's selection.

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ((isFrom && (![_ToText.text isEqual: @""]) && [self.ToText.text isEqualToString:place.formattedAddress]) ||(!isFrom && (![_FromText.text  isEqual: @""]) && [self.FromText.text isEqualToString:place.formattedAddress]))
    {
        [self.view makeToast:@"Source and destination can not be same"];
    }
    else
    {
        // Do something with the selected place.
        
        if (isFrom) {
            _FromText.text = place.formattedAddress;
            fromaddress = _FromText.text;
            lat1 = (double)place.coordinate.latitude;
            lng1 = (double)place.coordinate.longitude;
        }
        else
        {
            _ToText.text = place.formattedAddress;
            toaddress = _ToText.text;
            lat2 = (double)place.coordinate.latitude;
            lng2 = (double)place.coordinate.longitude;
        }
        if (lat1 != 0.0 && lat2 != 0.0)
        {
            [self setMapPinView];
        }
    }
}



- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    //handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark- Picker

-(void)setupPickerView
{
    self.PickerMainView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - UIScreen.mainScreen.bounds.size.height/2.5, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height/2.5);
    toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.PickerMainView.bounds.size.width, self.PickerMainView.bounds.size.height/7)];
    toolbar.backgroundColor = [UIColor colorWithRed:25.0/255 green:185.0/255 blue:236.0/255 alpha:1.0];
    done = [[UIButton alloc] initWithFrame:CGRectMake(toolbar.bounds.size.width - 50, 5, 50, toolbar.bounds.size.height - 10)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setFont:[UIFont systemFontOfSize:17]];
    [done setUserInteractionEnabled:YES];
    [done addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [done setTintColor:[UIColor whiteColor]];
    
    [toolbar addSubview:done];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.date = [NSDate date];
    [datePicker setMinimumDate: [NSDate date]];
    datePicker.frame = CGRectMake(0, toolbar.bounds.size.height, self.PickerMainView.bounds.size.width, self.PickerMainView.bounds.size.height - toolbar.bounds.size.height);
    
    GasPickerView = [[UIPickerView alloc] init];
    GasPickerView.delegate = self;
    
    GasPickerView.dataSource = self;
    GasPickerView.showsSelectionIndicator = YES;
    GasPickerView.frame = CGRectMake(0, toolbar.bounds.size.height, self.PickerMainView.bounds.size.width, self.PickerMainView.bounds.size.height - toolbar.bounds.size.height);
    
    if(self.isDateButton)
    {
        datePicker.hidden = NO;
        GasPickerView.hidden = YES;
    }
    else{
        datePicker.hidden = YES;
        GasPickerView.hidden = NO;
    }
    
    [self.PickerMainView addSubview:toolbar];
    [self.PickerMainView addSubview:GasPickerView];
    [self.PickerMainView addSubview:datePicker];
    [self.view addSubview:self.PickerMainView];
}

-(void)removePickerView
{
    [done removeFromSuperview];
    [toolbar removeFromSuperview];
    [GasPickerView removeFromSuperview];
    [datePicker removeFromSuperview];
    [self.PickerMainView removeFromSuperview];
}

#pragma mark- Custom button actions

-(void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

-(void)setMapPinView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //update UI in main thread.
        [self.mapView clear];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat1,lng1);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = self.FromText.text;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = self.mapView;
        GMSCameraPosition *fancy = [GMSCameraPosition cameraWithLatitude:lat1
                                                               longitude:lng1
                                                                    zoom:8
                                                                 bearing:30
                                                            viewingAngle:45];
        [self.mapView setCamera:fancy];
        
        
        position = CLLocationCoordinate2DMake(lat2,lng2);
        marker = [GMSMarker markerWithPosition:position];
        marker.title = self.ToText.text;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = self.mapView;
        fancy = [GMSCameraPosition cameraWithLatitude:lat2
                                            longitude:lng2
                                                 zoom:8
                                              bearing:30
                                         viewingAngle:45];
        [self.mapView setCamera:fancy];
        if(![self.ToText.text isEqualToString:@""])
        {
            [self fetchPolylineWithDestination];
        }
        if(!self->isFrom){
            [self fetchPolylineWithDestination];
        }
        
        
    });
}
-(void)doneClick
{
    if(self.isConButton)
    {
        
        if([self.UnitButton.titleLabel.text isEqualToString:@"Liters"])
        {
            if(![selectedCon isEqualToString:self.ConsuptionRatePerKMText.text])
            {
                if([selectedCon isEqualToString:@"Custom"])
                {
                    [self.conButton setHidden:YES];
                    self.ConsuptionRatePerKMText.text = @"";
                    [self.ConsuptionRatePerKMText becomeFirstResponder];
                }
                else if([selectedCon isEqualToString:@"Economy - 10 L/100km"])
                {
                    self.ConsuptionRatePerKMText.text = @"10";
                }
                else if([selectedCon isEqualToString:@"Luxury - 12 L/100km"])
                {
                    self.ConsuptionRatePerKMText.text = @"12";
                }
                else
                {
                    self.ConsuptionRatePerKMText.text = @"10";
                }
            }
            else
            {
                self.ConsuptionRatePerKMText.text = @"10";
            }
            selectedCon = @"Economy - 10 L/100km";
        }
        else
        {
            if(![selectedCon isEqualToString:self.ConsuptionRatePerKMText.text])
            {
                if([selectedCon isEqualToString:@"Custom"])
                {
                    [self.conButton setHidden:YES];
                    self.ConsuptionRatePerKMText.text = @"";
                    [self.ConsuptionRatePerKMText becomeFirstResponder];
                }
                else if([selectedCon isEqualToString:@"Economy - 2.6 G/100km"])
                {
                    self.ConsuptionRatePerKMText.text = @"2.6";
                }
                else if([selectedCon isEqualToString:@"Luxury - 3.1 G/100km"])
                {
                    self.ConsuptionRatePerKMText.text = @"3.1";
                }
                else
                {
                    self.ConsuptionRatePerKMText.text = @"2.6";
                }
            }
            else
            {
                self.ConsuptionRatePerKMText.text = @"2.6";
            }
            selectedCon = @"Economy - 2.6 G/100km";
        }
        self.isConButton = NO;
        [self.conButton setHidden:NO];
        [self removePickerView];
    }
    if(self.isDateButton)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        [df setDateFormat:@"EEE dd/MM/yy hh:mm a"];
        
        [self.SelectDate setTitle:[NSString stringWithFormat:@"%@",
                                   [df stringFromDate:datePicker.date]] forState:UIControlStateNormal];
        [self removePickerView];
        self.isDateButton = NO;
    }
    if(self.isGasButton)
    {
        if(![selectedGas isEqualToString:self.GasButton.titleLabel.text])
        {
            if([selectedGas isEqualToString:@"Premium/95"])
            {
                if([self.CurrencyButton.titleLabel.text isEqualToString:@"EGP"])
                {
                    self.PricePerLiterText.text = @"7.75";
                }
            }
            else if([selectedGas isEqualToString:@"Regular/92"])
            {
                if([self.CurrencyButton.titleLabel.text isEqualToString:@"EGP"])
                {
                    self.PricePerLiterText.text = @"6.75";
                }
            }
            else
            {
                if([self.CurrencyButton.titleLabel.text isEqualToString:@"EGP"])
                {
                    self.PricePerLiterText.text = @"5.5";
                }
            }
            [self.GasButton setTitle:selectedGas forState:UIControlStateNormal];
            [self removePickerView];
        }
        else{
            [self.GasButton setTitle:@"Regular/92" forState:UIControlStateNormal];
            if([self.CurrencyButton.titleLabel.text isEqualToString:@"EGP"])
            {
                self.PricePerLiterText.text = @"6.75";
            }
            [self removePickerView];
        }
        selectedGas = @"Regular/92";
        self.isGasButton = NO;
    }
    if(self.isCurrencyButton)
    {
        
        
        if(![selectedCurrency isEqualToString:self.CurrencyButton.titleLabel.text])
        {
            [self.CurrencyButton setTitle:selectedCurrency forState:UIControlStateNormal];
            [self removePickerView];
        }
        else{
            [self.CurrencyButton setTitle:@"EGP" forState:UIControlStateNormal];
            [self removePickerView];
        }
        if([self.CurrencyButton.titleLabel.text isEqualToString:@"EGP"])
        {
            if([self.GasButton.titleLabel.text isEqualToString:@"Regular/92"])
            {
                self.PricePerLiterText.text = @"6.75";
            }
            else if([self.GasButton.titleLabel.text isEqualToString:@"Premium/95"])
            {
                self.PricePerLiterText.text = @"7.75";
            }
            else
            {
                self.PricePerLiterText.text = @"5.5";
            }
        }
        else
        {
            self.PricePerLiterText.text = @"";
        }
        selectedCurrency = @"EGP";
        self.isCurrencyButton = NO;
    }
    if(self.isUnitButton)
    {
        if(![selectedUnit isEqualToString:self.UnitButton.titleLabel.text])
        {
            if([selectedUnit isEqualToString:@"Gallons"])
            {
                selectedCon = @"Economy - 2.6 G/100km";
                self.ConsuptionRatePerKMText.text = @"2.6";
                self.ConsuptionRateKM.text = @"Consumption rate(gal/100KM)";
                self.priceperLiter.text = @"Price per Gallons";
                [self.UnitButton setTitle:@"Gallons" forState:UIControlStateNormal];
            }
            else{
                selectedCon = @"Economy - 10 L/100km";
                self.ConsuptionRatePerKMText.text = @"10";
                self.serviceFeesKM.text = @"Service Fees (per KM)";
                self.ConsuptionRateKM.text = @"Consumption rate (L/100KM)";
                self.priceperLiter.text = @"Price per Liter";
                [self.UnitButton setTitle:@"Liters" forState:UIControlStateNormal];
            }
            [self removePickerView];
        }
        else
        {
            selectedCon = @"Economy - 10 L/100km";
            self.serviceFeesKM.text = @"Service Fees (per KM)";
            self.ConsuptionRateKM.text = @"Consumption rate (L/100KM)";
            self.priceperLiter.text = @"Price per Liter";
            [self.UnitButton setTitle:@"Liters" forState:UIControlStateNormal];
            [self removePickerView];
        }
        self.isUnitButton = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Leckage");
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.PricePerLiterText && self.PricePerLiterText.text.length >= L)
    {
        return NO; // return NO to not change text
    }
    return YES;
}

#pragma mark - PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if(self.isGasButton)
    {
        NSLog(@"%@",[dataArray objectAtIndex:row]);
        selectedGas = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:row]];
    }
    if(self.isConButton)
    {
        if([self.UnitButton.titleLabel.text isEqualToString:@"Liters"])
        {
            NSLog(@"%@",[consuptionArray objectAtIndex:row]);
            selectedCon = [NSString stringWithFormat:@"%@",[consuptionArray objectAtIndex:row]];
        }
        else
        {
            NSLog(@"%@",[consuptionArray1 objectAtIndex:row]);
            selectedCon = [NSString stringWithFormat:@"%@",[consuptionArray1 objectAtIndex:row]];
        }
    }
    if(self.isCurrencyButton)
    {
        NSLog(@"%@",[currnecyArray objectAtIndex:row]);
        selectedCurrency = [NSString stringWithFormat:@"%@",[currnecyArray objectAtIndex:row]];
    }
    if(self.isUnitButton)
    {
        NSLog(@"%@",[unitArray objectAtIndex:row]);
        selectedUnit = [NSString stringWithFormat:@"%@",[unitArray objectAtIndex:row]];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.isGasButton)
    {
        return [dataArray count];
    }
    else if(self.isConButton)
    {
        if([self.UnitButton.titleLabel.text isEqualToString:@"Liters"])
        {
            return [consuptionArray count];
        }
        else
        {
            return [consuptionArray1 count];
        }
        
    }
    else if(self.isCurrencyButton)
    {
        return [currnecyArray count];
    }
    else
    {
        return [unitArray count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.isGasButton)
    {
        return [dataArray objectAtIndex: row];
    }
    else if(self.isConButton)
    {
        if([self.UnitButton.titleLabel.text isEqualToString:@"Liters"])
        {
            return [consuptionArray objectAtIndex: row];
        }
        else
        {
            return [consuptionArray1 objectAtIndex: row];
        }
    }
    else if(self.isCurrencyButton)
    {
        return [currnecyArray objectAtIndex: row];
    }
    else
    {
        return [unitArray objectAtIndex:row];
    }
}

#pragma mark- Route

- (void)fetchPolylineWithDestination
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", lat1,lng1];
    NSString *destinationEncodedString = [NSString stringWithFormat:@"%f,%f", lat2,lng2];
    NSString *directionsAPI = @"https://ditu.google.cn/maps/api/directions/json?";
//    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving&key=AIzaSyAtXizjmXibFeYN5y5NMW2bkSe19y0SSUI", directionsAPI, originString, destinationEncodedString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     
                                                     dispatch_sync(dispatch_get_main_queue(), ^{
                                                         if (error) {
                                                             NSLog(@"Drawing route failed");
                                                             NSLog(@"error: %@", error);
                                                             Kilometer = @"0";
                                                             return;
                                                         }
                                                         
                                                         NSArray *routesArray = [json objectForKey:@"routes"];
                                                         
                                                         if(routesArray.count == 0)
                                                         {
                                                             Kilometer = @"0";
                                                             [self.view makeToast:@"No route found"];
                                                             return;
                                                         }
                                                         else
                                                         {
                                                             Kilometer = [[[json valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0] objectAtIndex:0];
                                                             GMSPolyline *polyline = nil;
                                                             if ([routesArray count] > 0) {
                                                                 NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                                 NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                                 NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                                 GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                                 polyline = [GMSPolyline polylineWithPath:path];
                                                             }
                                                             
                                                             if(polyline){
                                                                 polyline.strokeColor = [UIColor redColor];
                                                                 polyline.strokeWidth = 4;
                                                                 polyline.map = self.mapView;
                                                                 
                                                                 CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(lat1 , lng1 );
                                                                 CLLocationCoordinate2D calgary = CLLocationCoordinate2DMake(lat2 , lng2);
                                                                 GMSCoordinateBounds *bounds =
                                                                 [[GMSCoordinateBounds alloc] initWithCoordinate:vancouver coordinate:calgary];
                                                                 GMSCameraPosition *camera = [self.mapView cameraForBounds:bounds insets:UIEdgeInsetsZero];
                                                                 self.mapView.camera = camera;
                                                                 
                                                                 
                                                                 UIEdgeInsets mapInsets = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0);
                                                                 self.mapView.padding = mapInsets;
                                                                 CGFloat currentZoom = self.mapView.camera.zoom;
                                                                 [self.mapView animateToZoom:currentZoom-0.15];
                                                                 
                                                                 
                                                                 [self.mapView animateToBearing:0];
                                                             }
                                                             
                                                             NSLog(@"Drawing route completed");
                                                         }
                                                         
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
}

#pragma mark- AdMob

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:Interstitial_KEY];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Error %@", error);
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

@end
