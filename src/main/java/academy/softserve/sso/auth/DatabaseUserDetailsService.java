package academy.softserve.sso.auth;//package academy.softserve.aura.core.security;


import academy.softserve.sso.entity.User;
import academy.softserve.sso.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * implementation of {@link UserDetailsService}
 */
@Service
public class DatabaseUserDetailsService implements UserDetailsService {

    private Logger logger = LoggerFactory.getLogger(DatabaseUserDetailsService.class);

    /**
     * {@link org.springframework.data.repository.Repository} from which
     * {@link User} entities will be loaded
     */
    private final UserRepository userRepository;

    @Autowired
    public DatabaseUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    @Override
    public UserCredentialsInfo loadUserByUsername(String login) {
        User fromDao = getUser(login);

        if (fromDao == null) {
            throw new UsernameNotFoundException("Wrong login or pass");
        }

        logger.info("from dao user pass " + fromDao.getPassword());

        return new UserCredentialsInfo(login, fromDao.getPassword(), fromDao.getUserRole());
    }

    private User getUser(String login) {
        try {
            return userRepository.findByLogin(login);
        } catch (UsernameNotFoundException e) {
            throw new BadCredentialsException("Bad credentials, check your input, please", e);
        }
    }

}
