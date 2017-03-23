#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.builder;

import java.io.IOException;
import java.io.Writer;
import java.net.URISyntaxException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.team.repository.service.TeamRawService;
import com.siemens.bt.jazz.services.base.rest.AbstractRestService;
import com.siemens.bt.jazz.services.base.rest.RestRequest;
import org.apache.commons.logging.Log;
import org.apache.http.auth.AuthenticationException;

public class HelloWorldService extends AbstractRestService {

    public HelloWorldService(Log log, HttpServletRequest request, HttpServletResponse response, RestRequest restRequest, TeamRawService parentService) {
        super(log, request, response, restRequest, parentService);
    }

    /**
     * Execute the desired action and return a result
     */
    public void execute() throws IOException, URISyntaxException, AuthenticationException {
        Writer writer = response.getWriter();
        writer.write("Hello World!!!");
    }
}
