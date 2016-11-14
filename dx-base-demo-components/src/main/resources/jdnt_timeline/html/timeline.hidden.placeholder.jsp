<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<%-- This is a placeholder view to show  --%>


<jsp:useBean id="now" class="java.util.Date" />
<%-- Get current date --%>
<fmt:formatDate pattern="MMMM" dateStyle="long" value="${now}" var="newsMonth"/>
<fmt:formatDate pattern="d/M/yy" dateStyle="short" value="${now}" var="newsDate"/>

    <li class="equal-height-columns">
        <div class="cbp_tmtime equal-height-column" style="height: 164px;"><span>${newsDate}</span> <span>${newsMonth}</span></div>
        <i class="cbp_tmicon rounded-x hidden-xs"></i>
        <div class="cbp_tmlabel equal-height-column" style="height: 194px;">
            <h2><fmt:message key="jdnt_timeline.placeholderTitle"/></h2>
            <div class="row">
                <div class="col-md-4">
                    <img class="img-responsive" src="${url.currentModule}/img/background.jpg" alt="">

                    <div class="md-margin-bottom-20"></div>
                </div>
                <div class="col-md-8">
                    <p><fmt:message key="jdnt_timeline.placeholderBody"/></p>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id purus a ex bibendum sagittis sit amet vel quam. Fusce sodales ...</p>
                    <a class="btn-u btn-u-sm" href="javascript:void(0)"><fmt:message key="jdmix_buttonText.readmore"/></a>
                </div>
            </div>
        </div>
    </li>
    <li class="equal-height-columns">
        <div class="cbp_tmtime equal-height-column" style="height: 349px;"><span>${newsDate}</span> <span>${newsMonth}</span></div>
        <i class="cbp_tmicon rounded-x hidden-xs"></i>
        <div class="cbp_tmlabel equal-height-column" style="height: 379px;">
            <h2>Add A News Article</h2>
            <div class="row">
                <div class="col-md-4">
                    <img class="img-responsive" src="${url.currentModule}/img/background.jpg" alt="">
                    <div class="md-margin-bottom-20"></div>
                </div>
                <div class="col-md-8">
                    <p><fmt:message key="jdnt_timeline.placeholderBody"/></p>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id purus a ex bibendum sagittis sit amet vel quam. Fusce sodales fermentum dignissim. Curabitur sit amet risus non neque pellentesque pharetra pharetra at dolor. Donec fringilla nisl sed urna consectetur, at efficitur tortor pharetra. Nullam quis tellus sapien. Praesent mollis leo eu nisi feugiat posuere. Integer suscipit, est sit amet aliquam tincidunt, sapien enim commodo mauris, sit amet scelerisque purus felis et ligula. Nullam vel metus nisl. Nullam nec volutpat sem, ut pretium neque. Curabitur eu imperdiet velit. Curabitur vulputate mi nunc, ac pellentesque magna mattis sed. Curabitur in neque ac ligula finibus imperdiet gravida maximus massa. Nunc malesuada nisi sed justo imperdiet porttitor. Nullam non arcu velit. Morbi iaculis auctor erat eu porta. Sed suscipit a augue vitae malesuada.</p>
                    <p></p>
                </div>
            </div>
        </div>
    </li>