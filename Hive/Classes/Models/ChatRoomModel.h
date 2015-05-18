//
//  ChatRoomModel.h
//  
//
//  Created by mac on 15/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatRoomModel : NSManagedObject

@property (nonatomic, retain) NSString * hasAname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSString * msg_distance;
@property (nonatomic, retain) NSString * msg_flag;
@property (nonatomic, retain) NSString * msg_hasStealth;
@property (nonatomic, retain) NSString * msg_hasTime;
@property (nonatomic, retain) NSString * msg_isSend;
@property (nonatomic, retain) NSString * msg_latitude;
@property (nonatomic, retain) NSString * msg_longitude;
@property (nonatomic, retain) NSString * msg_message;
@property (nonatomic, retain) NSString * msg_time;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * msg_Interval_time;

@end
