package net.localhorst.forrest.roo.example.domain;

import java.lang.String;

privileged aspect Address_Roo_JavaBean {
    
    public String Address.getCity() {
        return this.city;
    }
    
    public void Address.setCity(String city) {
        this.city = city;
    }
    
    public String Address.getPostalcode() {
        return this.postalcode;
    }
    
    public void Address.setPostalcode(String postalcode) {
        this.postalcode = postalcode;
    }
    
}
