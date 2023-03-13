public class DomaJSON2Apex {
	
    public cls_documents[] documents;
    public class cls_documents {
        public String id;	 
        public String created_date;	 
        public String created_by;	 
        public String href;	 
        public String type;	 
    }
    public static DomaJSON2Apex parse(String json){
        return (DomaJSON2Apex) System.JSON.deserialize(json, DomaJSON2Apex.class);
    }
}