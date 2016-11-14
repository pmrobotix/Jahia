/**
 * ==========================================================================================
 * =                   JAHIA'S DUAL LICENSING - IMPORTANT INFORMATION                       =
 * ==========================================================================================
 *
 *                                 http://www.jahia.com
 *
 *     Copyright (C) 2002-2016 Jahia Solutions Group SA. All rights reserved.
 *
 *     THIS FILE IS AVAILABLE UNDER TWO DIFFERENT LICENSES:
 *     1/GPL OR 2/JSEL
 *
 *     1/ GPL
 *     ==================================================================================
 *
 *     IF YOU DECIDE TO CHOOSE THE GPL LICENSE, YOU MUST COMPLY WITH THE FOLLOWING TERMS:
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *
 *     2/ JSEL - Commercial and Supported Versions of the program
 *     ===================================================================================
 *
 *     IF YOU DECIDE TO CHOOSE THE JSEL LICENSE, YOU MUST COMPLY WITH THE FOLLOWING TERMS:
 *
 *     Alternatively, commercial and supported versions of the program - also known as
 *     Enterprise Distributions - must be used in accordance with the terms and conditions
 *     contained in a separate written agreement between you and Jahia Solutions Group SA.
 *
 *     If you are unsure which license is appropriate for your use,
 *     please contact the sales department at sales@jahia.com.
 */

package org.jahia.modules.jahiademo.filter;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpURL;
import org.apache.commons.httpclient.methods.GetMethod;
import org.jahia.services.content.JCRCallback;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.JCRTemplate;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.util.LinkedHashMap;
import java.util.Map;

public class StockWidgetFilter extends AbstractFilter {

    private final static Logger LOGGER = LoggerFactory.getLogger(StockWidgetFilter.class);
    private static final String PROPERTY_VALUE = "value";
    private static final String PROPERTY_VARIATION = "variation";
    private static final String PROPERTY_DESCRIPTION = "description";
    private static String API_URL = "finance.google.com";
    private static String API_path = "/finance/info";

    /**
     *
     * @param renderContext
     * @param resource
     * @param chain
     * @return
     * @throws Exception
     */
    @Override
    public String prepare(final RenderContext renderContext,
                          final Resource resource,
                          final RenderChain chain) throws Exception {
        final JSONObject stock = queryGoogleFinanceAPI(API_path, "client", "ig", "q", getStockProperty(resource, "stock"));
        final String stockValue;
        final String stockVariation;
        final String stockDescription;

        if (stock != null) {
            final String value = stock.getString("l");
            final String variation = stock.getString("c");
            final String description = stock.getString("e");
            stockValue = value;
            stockVariation = variation;
            stockDescription = description;

            saveStock(resource, value, variation, description);
        } else {
            stockValue = getStockProperty(resource, PROPERTY_VALUE);
            stockVariation = getStockProperty(resource, PROPERTY_VARIATION);
            stockDescription = getStockProperty(resource, PROPERTY_DESCRIPTION);
        }
        renderContext.getRequest().setAttribute("stockValue", stockValue);
        renderContext.getRequest().setAttribute("stockVariation", stockVariation);
        renderContext.getRequest().setAttribute("stockDescription", stockDescription);

        return super.prepare(renderContext, resource, chain);
    }

    /**
     *
     * @param path
     * @param params
     * @return
     * @throws RepositoryException
     */
    private JSONObject queryGoogleFinanceAPI(final String path,
                                             final String... params) throws RepositoryException {
        try {
            final HttpClient httpClient = new HttpClient();
            final HttpURL url = new HttpURL(API_URL, -1, path);

            final Map<String, String> m = new LinkedHashMap<String, String>();
            for (int i = 0; i < params.length; i += 2) {
                m.put(params[i], params[i + 1]);
            }

            url.setQuery(m.keySet().toArray(new String[m.size()]), m.values().toArray(new String[m.size()]));
            final long l = System.currentTimeMillis();
            LOGGER.debug("Start request : " + url);
            final GetMethod httpMethod = new GetMethod(url.toString());
            try {
                httpClient.getParams().setSoTimeout(1000);
                httpClient.executeMethod(httpMethod);
                return new JSONObject(httpMethod.getResponseBodyAsString());
            } finally {
                httpMethod.releaseConnection();
                LOGGER.debug("Request " + url + " done in " + (System.currentTimeMillis() - l) + "ms");
            }
        } catch (java.net.SocketTimeoutException te) {
            LOGGER.warn("Timeout Exception on request to Google Finance API");
            return null;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            return null;
        }
    }

    /**
     *
     * @param resource
     * @param value
     * @param variation
     * @param description
     * @throws RepositoryException
     */
    private void saveStock(final Resource resource,
                           final String value,
                           final String variation,
                           final String description) throws RepositoryException {
        JCRTemplate.getInstance().doExecuteWithSystemSessionAsUser(null, resource.getNode().getSession().getWorkspace().getName(), null,
                new JCRCallback<Object>() {
                    public Object doInJCR(final JCRSessionWrapper session) throws RepositoryException {
                        final JCRNodeWrapper stockwidgetNode = session.getNode(resource.getNode().getPath());
                        stockwidgetNode.setProperty(PROPERTY_VALUE, value);
                        stockwidgetNode.setProperty(PROPERTY_VARIATION, variation);
                        stockwidgetNode.setProperty(PROPERTY_DESCRIPTION, description);
                        stockwidgetNode.saveSession();
                        return null;
                    }
                });
    }

    /**
     *
     * @param resource
     * @param property
     * @return
     * @throws RepositoryException
     */
    private String getStockProperty(final Resource resource,
                                    final String property) throws RepositoryException {
        final JCRNodeWrapper stockwidgetNode = resource.getNode();
        if (stockwidgetNode.hasProperty(property)) {
            return stockwidgetNode.getProperty(property).getString();
        } else {
            return "";
        }
    }

}