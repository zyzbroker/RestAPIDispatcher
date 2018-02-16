# Salesforce Rest API Dispatcher

Recently I ran into A task that need to develop a SPA application and hosted outside the
salesforce system but be able to retrieve some information from the salesforce system. In other words,
we will use the salesforce as the back office and develop a new SPA application as the
front office.

Here is the diagram of the project mentioned above.
![SPA diagram](/images/spa.png)

There are a few ways to integrate with the salesforce system as listed below:

    * use jsforce javascript library to handle the salesforce access.
    * use salesforce rest API and develop our own oauth2 client library.

The jsforce use its own proxy (not from salesforce) to handle access token preflight,
it is kind of smell, I don't like. Based on the salesforce REST API document,
writing codes to handle the OAUTH2 is not difficult and the rest of them is just very simple.
We are using google Dart Web framework so that we decide to write out our own
API packages.

We need to write custom rest apex API to handle some complex query scenario.
When we write apex rest API, we run into the issue of breaking 'DRY'.
For each rest API we keep writing try catch and logging logic. It is unbearable.

Thus we need to centralize the try, catch, logging logic in one place from where
we can dispach the resource request to its own resource handler.

Here is the DispatchHandler

```java

@RestResource(urlMapping='/dispatcher/*')
global without sharing class DispatchHandler {
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
    ...
}
```

The rest API URL is like

https://instance.salesforce.com/services/apexrest/{packageNamespace}/dispatcher/{your dispatcher name Without suffix 'Dispatcher'}/{actionName}

We use the HTTP post method only to pass on payload to the backend. In this way,
we also make the convention about the rest API URL so that,
the URL '/dispatch/Customer/get' will be translated to the following codes:

```java
    IDispatcher dispatcher = new CustomerDispatcher();
    dispatcher.execute('actionName', reqeustBody);
```

Note that the CustomerDispatcher implements IDispatcher interface.

```javas
public interface IDispatcher {
    RestResult execute(String action, Blob body);
}
```
