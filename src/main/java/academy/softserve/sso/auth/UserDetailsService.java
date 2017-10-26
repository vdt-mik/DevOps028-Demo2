package academy.softserve.sso.auth;

import org.springframework.security.authentication.BadCredentialsException;


/**
 * Specification for getting {@link UserCredentialsInfo} from different places
 */
public interface UserDetailsService {

    /**
     * gets {@link UserCredentialsInfo} from database by {@code userName}
     *
     * @return {@link UserCredentialsInfo} object containing user info
     * @throws {@link BadCredentialsException} in case of wrong {@code userName}
     */
    UserCredentialsInfo loadUserByUsername(String userName) throws BadCredentialsException;

}
