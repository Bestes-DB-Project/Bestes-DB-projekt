<%-- 
    Document   : meineFluege
    Created on : 02.01.2020, 16:29:01
    Author     : michaelstipsits
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="net.froihofer.dbs.fluege.FluegeBuchen" %>
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
                        <h3>Meine Buchungen</h3>
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
                        <sql:setDataSource dataSource="jdbc/FluegeDB" />                 
                        <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE UserSVNr = ?;"> 
                            <sql:param value="${svnr}" />
                        </sql:query>
                        
                        <sql:query var="person" sql="SELECT * FROM Person WHERE SVNr = ?"> 
                            <sql:param value="${svnr}" />
                        </sql:query>
                        
                       <c:if test="${person.rowCount > 0}">
                                <c:forEach var="person" items="${person.rows}"> 
                                    <h3> Hallo   <tr><td>${person.Vorname} </td><td>${person.Nachname}</td></tr>!  </h3>
                                </c:forEach> 
                        </c:if>
                       <p></p>
                       
                        <% if (request.getAttribute(FluegeBuchen.ERROR_MSG_PARAM) != null) { %>
                        <p style="color: red"><%=request.getAttribute(FluegeBuchen.ERROR_MSG_PARAM)%></p>
                        <% } %>
                       
                       <p>
                        <div style="display: flex;">
                            <form name="logout" action="${contextPath}/index.jsp" onClick="deleteCookies()" method="post"><button>Logout</button></form> 
                            <form name="fluegeSuchen" action="${contextPath}/Fluege-Suchen.jsp" method="post" style="margin-left:10px"><button>Flüge suchen</button></form>
                            
                            
                        </div>                               
                        </p>
                        <p></p> 
                        <h5>Zum Filtern der letzten Buchungen: </h5> <p></p> 
                 
                        <form method="GET" action="${contextPath}/meineFluege.jsp" >
                            Abflugplanet: <select name="abflugplanet" value="${param.abflugplanet}">
                                    <option value=""></option>
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
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugzeit like ? AND UserSVNr = ?"> 
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                        <c:if test="${not empty param.abflugplanet}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugplanet = ? AND UserSVNr = ?">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                         <c:if test="${not empty param.zielplanet}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Zielplanet = ? AND UserSVNr = ?">
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                         <c:if test="${not empty param.abflugdatum and not empty param.abflugplanet}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugzeit like ? AND Abflugplanet = ? AND UserSVNr = ?">
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                         
                        <c:if test="${not empty param.abflugdatum and not empty param.zielplanet}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugzeit like ? AND Zielplanet = ? AND UserSVNr = ?">
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                         </c:if>
                        
                        <c:if test="${not empty param.abflugplanet and not empty param.zielplanet}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugplanet = ? AND Zielplanet = ? AND UserSVNr = ?">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                        </c:if>
                        
                        <c:if test="${not empty param.abflugplanet and not empty param.zielplanet and not empty para.abflugdatum}">
                            <sql:query var="buchung" sql="SELECT * FROM Bucht B LEFT JOIN Flug F ON B.FlugNr = F.FlugNr LEFT JOIN Person P ON P.SVNR = B.SVNR WHERE Abflugplanet = ? AND Zielplanet = ? AND Abflugzeit like ? AND UserSVNr = ?">
                             <sql:param value="${param.abflugplanet}" />
                             <sql:param value="${param.zielplanet}" />
                             <sql:param value="%${param.abflugdatum}%" />
                             <sql:param value="${svnr}" />
                            </sql:query>
                        </c:if>
                        
                            
                        
                        
                        <c:if test="${buchung.rowCount == 0}">
                            <p style="color: red;">Keine Einträge gefunden!</p>
                        </c:if>

                        <c:if test="${buchung.rowCount > 0}">
                           <table class="data table-striped">
                             <tr><th>FlugNr</th><th>Abflugplanet</th><th>Zielplanet</th><th>Abflugzeit</th><th>Ankunftszeit</th><th>Voname</th><th>Nachname</th><th>Klasse</th></tr>
                                <c:forEach var="buchung" items="${buchung.rows}">
                                    
                                    <c:choose> 
                                        <c:when test="${buchung.klasse=='4'}"><c:set var="klasse" value="Economy Class"/></c:when>
                                        <c:when test="${buchung.klasse=='3'}"><c:set var="klasse" value="Economy Plus"/></c:when>
                                        <c:when test="${buchung.klasse=='2'}"><c:set var="klasse" value="Business Class"/></c:when>
                                        <c:otherwise><c:set var="klasse" value="First Class"/></c:otherwise>
                                   </c:choose>
                                 
                                 
                                 <tr><td>${buchung.FlugNr}</td><td>${buchung.abflugplanet}</td><td>${buchung.zielplanet}</td><td>${buchung.abflugzeit}</td><td>${buchung.ankuftszeit}</td><td>${buchung.Vorname}</td><td>${buchung.nachname}</td><td>${klasse}</td></tr>
                                </c:forEach>
                            </table>
                        </c:if>
                            
                            
                            
                    
                </div>
            </body>
</html>
