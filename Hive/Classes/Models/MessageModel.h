//
//  MessageModel.h
//  
//
//  Created by mac on 15/5/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageModel : NSManagedObject

@property (nonatomic, retain) NSString * msg_content;
@property (nonatomic, retain) NSString * msg_ID;
@property (nonatomic, retain) NSString * msg_time;
@property (nonatomic, retain) NSString * toUserID;
@property (nonatomic, retain) NSString * toUserName;
@property (nonatomic, retain) NSString * unReadCount;

@end
