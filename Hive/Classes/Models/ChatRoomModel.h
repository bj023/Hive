//
//  ChatRoomModel.h
//  
//
//  Created by 那宝军 on 15/4/26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatRoomModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSString * flag;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * isAname;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * isStealth;

@end
