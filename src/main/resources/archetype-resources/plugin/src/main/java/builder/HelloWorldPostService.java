#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.builder;

import com.ibm.team.repository.service.TeamRawService;
import com.siemens.bt.jazz.services.base.rest.parameters.PathParameters;
import com.siemens.bt.jazz.services.base.rest.parameters.RestRequest;
import com.siemens.bt.jazz.services.base.rest.service.AbstractRestService;
import com.siemens.bt.jazz.services.base.utils.RequestReader;
import org.apache.commons.logging.Log;
import org.apache.http.auth.AuthenticationException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URISyntaxException;

public final class HelloWorldPostService extends AbstractRestService {

    public HelloWorldPostService(
            Log log, HttpServletRequest request,
            HttpServletResponse response,
            RestRequest restRequest,
            TeamRawService parentService,
            PathParameters pathParameters) {
        super(log, request, response, restRequest, parentService, pathParameters);
    }

    public void execute() throws IOException, URISyntaxException, AuthenticationException {
        String content = RequestReader.readAsString(request);
        response.getWriter().write("POST successful! The following data was sent:\n" + content);
    }
}
