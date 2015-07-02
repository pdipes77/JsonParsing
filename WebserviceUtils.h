#import <Foundation/Foundation.h>
@protocol WebserviceUtils;
@interface WebserviceUtils : NSObject
@property (nonatomic, strong) id <WebserviceUtils> webserviceDelegate;

-(void)startGetNetworkApi:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier;
-(void) startPostNetworkApi2:(NSString *)url parameter:(NSDictionary *)parameter_values identifier:(NSString *)identifier;
-(void) startPostNetworkApi:(NSString *)url parameter:(NSDictionary *)parameter_values identifier:(NSString *)identifier;
-(void)startGetNetworkApi2:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier;
//-(void)startGetNetworkApiXML:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier;

+ (void)loadCookies;
+ (void)saveCookies;
+ (void)deleteCookies;
@end

@protocol WebserviceUtils <NSObject>
-(void)getReceiveData:(NSDictionary *)response_dictionary identifier:(NSString *)identifier;
@optional
-(void)errorReceived:(NSError *)error identifier:( NSString *)identifier;
@end
