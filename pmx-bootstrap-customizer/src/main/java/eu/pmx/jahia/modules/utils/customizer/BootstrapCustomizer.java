package eu.pmx.jahia.modules.utils.customizer;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;

public class BootstrapCustomizer extends AbstractFilter {
	
	@Override
	public String execute(String previousOut, RenderContext renderContext, Resource resource, RenderChain chain) throws Exception {		
		String out = previousOut;

		Pattern endBody = Pattern.compile("</body>");
		Matcher m = endBody.matcher(out);		
		if(m.find()){
			System.out.println("Application du filtre de customisation du CSS Bootstrap");
			out = m.replaceAll("<jahia:resource type=\"css\" path=\"/files/"+renderContext.getWorkspace()+renderContext.getSite().getPath()+"/files/bootstrap/css/siteCustomStyle.css\" insert=\"false\" resource=\"bootstrapPE.css\" title=\"\" key=\"\" />"
					+"\n"
					+ "</body>");			
		}else{
			System.out.println("Le filtre de customisation du CSS Bootstrap n'a pas trouvé le tag </body> dans la page HTML");
		}		
		return out;
	}
	
	@Override
    public boolean areConditionsMatched(RenderContext renderContext, Resource resource) {
        return super.areConditionsMatched(renderContext, resource) && renderContext.getSite().getAllInstalledModules().contains("pmx-bootstrap-customizer");
    }
}
