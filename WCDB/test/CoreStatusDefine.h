#ifndef CoreStatusDefine_h
#define CoreStatusDefine_h

/**
 *NSUInteger unsigned int
 */
#define CoreNSUInteger  @"I,Q"

/**
 *NSInteger int Enum
 */
#define CoreNSInteger  @"i,q"

/**
 *CGFloat float
 */
#define CoreCGFloat  @"f,d"

/**
 *double
 */
#define Coredouble  @"d"


/**
 *long
 */
#define Corelong  @"l"


/**
 *short
 */
#define Coreshort  @"s"


/**
 *unsigned short
 */
#define CoreUNShort  @"S"


/**
 *char
 */
#define Corechar  @"c"

/**
 *unsigned char
 */
#define CoreUNchar  @"C"


/**
 *  NSDate
 */
#define CoreNSDate  @"NSDate"


/**
 *  字符串
 */
#define CoreNSString  @"NSString"



/**
 *  NSData
 */
#define CoreNSData  @"NSData"



/**
 *  NSArray
 */
#define CoreNSArray   @"NSArray"


/**
 *  NSArray
 */
#define CoreNSMutableArray  @"NSMutableArray"


/**
 *  NSDictionary
 */
#define CoreNSDictionary   @"NSDictionary"


/**
 *  NSDictionary
 */
#define CoreNSMutableDictionary   @"NSMutableDictionary"

/**
 *  SQL语句Const
 */

/**
 *  INTEGER
 */
#define INTEGER_TYPE   @"INTEGER NOT NULL DEFAULT 0"


/**
 *  TEXT
 */
#define TEXT_TYPE  @"TEXT NOT NULL DEFAULT ''"


/**
 *  REAL
 */
#define  REAL_TYPE  @"REAL NOT NULL DEFAULT 0.0"



/**
 *  DATETIME
 */
#define  DATETIME_TYPE  @"datetime default NULL"




/**
 *  BLOB
 */
#define BLOB_TYPE   @"BLOB,B,c"





/**
 *  空字符串
 */
#define  EmptyString   @""


#define  TableClassName   @"TableClassName"

#define   typeNumber  @"number"
#define   typeStr  @"str"
#define   typeStrDate  @"str_date"
#define   typeNumberFloat  @"number_float"
#define   typeNsDataGetStr  @"dataGetStr"

#define TriggerBlock(block,res) if(block != nil ) block(res);
#endif