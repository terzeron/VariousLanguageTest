package net.localhorst.forrest.roo.example.domain;

import org.springframework.beans.factory.annotation.Configurable;

privileged aspect Person_Roo_Configurable {
    
    declare @type: Person: @Configurable;
    
}
