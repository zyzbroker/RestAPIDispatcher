/*
  *  author: david zhao
  *  email :davidyzhao@yahoo.com
  *  date: 02/15/2018
  *  descrption: this is the central dispatcher to handle all rest requests
  *  and route to the dispatcher implementation to handle the action payload
  *  the valid URL is:
  * https://instance.salesforce.com/services/apexrest/{packageNamespace}
  * /dispatcher/{your dispatcher name Without suffix 'Dispatcher'}/{actionName}
  * for example: https://instance.salesforce.com/services/apexrest/packageNameSpace/dispatcher/SObject/getDefinition
  * the central dispatcher will create SobjectDispatcher instance and call execute method.
*/
@RestResource(urlMapping='/dispatcher/*')
global without sharing class DispatchHandler {
    static String AppNameSpace {get;set;}
    static {
        AppNameSpace = AppSetting.CURRENTNAMESPACE;
    }

    @HttpPost
    global static RestResult dispatch(){
        try{
            RestRequest req = RestContext.request;
            String[] actions = parseUrl(req.requestURI);
            String className = getClassName(actions[0]);
            IDispatcher dispatcher = getDispatcher(className);
            return dispatcher.execute(actions[1], req.requestBody);
        } 
        catch(DmlException dml){
            return  RestResult.error(genDMLMessage(dml));
        } 
        catch(Exception ex){
            return RestResult.error(ex.getStackTraceString());
        }
    }

    static String getClassName(String name){
        return (name.indexOf('Dispatcher') != -1) ? name: name + 'Dispatcher';
    }

    static IDispatcher getDispatcher(string className){
        Type classType = Type.forName(AppNameSpace, className);
        return (IDispatcher) classType.newInstance();
    }

    static String[] parseUrl (String url) {
        List<String> result = new List<String>();
        String[] parts = url.split('/');
        result.add(parts[parts.size() -2]);
        result.add(parts[parts.size() -1]);
        return result;
    }

    static string genDMLMessage(DmlException dml){
        List<String> msgs = new List<String>();
        for(Integer i=0; i < dml.getNumDml(); i++){
            msgs.add(dml.getDmlMessage(i));
        }
        return String.join(msgs, '. ');
    }
}