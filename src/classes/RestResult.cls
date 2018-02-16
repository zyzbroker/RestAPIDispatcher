global class RestResult {
    public boolean status {get;set;}
    public String value {get;set;}
    public List<String> values {get;set;}
    public List<Map<String,String>> records {get;set;} 

    private RestResult(){}

    private RestResult(boolean status, String value){
        this.status = status;
        this.value = value;
    }   

    private RestResult(List<String>values){
        this.status = true;
        this.values = values;
    }

    private RestResult(List<Map<String,String>> records){
        this.status = true;
        this.records = records;
    }

    public static RestResult error(String message){
        return new RestResult(false, message);
    }

    public static RestResult succeed(string value){
        return new RestResult(true, value);
    }

    public static RestResult succeedWithMany(List<String> values){
        return new RestResult(values);
    }

    public static RestResult succeedWithRecords(List<Map<String,String>> records){
        return new RestResult(records);
    }
}