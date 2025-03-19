package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class GoogleAccount {

    private String id, email, name, firstName, givenName, familyName, picture;

    private boolean verified_email;

    public GoogleAccount() {
    }

    public GoogleAccount(String id, String email, String name, String firstName, String givenName, String familyName, String picture, boolean verified_email) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.firstName = firstName;
        this.givenName = givenName;
        this.familyName = familyName;
        this.picture = picture;
        this.verified_email = verified_email;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public boolean isVerified_email() {
        return verified_email;
    }

    public void setVerified_email(boolean verified_email) {
        this.verified_email = verified_email;
    }

    @Override
    public String toString() {
        return "GoogleAccount{" + "id=" + id + ", email=" + email + ", name=" + name + ", firstName=" + firstName + ", givenName=" + givenName + ", familyName=" + familyName + ", picture=" + picture + ", verified_email=" + verified_email + '}';
    }
    
    
}
