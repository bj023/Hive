//
//  ChatModel.h
//  
//
//  Created by 那宝军 on 15/5/6.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatModel : NSManagedObject

@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * flag;
@property (nonatomic, retain) NSString * hasRead;
@property (nonatomic, retain) NSString * hasStealth;
@property (nonatomic, retain) NSString * hasTime;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * isSend;

@end
