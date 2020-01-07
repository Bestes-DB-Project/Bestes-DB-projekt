<%-- 
    Document   : Anmelden
    Created on : 03.01.2020, 15:26:08
    Author     : JayJay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="net.froihofer.dbs.fluege.Anmelden" %>
                <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
                "http://www.w3.org/TR/html4/loose.dtd">
                <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

                <html>
                    <head>
                        <c:set var="contextPath" value="/dbs-fluege"/>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <link rel="stylesheet" href="/dbs-fluege/css/main.css" />
                    <title>Futurama</title>
                    </head>
                    
                    <body>

                        <div class="Headline">
                            <h3>Anmelden</h3>
                            <a href="index.jsp"></a>
                        </div>

                        <div class="Main">
                                <% if (request.getAttribute(Anmelden.ERROR_MSG_PARAM) != null) { %>
                                     <p style="color: red"><%=request.getAttribute(Anmelden.ERROR_MSG_PARAM)%></p>
                                <% } %>

                            <form method="POST" action="${contextPath}/Anmelden">
            <table>
                  <tr><td>SVNr:</td><td><input name="benutzername" placeholder="SVNr" type="number" value="${param.benutzername}" required></td></tr>
                  <tr><td>Passwort:</td><td><input name="passwort" placeholder="Passwort" type="password" value="${param.passwort}" required></td></tr>   
            </table>
                  <p></p>
                  <a href="${contextPath}/Regristrieren.jsp" style="margin-left:120px">Registrieren </a>
                  <button class="btn btn-primary" style="margin-left: 10px">Anmelden</button> 
        </form>        
                        </div>
                    </body>
                </html>
