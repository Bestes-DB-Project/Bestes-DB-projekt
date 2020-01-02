<%-- 
    Document   : Fluege-Suchen
    Created on : 02.01.2020, 12:58:24
    Author     : Bernhard
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<html>
  <head>
    <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${contextPath}/css/main.css" />
    <title>Flüge</title>
  </head>
  <body>
    <h1>Flüge</h1>
    <form method="GET" action="">
        <table>
              <tr><td>Abflugplanet:</td><td><input name="abflugPlanet" type="text" value="${param.abflugPlanet}" required></td></tr>
              <tr><td>Reiseziel:</td><td><input name="ankunftPlanet" type="text" value="${param.ankunftPlanet}" required></td></tr>
              <tr><td>Tag (JJJJ-MM-DD):</td><td><input name="tag" pattern=".{10}" type="text" value="${param.tag}" title="JJJJ-MM-DD" required></td></tr>   
        </table>
              <p></p>
              <a href="${contextPath}/index.jsp" style="margin-left:120px">Zur Startseite </a>
              <button class="btn btn-primary" style="margin-left: 10px">Suchen</button> 
    </form>
      
        <hr /><br/>
        <sql:setDataSource dataSource="jdbc/FluegeDB" />
        
        <c:if test="${not empty param.abflugPlanet and not empty param.ankunftPlanet and not empty param.tag}">
          <sql:query var="flüge" sql="SELECT FlugNr, Abflugzeit, Ankuftszeit FROM Flug WHERE abflugplanet like ? AND zielplanet like ? AND abflugzeit like ?">
            <sql:param value="%${param.abflugPlanet}%" />
             <sql:param value="%${param.ankunftPlanet}%"/>
             <sql:param value="${param.tag}%"/>
          </sql:query>
        </c:if>
        <c:if test="${flüge.rowCount == 0}">
          <p style="color: red;">Keine Einträge gefunden!</p>
        </c:if>
        <c:if test="${flüge.rowCount > 0}">
          <table class="data table-striped">
            <tr><th>Flugnummer</th><th>Abflugzeit</th><th>Ankunftszeit</th></tr>
            <c:forEach var="flug" items="${flüge.rows}">
              <tr><td>${flug.flugnr}</td><td>${flug.abflugzeit}</td><td>${flug.ankuftszeit}</td></tr>
            </c:forEach>
          </table>
        </c:if>
</body>
</html>
