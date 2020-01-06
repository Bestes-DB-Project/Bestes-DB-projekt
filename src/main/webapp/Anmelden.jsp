<%-- 
    Document   : Anmelden
    Created on : 03.01.2020, 15:26:08
    Author     : JayJay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                            <a href="Anmelden.jsp"></a>
                        </div>

                        <div class="Main">                
                            <form method="GET" action="${contextPath}/Anmelden">
            <table>
                  <tr><td>Benutzername:</td><td><input name="benutzername" placeholder="Benutzername" type="text" value="${param.benutzername}" required></td></tr>
                  <tr><td>Passwort:</td><td><input name="passwort" placeholder="Passwort" type="text" value="${param.passwort}" required></td></tr>   
            </table>
                  <p></p>
                  <a href="${contextPath}/Registrieren.jsp" style="margin-left:120px">Registrieren </a>
                  <button class="btn btn-primary" style="margin-left: 10px">Anmelden</button> 
        </form>        
                        </div>
                    </body>
                </html>
