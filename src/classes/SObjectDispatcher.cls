public without sharing class SObjectDispatcher implements IDispatcher {
    public RestResult execute(String action, blob body){
        action = action.toLowerCase();
        if(action == 'getdefinition'){

        }

        if (action == 'filter'){

        }
        
        return RestResult.error('The action:' + action + ' is invalid.');
    }

    Map<String,Object> parseBody(blob body) {
        return null;
    }

    RestResult getDefinition(String sobjectName){
        return null;
    }

    RestResult filter(Map<String,Object> query){
        return null;
    }
}