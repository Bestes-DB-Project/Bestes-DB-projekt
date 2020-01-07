<%-- 
    Document   : Regristrieren
    Created on : 02.01.2020, 15:16:56
    Author     : joseph
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="net.froihofer.dbs.fluege.PersonRegristrieren" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="${contextPath}/css/main.css" />
    <title>Futurama</title>
  </head>
  <body>
      <div class="Headline">
            <h3>Neue Person</h3>
        </div>
      
      <div class="Main">
    <% if (request.getAttribute(PersonRegristrieren.ERROR_MSG_PARAM) != null) { %>
            <p style="color: red"><%=request.getAttribute(PersonRegristrieren.ERROR_MSG_PARAM)%></p>
        <% } %>
        <% if (request.getAttribute(PersonRegristrieren.SUCCESS_MSG_PARAM) != null) { %>
            <p style="color: blue"><%=request.getAttribute(PersonRegristrieren.SUCCESS_MSG_PARAM)%></p>
        <% } %>
        
    <c:set var="Amount" value="${param.Amount}" scope = "page"/>
    <c:if test="${empty Amount}">
        <c:set var="Amount" value="0" scope = "page" />
    </c:if>
        
    <form method="POST" action="${contextPath}/PersonRegristrieren" style="display: inline-block">
      <table>
        <tr><td>SVNr:</td><td><input type="number" min="1000000000" max ="9999999999" name="svnr" value="${param.svnr}" style="width:200px"  required/></td></tr>
        <tr><td>Vorname:</td><td><input type="text" name="vorname" value="${param.vorname}" style="width:200px" required/></td></tr>
        <tr><td>Nachname:</td><td><input type="text" name="nachname" value="${param.nachname}" style="width:200px"  required/></td></tr>
        <tr><td>PLZ:</td><td><input type="number" min="1000" max ="99999" name="plz" value="${param.plz}" style="width:200px" required/></td></tr>
        <tr><td>Ort:</td><td><input type="text" name="ort" value="${param.ort}" style="width:200px" required/></td></tr>
        <tr><td>Straße:</td><td><input type="text" name="strasse" value="${param.strasse}" style="width:200px" required/></td></tr>
        <tr><td>Hausnummer:</td><td><input type="text" name="hausnummer" value="${param.hausnummer}" style="width:200px" required/></td></tr>
        <tr><td>Passwort:</td><td><input type="password" name="passwort" value="${param.passwort}" style="width:200px" required/></td></tr>
        <tr><td>
            Telefonnummer:</td><td><input type="number"  name="telefonnummer" value="${param.telefonnummer}" style="width:200px"  required/>
            <button class="btn btn-primary" formmethod="post" formaction="${contextPath}/Regristrieren.jsp" name="Amount" value="${Amount+1}"> + </button>
            <c:if test="${Amount > 0}">
                <button class="btn btn-primary" formmethod="post" formaction="${contextPath}/Regristrieren.jsp" name="Amount" value="${Amount-1}"> - </button>
            </c:if> 
            
        </td></tr>

        
        <c:forEach var="i" begin="1" end="${Amount}" >
             <tr><td>Telefonnummer:</td><td><input type="number" name="telefonnummer" value="${param.telefonnummer}" style="width:200px" required/></td></tr>       
        </c:forEach>
        
        <%--<tr><td style="padding-top: 5px">JPA verwenden?</td><td style="padding-top: 5px"><input type="checkbox" name="useJpa" <%= request.getParameter("useJpa") != null ? "checked=\"true\"" : ""%>/></td></tr>
      --%>
      </table>
      
      <div style="float: right; margin-top: 10px">
      <a href="${contextPath}/index.jsp" class="btn btn-secondary">Abbrechen</a>
      <button class="btn btn-primary" style="margin-left: 10px">Regristrieren</button>
      </div>
    </form>
      </div>
   
  </body>
</html>
