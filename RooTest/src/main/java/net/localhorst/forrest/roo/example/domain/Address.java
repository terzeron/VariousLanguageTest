package net.localhorst.forrest.roo.example.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Address {

    private String city;

    private String postalcode;
}
