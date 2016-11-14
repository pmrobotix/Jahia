<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<c:set var="boundComponent" value="${ui:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:choose>
	<c:when test="${not empty boundComponent && jcr:isNodeType(boundComponent, 'jmix:list')}">
		<c:set var="props" value="${currentNode.propertiesAsString}"/>
		<c:if test="${!renderContext.editMode}">
			<c:set var="targetProps" value="${bindedComponent.propertiesAsString}"/>
			<c:if test="${not empty locationMapKey}">
				<c:set var="mapKey" value="&amp;key=${locationMapKey}"/>
			</c:if>
			<template:addResources type="javascript"
								   resources="http://maps.google.com/maps/api/js?sensor=false&amp;language=${currentResource.locale.language}${mapKey}"/>
			<template:addResources type="javascript" resources="jquery.min.js"/>
			<template:addResources type="javascript" resources="jquery.jahia-googlemaps.js"/>

			<template:addResources>
				<script type="text/javascript">
					$(document).ready(function() {
						var map;
						var bounds = new google.maps.LatLngBounds();
						var mapOptions = {
							mapTypeId: 'roadmap'
						};
						// Display a map on the page
						map = new google.maps.Map(document.getElementById("map-${currentNode.identifier}"), mapOptions);
						map.setTilt(45);
						var markers = [

							<c:forEach items="${jcr:getChildrenOfType(boundComponent, 'jnt:content')}" var="item" varStatus="status" >
							<c:if test="${jcr:isNodeType(item, 'jmix:geotagged,jmix:locationAware,jnt:location')}">
							<c:set var="targetProps" value="${item.propertiesAsString}"/>
							<c:choose>
							<c:when test="${not empty targetProps['j:latitude'] && not empty targetProps['j:longitude']}">
							<c:set var="location" value="${targetProps['j:latitude']},${targetProps['j:longitude']}" />
							</c:when>
							<c:otherwise>
							<c:set var="location" value="${targetProps['j:street']}" />
							<c:set var="location" value="${location}${not empty location ? ', ' : ''}${targetProps['j:zipCode']}" />
							<c:set var="location" value="${location}${not empty location ? ', ' : ''}${targetProps['j:town']}" />
							<jcr:nodePropertyRenderer name="j:country" node="${bindedComponent}" renderer="country" var="country" />
							<c:set var="location" value="${location}${not empty location ? ', ' : ''}${country.displayName}" />
							</c:otherwise>
							</c:choose>

							{
								<c:if test="${not empty targetProps['j:latitude']}">
								latitude: '${targetProps['j:latitude']}',
								longitude: '${targetProps['j:longitude']}',
								</c:if>
								<c:if test="${empty targetProps['j:latitude']}">
								address: "${functions:escapeJavaScript(location)}",
								</c:if>
								icon: "${functions:escapeJavaScript(currentNode.properties['j:markerImage'].node.url)}",
								<c:if test="${not empty targetProps['jcr:title']}">
								title: "${functions:escapeJavaScript(targetProps['jcr:title'])}",
								</c:if>
								info: ""
								<c:if test="${not empty targetProps['jcr:title']}">
								+ "<strong>${functions:escapeJavaScript(targetProps['jcr:title'])}</strong>"
								</c:if>
								<c:if test="${not empty targetProps['j:street']}">
								+ "<br/>${functions:escapeJavaScript(targetProps['j:street'])}"
								</c:if>
								<c:if test="${not empty targetProps['j:zipCode'] || not empty targetProps['j:town']}">
								+ "<br/>"
								<c:if test="${not empty targetProps['j:zipCode']}">
								+ "${functions:escapeJavaScript(targetProps['j:zipCode'])}&nbsp;"
								</c:if>
								+ "${not empty targetProps['j:town'] ? functions:escapeJavaScript(targetProps['j:town']) : ''}"
								</c:if>
								<jcr:nodePropertyRenderer name="j:country" node="${currentNode}" renderer="country" var="country"/>
								+"<br/>${functions:escapeJavaScript(country.displayName)}"
							},

							</c:if>
							</c:forEach>
						];
						// Display multiple markers on a map
						var infoWindow = new google.maps.InfoWindow(), marker, i;

						// Loop through our array of markers & place each one on the map
						for( i = 0; i < markers.length; i++ ) {
							var position = new google.maps.LatLng(markers[i]['latitude'], markers[i]['longitude']);
							bounds.extend(position);
							marker = new google.maps.Marker({
								position: position,
								map: map,
								title: markers[i]['title']
							});

							// Allow each marker to have an info window
							google.maps.event.addListener(marker, 'click', (function(marker, i) {
								return function() {
									infoWindow.setContent(markers[i]['info']);
									infoWindow.open(map, marker);
								}
							})(marker, i));

							// Automatically center the map fitting all markers on the screen
							map.fitBounds(bounds);
						}

						// Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
						var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
							google.maps.event.removeListener(boundsListener);
						});
					});
				</script>
			</template:addResources>
		</c:if>
		<div>
			<c:if test="${not empty props['jcr:title']}">
				<h3>${fn:escapeXml(props['jcr:title'])}</h3>
			</c:if>
		<div class="map_wrapper" style="height:${props['j:height']}px">
			<div id="map-${currentNode.identifier}"  class="fullMap">
				<c:if test="${renderContext.editMode}">
					<p><fmt:message key="jnt_map.noPreviewInEditMode"/></p>
				</c:if>
			</div>
		</div>
		</div>
	</c:when>
	<c:otherwise>
		<c:if test="${renderContext.editMode}">
			<!-- We notify the user in case the component is bound on the wrong nodeType-->
			<fmt:message key="jnt_map.misbound.list"/>
		</c:if>
	</c:otherwise>
</c:choose>