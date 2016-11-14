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

package org.jahia.modules.jahiademo.actions;

import net.fortuna.ical4j.data.CalendarOutputter;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.ValidationException;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.property.CalScale;
import net.fortuna.ical4j.model.property.ProdId;
import net.fortuna.ical4j.model.property.Version;
import net.fortuna.ical4j.util.UidGenerator;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

public class GenerateEventIcs extends Action {

    private static final Logger logger = LoggerFactory.getLogger(GenerateEventIcs.class);

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {

        try {
            JCRNodeWrapper node = resource.getNode();
            HttpServletResponse response = renderContext.getResponse();
            java.util.Calendar endDate = null;
            java.util.Calendar startDate = null;
            String title = (node.getProperty("jcr:title").getString() != null) ? node.getProperty("jcr:title").getString() : node.getName();

            if (node.hasProperty("startDate")) {
                startDate = node.getProperty("startDate").getDate();
                //Java calendar month count starts with zero
                startDate.add(Calendar.MONTH, -1);
            }

            if (node.hasProperty("endDate")) {
            // get the end date and time
            endDate = node.getProperty("endDate").getDate();
            endDate.add(Calendar.MONTH, -1);
            endDate.add(Calendar.DAY_OF_MONTH, +1);
            }

            response.setHeader("Content-Disposition", "attachment;filename=\"" + title + ".ics\"");
            response.setContentType("text/calendar");

            net.fortuna.ical4j.model.Calendar calendar = new net.fortuna.ical4j.model.Calendar();
            calendar.getProperties().add(new ProdId("-//Ben Fortuna//iCal4j 1.0//EN"));
            calendar.getProperties().add(Version.VERSION_2_0);
            calendar.getProperties().add(CalScale.GREGORIAN);

            if(startDate != null) {
                // create the event event..
                Date start = new Date(startDate.getTime());
                VEvent meeting;
                if (endDate != null) {
                    Date end = new Date(endDate.getTime());
                    meeting = new VEvent(start, end, title);
                } else {
                    meeting = new VEvent(start, title);
                }

                // Generate a UID for the event..
                UidGenerator ug = new UidGenerator("1");
                meeting.getProperties().add(ug.generateUid());
                calendar.getComponents().add(meeting);

                ServletOutputStream fout = response.getOutputStream();
                CalendarOutputter outputter = new CalendarOutputter();
                outputter.output(calendar, fout);

                fout.flush();
            }
        } catch (ValidationException e) {
            logger.error(e.getMessage(), e);
        }

        return null;
    }
}