<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:set var="loadAction" value="${currentNode.properties['loadAction'].string}" />

<template:addResources type="javascript" resources="custom/infiniteScroller.js"/>
<template:addResources type="css" resources="jahiademo-components.css"/>

<c:set var="boundComponent" value="${uiComponents:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>

<c:if test="${not empty boundComponent and (jcr:isNodeType(boundComponent, 'jmix:list') or jcr:isNodeType(boundComponent, 'jnt:query')) and not renderContext.editMode}">

    <%-- Now, we start the pager to show the initial number of elements (news, images, etc) some variables might not be needed --%>
    <c:set var="pagesizeid" value="pagesize${boundComponent.identifier}"/>
    <c:set var="pageSize" value="${currentNode.properties['pageSize'].long}"/>


    <c:set var="varName">${boundComponent.identifier}_loaded</c:set>
    <c:set var="totalSize" value="${2147483647}"/>

    <template:initPager totalSize="${totalSize}" pageSize="${pageSize}" id="${boundComponent.identifier}"/>

    <c:if test="${not empty moduleMap.paginationActive and moduleMap.totalSize > 0 and moduleMap.nbPages > 0 and moduleMap.end<moduleMap.totalSize}">

        <div id="infiniteScrollerMessage" style="display: none;"><fmt:message key="jdnt_infiniteScroller.message"/></div>

        <%-- If the binded node is a list, then we simply iterate the items --%>
        <c:if test="${jcr:isNodeType(boundComponent, 'jmix:list')}">
            <c:set var="scrollerUrls" value=""/>
            <c:forEach items="${boundComponent.nodes}" var="items">
                <c:set var="scrollerUrls" value="${scrollerUrls}${url.base}${items.path}.html.ajax,"/>
            </c:forEach>
        </c:if>

        <%-- We set a query if the binded node is a query component (because the bound component is empty). --%>
        <c:if test="${jcr:isNodeType(boundComponent, 'jnt:query')}">
            <template:include view="hidden.initquery"/>
            <c:set var="scrollerUrls" value="${moduleMap.scrollerUrls}"/>
        </c:if>

        <c:set var="start" value="${currentNode.properties['pageSize'].long}" />
        <c:set var="finish" value="${currentNode.properties['loadItems'].long}" />

        <div id="infiniteScrollerInit"
             url='${scrollerUrls}'
             start="${start}"
             finish="${finish}"
             loadAction="${loadAction}"
             buttonMessage="<c:choose>
                                <c:when test="${jcr:isNodeType(currentNode, 'jdmix:buttonText')}">
                                    <template:include view="hidden.buttonText"/>
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jdnt_infiniteScroller.readmore"/>
                                </c:otherwise>
                            </c:choose>">
        </div>
    </c:if>
</c:if>
