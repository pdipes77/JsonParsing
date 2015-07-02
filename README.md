# JsonParsing

//write these lines of code in wherever you want the web service

WebserviceUtils *webUtilityObject = [[WebserviceUtils alloc]init];
webUtilityObject.webserviceDelegate = self;
NSString *url =[NSString stringWithFormat:@"http://myurl.com/getData];
[webUtilityObject startGetNetworkApi:url parameter:@"" identifier:@"getDiary"];


//get the data here



-(void)getReceiveData:(NSDictionary *)response_dictionary identifier:(NSString *)identifier
{
  NSlog(@"the response dictionary is %@",response_dictionary);
   NSArray *arr = [response_dictionary objectForKey:@"data"];
 
}

//make sure that you have donwloaded and put the AFNetworking framework.
