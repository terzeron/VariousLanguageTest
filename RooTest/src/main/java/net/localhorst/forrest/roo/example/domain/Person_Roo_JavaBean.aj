package net.localhorst.forrest.roo.example.domain;

import java.lang.Integer;
import java.lang.String;
import net.localhorst.forrest.roo.example.domain.Address;

privileged aspect Person_Roo_JavaBean {
    
    public Integer Person.getId() {
        return this.id;
    }
    
    public void Person.setId(Integer id) {
        this.id = id;
    }
    
    public String Person.getFirstname() {
        return this.firstname;
    }
    
    public void Person.setFirstname(String firstname) {
        this.firstname = firstname;
    }
    
    public String Person.getLastname() {
        return this.lastname;
    }
    
    public void Person.setLastname(String lastname) {
        this.lastname = lastname;
    }
    
    public Address Person.getAddress() {
        return this.address;
    }
    
    public void Person.setAddress(Address address) {
        this.address = address;
    }
    
}
