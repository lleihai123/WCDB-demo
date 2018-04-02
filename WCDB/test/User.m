#import "User.h"
@interface User()


@end

@implementation User
////WCDB_IMPLEMENTATION(User)
////
/////// 绑定到表中的字段（已经是从需要绑定到表中的字段中取它的子集）
////WCDB_SYNTHESIZE(User, content)
////WCDB_SYNTHESIZE(User, name)
////WCDB_SYNTHESIZE(User, localID)
////
////// 约束宏定义数据库的主键
////WCDB_PRIMARY(User, localID)
//static WCTBinding * yg_wctBinding = nil;
//static WCTPropertyList * yg_wctPropertyList = nil;
//#define YGWCTPropertyTypeMainKey(propertyType,propertyName)\
//WCTProperty([propertyName UTF8String],[self class],yg_wctBinding\
//                   ->addColumnBinding<propertyType>([propertyName UTF8String],[propertyName UTF8String]))
//
//+(void)initialize{
//    yg_wctPropertyList = new WCTPropertyList();
//    yg_wctBinding = new WCTBinding(self.class);
//    unsigned int outCount = 0;
//    objc_property_t *properties = class_copyPropertyList(self, &outCount);
//    // 2.遍历每一个成员变量
//    for (unsigned int i = 0; i<outCount; i++) {
//        objc_property_t property = properties[i];
//        // 1.属性名
//        NSString *name = @(property_getName(property));
//        NSString *attrs = @(property_getAttributes(property));
//        WCTProperty s_property = [self getWCTProperty:name attr:attrs];
//        yg_wctPropertyList->push_back(s_property);
//        if([name isEqualToString:@"userid"]){
//            yg_wctBinding->getColumnBinding(s_property)->makePrimary(WCTOrderedAscending, YES, WCTConflictNotSet);
//        }else if ([name isEqualToString:@"name"]){
//            yg_wctBinding->getColumnBinding(s_property)->makeUnique();
//        }
//    }
//}
//-(BOOL)isAutoIncrement{
//    return YES;
//}
//
//+(WCTProperty)getWCTProperty:(NSString*)propertyName attr:(NSString*)attr{
//    NSLog(@"attrs:%@",attr);
//    if ([attr hasPrefix:@"T@"]){
//        return WCTProperty([propertyName UTF8String],[self class],yg_wctBinding
//                           ->addColumnBinding<decltype([[self new] valueForKey:propertyName])>([propertyName UTF8String],[propertyName UTF8String]));
//    }
//    NSUInteger dotLoc = [attr rangeOfString:@","].location;
//    NSString *code = nil;
//    NSUInteger loc = 1;
//    if (dotLoc == NSNotFound) { // 没有,
//        code = [attr substringFromIndex:loc];
//    } else {
//        code = [attr substringWithRange:NSMakeRange(loc, dotLoc - loc)];
//    }
//    if ([CoreNSUInteger rangeOfString:code].location != NSNotFound) {
//        return YGWCTPropertyTypeMainKey(NSUInteger,propertyName);
//    } else if ([CoreNSInteger rangeOfString:code].location != NSNotFound) {
//        return YGWCTPropertyTypeMainKey(NSInteger,propertyName);
//    }
//    return WCTProperty([propertyName UTF8String],[self class],yg_wctBinding
//                           ->addColumnBinding<decltype([[self new] valueForKey:propertyName])>([propertyName UTF8String],[propertyName UTF8String]));
//}
//+(const WCTBinding *) objectRelationalMappingForWCDB
//{
//    if (self.class != User.class) {
//        WCDB::Error::Abort("Inheritance is not supported for ORM");
//    }
//    return yg_wctBinding;
//}
//
//+(const WCTPropertyList &) AllProperties{
//    return *yg_wctPropertyList;//__WCDB_PROPERTIES(User);
//}
//+(const WCTAnyProperty &) AnyProperty{
//    static const WCTAnyProperty s_anyProperty(User.class);
//    return s_anyProperty;
//}
@end
//
//#pragma mark ============================================================
//
//@interface UserManager()
//
//@end
//
//@implementation UserManager
//
//
//+ (UserManager *)defaultManager
//{
//    static  UserManager *manager    = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager     = [[UserManager alloc] init];
//    });
//
//    return manager;
//}
//
//- (void)insertData:(User *)msg
//{
//    BOOL    res     = [[DBManager defaultManager].dataBase insertOrReplaceObject:msg into:UserTable];
//    if (res) {
//        NSLog(@"插进去了");
//    }
//    else{
//        NSLog(@"没插进去");
//    }
//}
//
//- (void)queryData
//{
//    NSArray *msgArr =  [[DBManager defaultManager].dataBase getAllObjectsOfClass:User.class fromTable:UserTable];
//    for (int i = 0; i < msgArr.count; i++) {
//        NSLog(@"userid == %ld",(long)((User *)msgArr[i]).userid);
//        NSLog(@"localID == %ld",(long)((User *)msgArr[i]).localID);
//        NSLog(@"name == %@",((User *)msgArr[i]).name);
//        NSLog(@"content == %@",((User *)msgArr[i]).content);
//        NSLog(@"tmpname == %@",((User *)msgArr[i]).tmpname);
//    }
//}
//
//- (void)deleteDataFromTable:(NSString *)tableName
//{
//    BOOL    res     = [[DBManager defaultManager].dataBase deleteAllObjectsFromTable:UserTable];
//    if (res) {
//        NSLog(@"删完了");
//    }
//    else{
//        NSLog(@"删除失败");
//    }
//}
//@end

