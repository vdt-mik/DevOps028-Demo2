package academy.softserve.sso.auth;


import academy.softserve.sso.entity.UserRole;

/**
 * POJO containing info, which should be included to JWT token using {@link JwtUtil#generateToken(String, String, UserCredentialsInfo)}
 */
public class UserCredentialsInfo {

    /**
     * user name will be included to Principal (login)
     */
    private String userName;

    /**
     * user pass will be included to Principal
     */
    private String password;

    /**
     * user Role will be included to {@link org.springframework.security.core.GrantedAuthority} list
     */
    private UserRole role;


    public UserCredentialsInfo() {
    }

    UserCredentialsInfo(String userName, String password, UserRole role) {
        this.userName = userName;
        this.password = password;
        this.role = role;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "UserCredentialsInfo{" +
                "userName='" + userName + '\'' +
                ", password='" + password + '\'' +
                ", role=" + role +
                '}';
    }
}
