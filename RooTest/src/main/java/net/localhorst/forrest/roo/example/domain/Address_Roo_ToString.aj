package net.localhorst.forrest.roo.example.domain;

import java.lang.String;

privileged aspect Address_Roo_ToString {
    
    public String Address.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("City: ").append(getCity()).append(", ");
        sb.append("Postalcode: ").append(getPostalcode());
        return sb.toString();
    }
    
}
