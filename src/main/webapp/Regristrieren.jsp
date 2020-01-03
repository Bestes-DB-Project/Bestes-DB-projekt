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
    <title>Passagier anmelden</title>
  </head>
  <body>
      <div class="Headline">
            <h3>Raumschiffgesellschafts Portal Futurama</h3>
        </div>
      
      <div class="Main">
          <h1>Neuer Passagier</h1>
    <% if (request.getAttribute(PersonRegristrieren.ERROR_MSG_PARAM) != null) { %>
            <p style="color: red"><%=request.getAttribute(PersonRegristrieren.ERROR_MSG_PARAM)%></p>
        <% } %>
        <% if (request.getAttribute(PersonRegristrieren.SUCCESS_MSG_PARAM) != null) { %>
            <p style="color: blue"><%=request.getAttribute(PersonRegristrieren.SUCCESS_MSG_PARAM)%></p>
        <% } %>
    <form method="POST" action="${contextPath}/PersonRegristrieren" style="display: inline-block">
      <table>
        <tr><td>SVNr:</td><td><input type="integer" name="svnr" value="${param.svnr}"/></td></tr>
        <tr><td>Vorname:</td><td><input type="text" name="vorname" value="${param.fvorname}"/></td></tr>
        <tr><td>Nachname:</td><td><input type="text" name="nachname" value="${param.nachname}"/></td></tr>
        <tr><td>PLZ:</td><td><input type="integer" name="plz" value="${param.plz}"/></td></tr>
        <tr><td>Ort:</td><td><input type="text" name="ort" value="${param.ort}"/></td></tr>
        <tr><td>Straße:</td><td><input type="text" name="strasse" value="${param.strasse}"/></td></tr>
        <tr><td>Hausnummer:</td><td><input type="text" name="hausnummer" value="${param.hausnummer}"/></td></tr>
        <tr><td>Telefonnummer1:</td><td><input type="integer" name="telefonnummer1" value="${param.telefonnummer1}"/></td></tr>
        <tr><td>Telefonnummer2:</td><td><input type="integer" name="telefonnummer2" value="${param.telefonnummer2}"/></td></tr>
        <tr><td>Telefonnummer3:</td><td><input type="integer" name="telefonnummer3" value="${param.telefonnummer3}"/></td></tr>
        <tr><td>Telefonnummer4:</td><td><input type="integer" name="telefonnummer4" value="${param.telefonnummer4}"/></td></tr>
        <tr><td>Telefonnummer5:</td><td><input type="integer" name="telefonnummer5" value="${param.telefonnummer5}"/></td></tr>
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
