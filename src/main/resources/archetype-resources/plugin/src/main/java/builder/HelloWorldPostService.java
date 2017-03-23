#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.builder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URISyntaxException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.siemens.bt.jazz.services.base.rest.RestRequest;
import org.apache.commons.logging.Log;
import org.apache.http.auth.AuthenticationException;

import com.ibm.team.repository.service.TeamRawService;
import com.siemens.bt.jazz.services.base.rest.AbstractRestService;

public final class HelloWorldPostService extends AbstractRestService {

    public HelloWorldPostService(Log log, HttpServletRequest request, HttpServletResponse response, RestRequest restRequest, TeamRawService parentService) {
        super(log, request, response, restRequest, parentService);
    }

    public void execute() throws IOException, URISyntaxException, AuthenticationException {
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                        request.getInputStream()));
        //BufferedReader reader = request.getReader();
        StringBuilder builder = new StringBuilder(request.getContentLength());

        for (String line = reader.readLine(); line != null; line = reader.readLine()) {
            builder.append(line);
        }

        String content = builder.toString();
        response.getWriter().write("POST successful! The following data was sent:${symbol_escape}n" + content);
    }
}
