package academy.softserve.sso.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;

@Controller
public class LoginController {

    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @Value("${domain}")
    private String domain;

    @Value("${jwtTokenCookieName}")
    private String jwtTokenCookieName;

    @Value("${signingKey}")
    private String signingKey;

    private final UserDetailsService userDetailsService;

    /**
     * used for hashing passwords
     * need to use it when saving new {@link academy.softserve.sso.entity.User}
     */
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public LoginController(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
        passwordEncoder = passwordEncoder();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }


    @RequestMapping("/")
    public String home() {
        return "redirect:/login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        return "login";
    }

    @RequestMapping(value = "login", method = RequestMethod.POST, consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public
    @ResponseBody
    String login(
            HttpServletResponse httpServletResponse,
            @RequestParam("login") String login,
            @RequestParam("password") String password,
            String redirect, Model model) {
        if (login.isEmpty() || password.isEmpty()) {
            logger.warn("Missing parameters, throw exception!");
            throw new BadCredentialsException("MissingParameters!");
        }

        UserCredentialsInfo userCredentialsInfo;

        userCredentialsInfo = userDetailsService.loadUserByUsername(login);
        logger.info("loaded user {}", userCredentialsInfo);

        if (!passwordEncoder.matches(password, userCredentialsInfo.getPassword())) {
            logger.warn("Pass did not match, throw exception");
            throw new BadCredentialsException("Wrong login or pass");
        }

        String token = JwtUtil.generateToken(signingKey, login, userCredentialsInfo);
        CookieUtil.create(httpServletResponse, jwtTokenCookieName, token, false, -1, domain);
        logger.info("Jwt token generated and added to cookies successfully: {}", token);

        return "Welcome, " + login + ", your role are:" + userCredentialsInfo.getRole();
    }
}
