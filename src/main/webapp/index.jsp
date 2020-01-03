<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<html>
    <head>
        <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${contextPath}/css/main.css" />
        <title>Futurama</title>
    </head>
    <body>

        <div class="Headline">
            <h3>Raumschiffgesellschafts Portal Futurama</h3>
        </div>

        <div class="Main">        
                
            <h4>In Progress: Raumschiffgesellschafts Portal</h4>
            <ul>
                <li><a href="index.jsp">Anmelden</a></li>
                <li><a href="index.jsp">Meine Flüge</a></li>
                <li><a href="Regristrieren.jsp">Registrieren</a></li>
                <li><a href="index.jsp">Flüge suchen</a></li>
                <li><a href="Fluege-Buchen.jsp">Flüge buchen</a></li>
                <br>
                <li><a href="Webpage_Template.jsp">Webpage Example / Tutorial: Pls Read First</a></li>
            </ul> 
            
            <br>
            <br>
            
            <h4>Depricated: Weindatenbank mit Webanbindung</h4>
            <ul>
                <li><a href="weine.jsp">Weine suchen</a></li>
                <li><a href="neuer-wein.jsp">Weine einfügen (JSTL)</a></li>
                <li><a href="weine_no_jstl.jsp">Weine einfügen (No JSTL)</a></li>
            </ul>

        </div>
    </body>
</html>
