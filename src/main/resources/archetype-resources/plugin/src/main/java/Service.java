#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

/**
 * Entry point for the service, called by the Jazz class loader.
 * 
 * <p>This class must be implemented for enabling plugins to run inside Jazz. The implemented interface corresponds to
 * the component in {@code plugin.xml}, and this service is therefore the provided service by the interface.</p>
 * 
 */
public abstract class Service implements IService {
}
