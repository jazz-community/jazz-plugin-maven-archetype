#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import com.siemens.bt.jazz.services.base.BaseService;
import ${package}.builder.HelloWorldPostService;
import ${package}.builder.HelloWorldService;

/**
 * Entry point for the Service, called by the Jazz class loader.
 * 
 * <p>This class must be implemented for enabling plug-ins to run inside Jazz. The implemented interface corresponds to
 * the component in {@code plugin.xml}, and this service is therefore the provided service by the interface.</p>
 * 
 */
public class ${serviceName} extends BaseService implements I${serviceName} {
	/**
	 * Constructs a new Service
	 * <p>This constructor is only called by the Jazz class loader.</p>
	 */
	public ${serviceName}() {
		super();
		router.get("helloWorld", HelloWorldService.class);
		router.post("helloWorld", HelloWorldPostService.class);
	}
}
