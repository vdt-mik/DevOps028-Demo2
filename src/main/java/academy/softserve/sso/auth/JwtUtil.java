package academy.softserve.sso.auth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

/**
 * Holds methods allowing creating JWT tokens and retrieving info from ones
 */
public class JwtUtil {

    /**
     * {@link ObjectMapper} used to perform read/write object/json
     */
    private static ObjectMapper mapper = new MappingJackson2HttpMessageConverter().getObjectMapper();

    /**
     * allows to generate token including additional info
     *
     * @param signingKey  the BASE64-encoded algorithm-specific signing key to use to digitally sign the
     *                    JWT
     * @param subject     the JWT subject value
     * @param userDetails {@link UserCredentialsInfo} object containing user {@link User} info
     *                    its included in {@link Claims} in json format while generating token
     * @return {@link String} value of generated token
     */
    public static String generateToken(String signingKey, String subject, UserCredentialsInfo userDetails) {
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        JwtBuilder builder = Jwts.builder()
                .setSubject(subject)
                .setClaims(new HashMap<String, Object>() {{
                    try {
                        put("userDetails", mapper.writeValueAsString(userDetails));
                    } catch (JsonProcessingException e) {
                        e.printStackTrace();
                    }
                }})
                .setIssuedAt(now)
                .signWith(SignatureAlgorithm.HS256, signingKey);
        return builder.compact();
    }

    /**
     * allow to retrieve {@link UserDetails} object from JWT token context
     *
     * @param httpServletRequest {@link HttpServletRequest} which holds cookies
     * @param jwtTokenCookieName cookie name
     * @param signingKey         the BASE64-encoded algorithm-specific signing key to use to digitally sign the
     *                           JWT
     * @return {@link UserDetails} object retrieved from cookie or {@code null} if there is no
     * such cookie in {@code httpServletRequest} or this cookie is invalid
     */
    public static UserDetails getUserDetails(HttpServletRequest httpServletRequest, String jwtTokenCookieName, String signingKey) {
        String token = CookieUtil.getValue(httpServletRequest, jwtTokenCookieName);
        if (token == null) return null;
        Claims body = Jwts.parser().setSigningKey(signingKey).parseClaimsJws(token).getBody();
        String userDetailsStr = body.get("userDetails", String.class);

        try {
            UserCredentialsInfo userCredentialsInfo = mapper.readValue(userDetailsStr, UserCredentialsInfo.class);
            return new User(
                    userCredentialsInfo.getUserName(),
                    userCredentialsInfo.getPassword(),
                    new ArrayList<SimpleGrantedAuthority>() {{
                        add(new SimpleGrantedAuthority("ROLE_" + userCredentialsInfo.getRole()));
                    }});
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * allow to retrieve {@link String} subject from JWT token context
     *
     * @param httpServletRequest {@link HttpServletRequest} which holds cookies
     * @param jwtTokenCookieName cookie name
     * @param signingKey         the BASE64-encoded algorithm-specific signing key to use to digitally sign the
     *                           JWT
     * @return {@link String} subject retrieved from cookie or {@code null} if there is no
     * such cookie in {@code httpServletRequest} or this cookie is invalid
     */
    public static String getSubject(HttpServletRequest httpServletRequest, String jwtTokenCookieName, String signingKey) {
        String token = CookieUtil.getValue(httpServletRequest, jwtTokenCookieName);
        if (token == null) return null;
        return Jwts.parser().setSigningKey(signingKey).parseClaimsJws(token).getBody().getSubject();
    }
}
