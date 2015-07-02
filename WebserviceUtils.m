#import "WebserviceUtils.h"
#import "AFNetworking.h"
#import "AFNetworking.h"
//#import "XMLDictionary.h"
//#import "NoNetworkViewController.h"
#import "ValidationMethods.h"

#define WEB_USERNAME @"admin"
#define WEB_PASSWORD @"admin"
@implementation WebserviceUtils

-(void)startGetNetworkApi:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier
{
//	NSURLRequest *request = [NSURLRequest requestWithURL:
//							 [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	//NSURLCredential *credential = [NSURLCredential credentialWithUser:WEB_USERNAME
														//	 password:WEB_PASSWORD
														 // persistence:NSURLCredentialPersistenceNone];
	//operation.credential= credential;
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *response_data = (NSDictionary *)responseObject;
		 NSLog(@"The response Data of Identifier %@ is \n %@",identifier,response_data);
		 [self getReceiveData:response_data identifier:identifier];
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
	 NSLog(@"The failure Details of Identifier %@ is \n %@",identifier,error);
	NSInteger statusCode = operation.response.statusCode;
	if(![identifier isEqualToString:@"SMEPROFILE"])
	{
		 if(statusCode >300 && statusCode<400)
			 {
				[ValidationMethods showAlertView:@"Url has been changed, Kindly contact aministrator"];
			 }
		 if(statusCode >400 && statusCode<500)
			 {
			//	[ValidationMethods showAlertView:@"Server is not responding"];
			 }
		 else
			 {
				[ValidationMethods showAlertView:@"Could not connect to the server, Check your internet connection"];
			 }
	}
		[self errorReceived:error identifier:identifier];
		NSLog(@"Failed: error: %@", error);
	 }];
	[operation start];
}

//the following api is for calling the api which fetches XML response

/*-(void)startGetNetworkApiXML:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier
{
	NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
	responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/rss+xml", nil];
	operation.responseSerializer = responseSerializer;
	NSURLCredential *credential = [NSURLCredential credentialWithUser:WEB_USERNAME
															 password:WEB_PASSWORD
														  persistence:NSURLCredentialPersistenceNone];
	operation.credential= credential;
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		NSData *response_data = (NSData *)responseObject;
		NSLog(@"The response Data of Identifier %@ is \n %@",identifier,response_data);
		NSDictionary *final_data = [NSDictionary dictionaryWithXMLData:response_data];
		[self getReceiveData:final_data identifier:identifier];
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
	 NSLog(@"The failure Data of Identifier %@ is \n %@",identifier,error);
	 NSInteger statusCode = operation.response.statusCode;
	 if(statusCode >300 && statusCode<400)
	 {
		[ValidationMethods showAlertView:@"Url has been changed, Kindly contact aministrator"];
	 }
	 if(statusCode >400 && statusCode<500)
	 {
		// [ValidationMethods showAlertView:@"Server is not responding"];
	 }
	 else
	 {
		[ValidationMethods showAlertView: @"Could not connect to the server, Check your internet connection"];
	 }
	 
	 NSLog(@"Failed error: %@", error);
	 [self errorReceived:error identifier:identifier];
	 }];
	[operation start];
}*/

-(void) startPostNetworkApi:(NSString *)url parameter:(NSDictionary *)parameter_values identifier:(NSString *)identifier
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	[manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
	//[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:@""];
//	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager POST:url parameters:parameter_values success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		NSDictionary *response_data = (NSDictionary *)responseObject;
		 NSLog(@"The failure Data of Identifier %@ is \n %@",identifier,response_data);
		[self postReceiveData:response_data identifier:identifier];
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		NSLog(@"The failure Data of Identifier %@ is \n %@",identifier,error);
		[self errorReceived:error identifier:identifier];
	 }];
}

-(void)postReceiveData:(NSDictionary *)response_dictionary identifier:(NSString *)identifier
{
	if(_webserviceDelegate != nil)
	{
		[_webserviceDelegate getReceiveData:(NSDictionary *)response_dictionary identifier:identifier];
	}
}

-(void)getReceiveData:(NSDictionary *)response_dictionary identifier:(NSString *)identifier
{
	if(_webserviceDelegate != nil)
	{
		[_webserviceDelegate getReceiveData:(NSDictionary *)response_dictionary identifier:identifier];
	}
}

-(void)errorReceived:(NSError *)error identifier:(NSString *)identifier
{
	if(_webserviceDelegate != nil)
	{
		@try
		{
			[_webserviceDelegate errorReceived:(NSError *)error identifier:identifier];
		}
		@catch (NSException *exception)
		{
			NSLog(@"Caught the execption in failure of Identifier %@ ",identifier);
		}
	}
}


+ (void)saveCookies
{
	
	NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: cookiesData forKey: @"sessionCookies"];
	[defaults synchronize];
	NSLog(@"Cockies are saved ");
}

+ (void)loadCookies
{
	NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in cookies)
	{
		[cookieStorage setCookie: cookie];
	}
}

+ (void)deleteCookies
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [defaults objectForKey: @"sessionCookies"]];
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in cookies)
	{
		[cookieStorage deleteCookie: cookie];
	}
	[defaults setObject: nil forKey: @"sessionCookies"];
	[defaults synchronize];
	NSLog(@"Cockies are deleted ");
}
-(void) startPostNetworkApi2:(NSString *)url parameter:(NSDictionary *)parameter_values identifier:(NSString *)identifier
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//		[manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
//	[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:@""];
//	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager POST:url parameters:parameter_values success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		NSDictionary *response_data = (NSDictionary *)responseObject;
	 NSLog(@"The failure Data of Identifier %@ is \n %@",identifier,response_data);
		[self postReceiveData:response_data identifier:identifier];
	 }
		  failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		NSLog(@"The failure Data of Identifier %@ is \n %@",identifier,error);
		[self errorReceived:error identifier:identifier];
	 }];
}

-(void)startGetNetworkApi2:(NSString *)url parameter:(NSString *)parameter_values identifier:(NSString *)identifier
{
		NSURLRequest *request = [NSURLRequest requestWithURL:
								 [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	//NSURLCredential *credential = [NSURLCredential credentialWithUser:WEB_USERNAME
	//	 password:WEB_PASSWORD
	// persistence:NSURLCredentialPersistenceNone];
	//operation.credential= credential;
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
	 NSDictionary *response_data = (NSDictionary *)responseObject;
	 NSLog(@"The response Data of Identifier %@ is \n %@",identifier,response_data);
	 [self getReceiveData:response_data identifier:identifier];
	 }
									 failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
	 NSLog(@"The failure Details of Identifier %@ is \n %@",identifier,error);
	 NSInteger statusCode = operation.response.statusCode;
	 if(![identifier isEqualToString:@"SMEPROFILE"])
		 {
		 if(statusCode >300 && statusCode<400)
			 {
				[ValidationMethods showAlertView:@"Url has been changed, Kindly contact aministrator"];
			 }
		 if(statusCode >400 && statusCode<500)
			 {
			 //	[ValidationMethods showAlertView:@"Server is not responding"];
			 }
		 else
			 {
				[ValidationMethods showAlertView:@"Could not connect to the server, Check your internet connection"];
			 }
		 }
		[self errorReceived:error identifier:identifier];
		NSLog(@"Failed: error: %@", error);
	 }];
	[operation start];
}
