<%-- 
    Document   : meineFluege
    Created on : 02.01.2020, 16:29:01
    Author     : michaelstipsits
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@page import="net.froihofer.dbs.fluege.meineFluege" %> --%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html>
       <head>
            <c:set var="contextPath" value="/dbs-fluege"/>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <link rel="stylesheet" href="/dbs-fluege/css/main.css" />
            <title>Futurama</title>
       </head>
                    
            <body>

                 <div class="Headline">
                        <h3>Meine Flüge</h3>
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
                        String svnr = "123";  //RAUSLÖSCHEN SOBALD ANMELDUNG MIT COOKIES
                        request.setAttribute("svnr", svnr); //RAUSLÖSCHEN SOBALD ANMELDUNG MIT COOKIES
                        } %>
                       
                        <sql:setDataSource dataSource="jdbc/FluegeDB" />
                        <%-- <sql:query var="flug" sql="SELECT * FROM Flug" />  --%> 
                        <sql:query var="flug" sql="SELECT * FROM Flug WHERE FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)"> 
                            <sql:param value="${svnr}" />
                        </sql:query>
                        
                        <a href="${contextPath}/index.jsp">Zur Startseite</a> <a href="Fluege-Suchen.jsp">Flüge suchen</a>
                         
                        <form method="GET" action="" >
                            Abflugplanet: <select name="abflugplanet" value="${param.abflugplanet}">
                                    <option value=""></option>
                                    <option value="Earth">Earth</option> <%--RAUSLÖSCHEN--%>
                                    <option value="Erde">Erde</option>
                                    <option value="Jupiter">Jupiter</option>
                                    <option value="Mars">Mars</option>
                                    <option value="Merkur">Merkur</option>
                                    <option value="Neptun">Neptun</option>
                                    <option value="Saturn">Saturn</option>
                                    <option value="Uranus">Uranus</option>
                                    <option value="Venus">Venus</option>
                            </select>
                            Zielplanet: <select name="zielplanet" value="${param.zielplanet}">
                                    <option value=""></option>
                                    <option value="Earth">Earth</option> <%--RAUSLÖSCHEN--%>
                                    <option value="Erde">Erde</option>
                                    <option value="Jupiter">Jupiter</option>
                                    <option value="Mars">Mars</option>
                                    <option value="Merkur">Merkur</option>
                                    <option value="Neptun">Neptun</option>
                                    <option value="Saturn">Saturn</option>
                                    <option value="Uranus">Uranus</option>
                                    <option value="Venus">Venus</option>
                            </select>         
                            Abflugdatum:  <input type="date" name="abflugdatum" value="${param.abflugdatum}">
                            <input type="submit">
                        </form>
                        <p> </p>
                        
                        <c:if test="${not empty param.abflugdatum}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugzeit like ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)"> 
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                        <c:if test="${not empty param.abflugplanet}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugplanet = ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                         <c:if test="${not empty param.zielplanet}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Zielplanet = ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                         <c:if test="${not empty param.abflugdatum and not empty param.abflugplanet}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugzeit like ? AND Abflugplanet = ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                         
                        <c:if test="${not empty param.abflugdatum and not empty param.zielplanet}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugzeit like ? AND Zielplanet = ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                        <c:if test="${not empty param.abflugplanet and not empty param.zielplanet}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugplanet = ? AND Zielplanet = ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                        </c:if>
                        
                        <c:if test="${not empty param.abflugplanet and not empty param.zielplanet and not empty para.abflugdatum}">
                            <sql:query var="flug" sql="SELECT * FROM Flug WHERE Abflugplanet = ? AND Zielplanet = ? AND Abflugzeit like ? AND FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = ?)">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                        </c:if>
                        
                            
                        
                        
                        <c:if test="${flug.rowCount == 0}">
                            <p style="color: red;">Keine Einträge gefunden!</p>
                        </c:if>

                        <c:if test="${flug.rowCount > 0}">
                           <table class="data table-striped">
                             <tr><th>FlugNr</th><th>Abflugplanet</th><th>Zielplanet</th><th>Abflugzeit</th><th>Ankunftszeit</th></tr>
                                <c:forEach var="flug" items="${flug.rows}">
                                    <tr><td>${flug.FlugNr}</td><td>${flug.abflugplanet}</td><td>${flug.zielplanet}</td><td>${flug.abflugzeit}</td><td>${flug.ankuftszeit}</td></tr>
                                </c:forEach>
                            </table>
                        </c:if>
                            
                            
                            
                    
                </div>
            </body>
</html>
