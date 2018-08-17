//
//  ResultViewController.h
//  Bondera
//
//  Created by Arjun Dobaria on 20/06/18.
//  Copyright © 2018 Arjun Dobaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (nonatomic, assign) NSString *totalCost;
@property (nonatomic, assign) NSString *perPersonCost;
@property (nonatomic, assign) NSString *numberOfPeople;
@property (nonatomic, assign) NSString *carType;
@property (nonatomic, assign) double consuptionRate;
@property (nonatomic, assign) NSString *serviceFees;
@property (nonatomic, assign) NSString *pricePerLiter;
@property (nonatomic, assign) NSString *typeOfGas;
@property (nonatomic, assign) NSString *typeOfCurrency;
@property (nonatomic, assign) NSString *typeOfUnit;
@property (nonatomic, assign) NSString *fromAddress;
@property (nonatomic, assign) NSString *toAddress;
@property (nonatomic, assign) NSString *distance;
@property (nonatomic, assign) NSString *when;
@end
