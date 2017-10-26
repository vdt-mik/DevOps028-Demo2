package academy.softserve.sso.auth;

import org.springframework.web.util.WebUtils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * Holds methods to perform cookie operations
 */
public class CookieUtil {

    /**
     * allows to create cookie with parameters and add it to the response
     *
     * @param httpServletResponse {@link HttpServletResponse} in which cookie should be added
     * @param name                cookie name
     * @param value               cookie value
     * @param secure              Indicates to the browser whether the cookie should only be sent
     *                            using a secure protocol, such as HTTPS or SSL.
     * @param maxAge              int value cookie should live in seconds
     * @param domain              specifies the domain within which this cookie should be presented.
     */
    public static void create(HttpServletResponse httpServletResponse, String name, String value, Boolean secure, Integer maxAge, String domain) {
        Cookie cookie = new Cookie(name, value);
        cookie.setSecure(secure);
        cookie.setHttpOnly(true);
        cookie.setMaxAge(maxAge);
        cookie.setDomain(domain);
        cookie.setPath("/");
        httpServletResponse.addCookie(cookie);
    }

    /**
     * method allows to clear cookie with specified name
     * it is caused by setting param {@link Cookie#setMaxAge(int)} to "0" what means
     * that cookie should be deleted immidiately
     *
     * @param httpServletResponse {@link HttpServletResponse} where new cookie should be added
     * @param name                cookie name
     */
    public static void clear(HttpServletResponse httpServletResponse, String name) {
        Cookie cookie = new Cookie(name, null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        httpServletResponse.addCookie(cookie);
    }

    /**
     * retrieves cookie value from request
     *
     * @param httpServletRequest {@link HttpServletRequest} from which cookie should be got
     * @param name               cookie name
     * @return {@link String} value of cookie from {@code httpServletRequest} with name {@code name}
     */
    public static String getValue(HttpServletRequest httpServletRequest, String name) {
        Cookie cookie = WebUtils.getCookie(httpServletRequest, name);
        return cookie != null ? cookie.getValue() : null;
    }
}
