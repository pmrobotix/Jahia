<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:set var="image" value="${currentNode.properties.image.node}"/>
<c:set var="link" value="${currentNode.properties.link.node}"/>
<c:if test="${! empty link}">
    <c:url var="linkUrl" value="${link.url}"/>
</c:if>
<c:if test="${not empty image}">
    <c:url var="imageUrl" value="${image.url}"/>
</c:if>

<c:if test="${jcr:isNodeType(currentNode, 'jmix:categorized')}">
    <c:forEach items="${currentNode.properties['j:defaultCategory']}" var="category">
        <c:set var="categoryName" value="${categoryName} iso-${category.node.name}"/>
    </c:forEach>
</c:if>

<div class="isotope-item ${categoryName}">
	<div class="item-container">
    	<c:if test="${! empty linkUrl}"><a class="item-link" target="_blank" href="${linkUrl}"></c:if>
        	<c:if test="${! empty imageUrl}">
            	<img class="item-image" src="${imageUrl}"/>
            	<span class="item-caption">${currentNode.properties['jcr:title'].string}</span>
        	</c:if>
        <c:if test="${! empty linkUrl}"></a></c:if>
	</div>
</div>