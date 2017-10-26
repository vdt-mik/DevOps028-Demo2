package academy.softserve.sso.exceptions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.servlet.http.HttpServletRequest;

/**
 * Bean contains handlers for exceptions, thrown from beans annotated with {@link org.springframework.stereotype.Controller}
 * in this case axception should be mapped manually
 */
@ControllerAdvice
public class ControllerExceptionHandler extends ResponseEntityExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(ControllerExceptionHandler.class);


    @ExceptionHandler(value = {AuthenticationException.class})
    public ResponseEntity<ErrorDto> handleAuthenticationException(AuthenticationException ex, HttpServletRequest request) {
        return makeErrorDto(ex, HttpStatus.UNAUTHORIZED, request);
    }


    /**
     * form {@link ResponseEntity <ErrorDto> } from
     *
     * @param exception reason of method call
     * @param status    status code to set
     * @param request   client request
     */
    private ResponseEntity<ErrorDto> makeErrorDto(RuntimeException exception, HttpStatus status, HttpServletRequest request) {
        ErrorDto errorDto = new ErrorDto();
        errorDto.setCode(status.value());
        errorDto.setMessage(exception.getLocalizedMessage() +
                (status.equals(HttpStatus.UNAUTHORIZED) ?
                        (" visit: <a href =\"" + request.getRemoteAddr()+"/login" + "\"/>") : null) + "\n " + exception.getLocalizedMessage());

        ResponseEntity<ErrorDto> errorDtoResponseEntity = new ResponseEntity<>(errorDto, status);

        logger.warn("error of type {} occured, sending {}",
                exception.getClass().getName(),
                errorDtoResponseEntity
        );

        return errorDtoResponseEntity;
    }


    @Override
    protected ResponseEntity<Object> handleExceptionInternal(Exception ex, Object body, HttpHeaders headers,
                                                             HttpStatus status, WebRequest request) {
        logger.info(ex.getLocalizedMessage());
        return super.handleExceptionInternal(ex, body, headers, status, request);
    }

}
