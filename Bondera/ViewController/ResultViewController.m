//
//  ResultViewController.m
//  Bondera
//
//  Created by Arjun Dobaria on 20/06/18.
//  Copyright © 2018 Arjun Dobaria. All rights reserved.
//

#import "ResultViewController.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *PersonCost;
@property (weak, nonatomic) IBOutlet UILabel *CostTotalText;
@property (weak, nonatomic) IBOutlet UILabel *AddressFrom;
@property (weak, nonatomic) IBOutlet UILabel *AddressTo;
@property (weak, nonatomic) IBOutlet UILabel *TotalDistance;
@property (weak, nonatomic) IBOutlet UILabel *TotalNumberOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *TotalConsuptionRate;
@property (weak, nonatomic) IBOutlet UILabel *CarTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *GasType;
@property (weak, nonatomic) IBOutlet UILabel *PricePerLiterLbl;
@property (weak, nonatomic) IBOutlet UILabel *incServiceFeelbl;
@property (weak, nonatomic) IBOutlet UIButton *CopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *ScreenShotBtn;
@property (weak, nonatomic) IBOutlet UILabel *CoptBtnLbl;
@property (weak, nonatomic) IBOutlet UILabel *ScreenShotBtnLbl;
@property (weak, nonatomic) IBOutlet UIImageView *seprationImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *whentxt;
@property (weak, nonatomic) IBOutlet UIView *CalculateView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PersonCost.text = [self.perPersonCost stringByAppendingString:[NSString stringWithFormat:@" %@",self.typeOfCurrency]];
    self.CostTotalText.text = [self.totalCost stringByAppendingString:[NSString stringWithFormat:@" %@",self.typeOfCurrency]];
    self.AddressFrom.text = self.fromAddress;
    self.AddressTo.text = self.toAddress;
    self.TotalDistance.text = [self.distance stringByAppendingString:@" KM"];
    self.TotalNumberOfPeople.text = [NSString stringWithFormat:@"%@ Person(s)",self.numberOfPeople];
    self.CarTypeLbl.text = self.carType;
    self.GasType.text = self.typeOfGas;
    self.whentxt.text = self.when;
    self.incServiceFeelbl.text = [NSString stringWithFormat:@"*incl. service fee %@ %@/km",self.serviceFees,self.typeOfCurrency];
    self.incServiceFeelbl.adjustsFontSizeToFitWidth=YES;
    self.incServiceFeelbl.minimumScaleFactor=0.5;
    
    if([self.serviceFees isEqualToString:@"0"] || self.serviceFees == nil || [self.serviceFees length] == nil)
    {
        [self.incServiceFeelbl setHidden:YES];
    }
    if([self.typeOfUnit isEqualToString:@"Gallons"])
    {
        self.TotalConsuptionRate.text = [NSString stringWithFormat:@"%0.1f Gallons",self.consuptionRate * [self.distance doubleValue] / 100]; //distance * consumption rate / 100
        
//        if([self.consuptionRate isEqualToString:@"Economy"] || [self.consuptionRate isEqualToString:@"Luxury"])
//        {
//            self.TotalConsuptionRate.text = self.consuptionRate;
//        }
//        else
//        {
//            self.TotalConsuptionRate.text = [NSString stringWithFormat:@"%@ %@/100KM",self.consuptionRate,@"G"];
//        }
        self.PricePerLiterLbl.text = [NSString stringWithFormat:@"%@ %@/%@",self.pricePerLiter,self.typeOfCurrency,@"G"];
    }
    else{
        self.TotalConsuptionRate.text = [NSString stringWithFormat:@"%0.1f Liters",self.consuptionRate * [self.distance doubleValue] / 100];
//        if([self.consuptionRate isEqualToString:@"Economy"] || [self.consuptionRate isEqualToString:@"Luxury"])
//        {
//            self.TotalConsuptionRate.text = self.consuptionRate;
//        }
//        else
//        {
//            self.TotalConsuptionRate.text = [NSString stringWithFormat:@"%@ %@/100KM",self.consuptionRate,@"L"];
//        }
//
        self.PricePerLiterLbl.text = [NSString stringWithFormat:@"%@ %@/%@",self.pricePerLiter,self.typeOfCurrency,@"L"];
    }
}

#pragma mark-button actions

- (IBAction)BackBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)CopyButtonClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    /*
     Bondera Fare
     From: Address
     To: Address
     Total Distance: 200 KM
     Number of people: 2
     Type of gas: Regular/92
     Total per person: 100 EGP (incl. service fee of 0.5/km)
     Total: 200 EGP
     */
    
    NSString *data;
    if([self.serviceFees isEqualToString:@"0"] || self.serviceFees == nil || [self.serviceFees length] == nil)
    {
        data = [NSString stringWithFormat:@"Bondera Fare\nFrom:%@\nTo:%@\nWhen:%@\nTotal Distance:%@\nNumber of people:%@\nType of gas:%@\nTotal per person:%@\nTotal:%@",self.AddressFrom.text,self.AddressTo.text,self.when,self.TotalDistance.text,self.TotalNumberOfPeople.text,self.GasType.text,self.PersonCost.text,self.CostTotalText.text];
    }
    else{
        data = [NSString stringWithFormat:@"Bondera Fare\nFrom:%@\nTo:%@\nWhen:%@\nTotal Distance:%@\nNumber of people:%@\nType of gas:%@\nTotal per person:%@ (incl. service fee of %@ %@/km)\nTotal:%@",self.AddressFrom.text,self.AddressTo.text,self.when,self.TotalDistance.text,self.TotalNumberOfPeople.text,self.GasType.text,self.PersonCost.text,self.serviceFees,self.typeOfCurrency,self.CostTotalText.text];
    }
    [pasteboard setString:data];
    [self.view makeToast:@"Trip details copied :)"];
}
- (IBAction)ScreenShotButtonClick:(id)sender
{
    [self.CoptBtnLbl setHidden:YES];
    [self.CopyBtn setHidden:YES];
    [self.ScreenShotBtn setHidden:YES];
    [self.ScreenShotBtnLbl setHidden:YES];
    [self.seprationImg setHidden:YES];
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0f);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *ScreenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.CoptBtnLbl setHidden:NO];
    [self.CopyBtn setHidden:NO];
    [self.ScreenShotBtn setHidden:NO];
    [self.ScreenShotBtnLbl setHidden:NO];
    [self.seprationImg setHidden:NO];
    
    NSData *imageData = UIImagePNGRepresentation(ScreenShotImage);
    UIImage *image1 = [UIImage imageWithData:imageData];
    NSArray *activityItems = @[image1];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Leckage");
}

@end
