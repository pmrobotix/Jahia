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
<template:addResources type="javascript" resources="jquery.min.js,isotope.pkgd.min.js"/>
<template:addResources type="css" resources="isotope.css"/>
<template:include view="hidden.header"/>

<c:set var="columnPercentage" value="${currentNode.properties['columnPercentage'].string}"/>

<c:forEach items="${moduleMap.currentList}" var="isotopEntry" begin="${moduleMap.begin}" end="${moduleMap.end}">
    <c:if test="${jcr:isNodeType(isotopEntry, 'jmix:categorized')}">
        <c:forEach items="${isotopEntry.properties['j:defaultCategory']}" var="category">
            <c:set var="categoryPath" value="${category.node.path}"/>
            <c:if test="${! fn:contains(categoriesPath, categoryPath)}">
                <c:set var="categoriesPath" value="${categoryPath} ${categoriesPath}"/>
            </c:if>
        </c:forEach>
    </c:if>
</c:forEach>

<div class="isotope-container grid-${columnPercentage}">
  
  <ul class="pmx-isotope-filters" id="pmx-isotope-filter-${currentNode.identifier}">
      <li class="active"><a href="#" data-filter="*">Show All</a></li>
      <c:forEach items="${fn:split(categoriesPath,' ')}" var="categoryPath">
          <jcr:node var="category" path="${categoryPath}"/>
          <li><a href="#" data-filter=".iso-${category.name}">${category.displayableName}</a></li>
          <c:remove var="isActive"/>
      </c:forEach>
  </ul>

  <div id="isotope-${currentNode.identifier}" class="isotope-items">
      <div class="grid-sizer"></div>
      <div class="grid-item"></div>
      <c:forEach items="${moduleMap.currentList}" var="isotopEntry" begin="${moduleMap.begin}" end="${moduleMap.end}">
          <template:module node="${isotopEntry}" nodeTypes="pmxnt:isotopEntry"/>
      </c:forEach>
  </div>
  
</div>

<c:if test="${renderContext.editMode}">
  <template:module path="*" nodeTypes="pmxnt:isotopEntry"/>
</c:if>

<c:if test="${! renderContext.editMode}">
  <template:addResources type="inline">
    
    <script type="text/javascript">
      jQuery(window).load(function () {
        
        var $container = $('#isotope-${currentNode.identifier}');
        
        $container.isotope({
 			// set itemSelector so .grid-sizer is not used in layout
  			itemSelector: '.isotope-item',
  			percentPosition: true,
  			masonry: {
    			// use element for option
    			columnWidth: '.grid-sizer'
  			},
  			transitionDuration: '0.65s'
		});
        
        $('#pmx-isotope-filter-${currentNode.identifier} a').click(function () {
          $('#pmx-isotope-filter-${currentNode.identifier} li').removeClass('active');
          $(this).parent('li').addClass('active');
          var selector = $(this).attr('data-filter');
          $container.isotope({filter: selector});
          return false;
        });
        
        $('#isotope-shuffle-${currentNode.identifier}').click(function () {
          $container.isotope('updateSortData').isotope({
            sortBy: 'random'
          });
        });
        
        $(window).resize(function () {
          $container.isotope('layout');
        });
        
      });
      
    </script>
  </template:addResources>
</c:if>