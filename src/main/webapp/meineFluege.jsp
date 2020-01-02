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
                        <sql:setDataSource dataSource="jdbc/FluegeDB" />   
                        <sql:query var="flug" sql="SELECT * FROM Flug" />
                        <%-- <sql:query var="flug" sql="SELECT * FROM Flug WHERE FlugNr IN (SELECT FlugNr FROM BUCHT WHERE SVNr = 123)" /> --%>  
                        
                        
                        
                        
                        
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
