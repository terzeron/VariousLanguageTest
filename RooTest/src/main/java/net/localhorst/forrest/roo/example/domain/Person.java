package net.localhorst.forrest.roo.example.domain;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Person {

    private Integer id;

    private String firstname;

    private String lastname;

    @ManyToOne(targetEntity = Address.class)
    @JoinColumn
    private Address address;
}
