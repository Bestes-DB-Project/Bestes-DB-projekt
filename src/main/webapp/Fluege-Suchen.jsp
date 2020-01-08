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
  <body >
    <div class="Headline">
        <h1>Flüge</h1>
    </div>
      
    <div class="Main">
        <% Cookie cookie = null;
                        Cookie[] cookies = null;
                        
                        cookies = request.getCookies();

                        if( cookies != null ) {
                           for (int i = 0; i < cookies.length; i++) {
                              cookie = cookies[i];
                              if (cookie.getName().equals("SVNR")) {
                                    String svnr = cookie.getValue();
                                    request.setAttribute("svnr", svnr);
                                    break;
                                  }
                            }
                        } %>
        <c:if test="${empty svnr}">
                <c:redirect url = "${contextPath}/../index.jsp"/>
        </c:if>
        <form method="GET" action="">
            <table>
                   
                  <tr><td>Abflugplanet:</td><td>
                       <select name="abflugPlanet" value="${param.abflugPlanet}" required>
                                    <option value=""></option>
                                    <option value="Erde">Erde</option>
                                    <option value="Jupiter">Jupiter</option>
                                    <option value="Mars">Mars</option>
                                    <option value="Merkur">Merkur</option>
                                    <option value="Neptun">Neptun</option>
                                    <option value="Saturn">Saturn</option>
                                    <option value="Uranus">Uranus</option>
                                    <option value="Venus">Venus</option>
                            </select> </td></tr>
                  <tr><td>Reiseziel:</td><td>
                          <select name="ankunftPlanet" value="${param.ankunftPlanet}" required>
                                    <option value=""></option>
                                    <option value="Erde">Erde</option>
                                    <option value="Jupiter">Jupiter</option>
                                    <option value="Mars">Mars</option>
                                    <option value="Merkur">Merkur</option>
                                    <option value="Neptun">Neptun</option>
                                    <option value="Saturn">Saturn</option>
                                    <option value="Uranus">Uranus</option>
                                    <option value="Venus">Venus</option>
                            </select> </td></tr>
                  <tr><td>Abflugdatum:</td><td><input name="tag" type="date" value="${param.tag}" required></td></tr>   
                
            </table>
                  <p></p>
                  <a href="${contextPath}/meineFluege.jsp" >meine Buchungen </a>
                  <button class="btn btn-primary" style="margin-left: 10px">Suchen</button> 
        </form>

            <hr /><br/>
            <sql:setDataSource dataSource="jdbc/FluegeDB" />

            <c:if test="${not empty param.abflugPlanet and not empty param.ankunftPlanet and not empty param.tag}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugplanet like ? AND zielplanet like ? AND abflugzeit like ?">
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
                <tr><th>Flugnummer</th><th>Abflugplanet</th><th>Zielplanet</th><th>Abflugzeit</th><th>Ankunftszeit</th></tr>
                <c:forEach var="flug" items="${flüge.rows}">
                  <tr><td>${flug.flugnr}</td><td>${flug.abflugplanet}</td><td>${flug.zielplanet}</td><td>${flug.abflugzeit}</td><td>${flug.ankuftszeit}</td><td><form action="${contextPath}/Fluege-Buchen.jsp" method="post"><button name="flugnr" value="${flug.flugnr}">Buchen</button></form></td></tr>
                </c:forEach>
              </table>
            </c:if>
    </div>
    </body>
</html>
