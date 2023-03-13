public class PropertyMappingUtility {
    
    public static String getSpliteroPropertyType(String propertyType){
        String spliteroPropertyType = null;
        
        propertyType = propertyType != null ? propertyType.toLowerCase() : propertyType;
        switch on propertyType {
            When 'transient lodging','time share condo','time share','resort hotel','residence hall/dormitories','multi family 10 units plus','multi family 10 units less','motel','mobile home park','mobile home','mixed complex','manufactured home','hotel','health club','group quarters','frat/sorority house','condotel','condominium project','common area','apartment/hotel','apartment' {         	
                spliteroPropertyType = 'Inelidgable';
            }
            When 'Townhouse/Rowhouse','pud','mid rise condo','high rise condo','cooperative','condominium'{
                spliteroPropertyType = 'HOA';
            }
            When 'triplex','quadruplex','multi family dwelling','duplex'{
                spliteroPropertyType = 'Other';
            }
            When 'sfr','residential (nec)','cabin'{
                spliteroPropertyType = 'SFR';
            }
            when else {		 
                spliteroPropertyType = null;
            }
        }
        
        return spliteroPropertyType;
        
    }

}