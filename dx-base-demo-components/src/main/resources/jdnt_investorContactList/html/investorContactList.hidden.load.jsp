<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>

<jcr:nodeProperty node="${currentNode}" name="maxItems" var="maxItems"/>
<c:set var="lastinvestorContact"
       value="select * from [jdnt:investorContact] as investorContact
       where ISDESCENDANTNODE(investorContact,'${renderContext.mainResource.node.resolveSite.path}')
       order by investorContact.[jcr:created] desc"/>
<query:definition var="listQuery" statement="${lastinvestorContact}" limit="${maxItems.long}"/>

<c:set target="${moduleMap}" property="editable" value="false"/>
<c:set target="${moduleMap}" property="emptyListMessage"><fmt:message key="label.noContactFound"/></c:set>
<c:set target="${moduleMap}" property="listQuery" value="${listQuery}"/>
<c:set target="${moduleMap}" property="subNodesView" value="${currentNode.properties['j:subNodesView'].string}"/>

<c:if test="${not renderContext.liveMode}">
    <fmt:message key="jdnt_investorContactList.liveModeOnly"/>
</c:if>