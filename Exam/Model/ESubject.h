//
//  ESubject.h
//  Exam
//
//  Created by gyq on 2017/2/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 subject
 */
@interface ESubject : NSObject

@property (nonatomic,assign) NSInteger subject_id;
@property (nonatomic,assign) NSInteger subject_p_id;
@property (nonatomic,copy) NSString *subject_title;

@end
