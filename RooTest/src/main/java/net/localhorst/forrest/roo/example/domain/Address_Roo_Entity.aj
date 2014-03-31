package net.localhorst.forrest.roo.example.domain;

import java.lang.Integer;
import java.lang.Long;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Version;
import net.localhorst.forrest.roo.example.domain.Address;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Address_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager Address.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Address.id;
    
    @Version
    @Column(name = "version")
    private Integer Address.version;
    
    public Long Address.getId() {
        return this.id;
    }
    
    public void Address.setId(Long id) {
        this.id = id;
    }
    
    public Integer Address.getVersion() {
        return this.version;
    }
    
    public void Address.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void Address.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Address.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Address attached = this.entityManager.find(Address.class, this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Address.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Address.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Address merged = this.entityManager.merge(this);
        this.entityManager.flush();
        this.id = merged.getId();
    }
    
    public static final EntityManager Address.entityManager() {
        EntityManager em = new Address().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Address.countAddresses() {
        return (Long) entityManager().createQuery("select count(o) from Address o").getSingleResult();
    }
    
    public static List<Address> Address.findAllAddresses() {
        return entityManager().createQuery("select o from Address o").getResultList();
    }
    
    public static Address Address.findAddress(Long id) {
        if (id == null) return null;
        return entityManager().find(Address.class, id);
    }
    
    public static List<Address> Address.findAddressEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from Address o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
