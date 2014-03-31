package net.localhorst.forrest.roo.example.domain;

import java.lang.String;

privileged aspect Person_Roo_ToString {
    
    public String Person.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("_id: ").append(get_id()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Firstname: ").append(getFirstname()).append(", ");
        sb.append("Lastname: ").append(getLastname()).append(", ");
        sb.append("Address: ").append(getAddress());
        return sb.toString();
    }
    
}
