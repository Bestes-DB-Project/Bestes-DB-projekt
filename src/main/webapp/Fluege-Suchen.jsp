<%-- 
    Document   : Fluege-Suchen
    Created on : 02.01.2020, 12:58:24
    Author     : Bernhard
--%>


<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
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
    <title>Futurama</title>
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
                  <% 
                  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");  
                  LocalDate dateT = LocalDate.now();  
                  request.setAttribute("dateT", dateT);
                  %>
                  <h5>Zum Filtern der Flüge: </h5>
                  <tr><td>Abflugplanet:</td><td>
                       <select name="abflugPlanet" value="${param.abflugPlanet}">
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
                          <select name="ankunftPlanet" value="${param.ankunftPlanet}">
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
                  <tr><td>Abflugdatum:</td><td><input name="tag" type="date" min="${dateT}" value="${param.tag}"</td></tr>   
                
            </table>
                  <p></p>
                  <a href="${contextPath}/meineFluege.jsp" >meine Buchungen </a>
                  <button class="btn btn-primary" style="margin-left: 10px">Suchen</button> 
        </form>

            <hr /><br/>
           
            <sql:setDataSource dataSource="jdbc/FluegeDB" />
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE Abflugzeit > CURRENT_TIMESTAMP">
              </sql:query>
                      
            <c:if test="${not empty param.abflugPlanet}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugplanet like ? AND Abflugzeit > CURRENT_TIMESTAMP">
                <sql:param value="%${param.abflugPlanet}%" />
              </sql:query>
            </c:if>
            
             <c:if test="${not empty param.ankunftPlanet}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE zielplanet like ? AND Abflugzeit > CURRENT_TIMESTAMP">
                 <sql:param value="%${param.ankunftPlanet}%"/>
              </sql:query>
            </c:if>
            
            <c:if test="${not empty param.tag}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugzeit like ?">
                 <sql:param value="${param.tag}%"/>
              </sql:query>
            </c:if>
            
            
             <c:if test="${not empty param.abflugPlanet and not empty param.ankunftPlanet}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugplanet like ? AND zielplanet like ? AND Abflugzeit > CURRENT_TIMESTAMP">
                <sql:param value="%${param.abflugPlanet}%" />
                 <sql:param value="%${param.ankunftPlanet}%"/>
              </sql:query>
            </c:if>
           
            
            <c:if test="${not empty param.abflugPlanet and not empty param.tag}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugplanet like ? AND abflugzeit like ?">
                <sql:param value="%${param.abflugPlanet}%" />
                 <sql:param value="${param.tag}%"/>
              </sql:query>
            </c:if>
            
            <c:if test="${not empty param.ankunftPlanet and not empty param.tag}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE zielplanet like ? AND abflugzeit like ?">
                 <sql:param value="%${param.ankunftPlanet}%"/>
                 <sql:param value="${param.tag}%"/>
              </sql:query>
            </c:if>

            <c:if test="${not empty param.abflugPlanet and not empty param.ankunftPlanet and not empty param.tag}">
              <sql:query var="flüge" sql="SELECT * FROM Flug WHERE abflugplanet like ? AND zielplanet like ? AND abflugzeit like ? AND Abflugzeit > CURRENT_TIMESTAMP">
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
                  <tr><td>${flug.flugnr}</td><td>${flug.abflugplanet}</td><td>${flug.zielplanet}</td><td>${flug.abflugzeit}</td><td>${flug.ankuftszeit}</td><td><form action="${contextPath}/Fluege-Buchen.jsp" method="post"><button ${ outdated eq "false" ? 'disabled="disabled"' : ''} name="flugnr" value="${flug.flugnr}">Buchen</button></form></td></tr>
                </c:forEach>
              </table>
            </c:if>
    </div>
    </body>
</html>
