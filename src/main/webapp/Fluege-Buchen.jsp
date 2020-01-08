<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="net.froihofer.dbs.fluege.FluegeBuchen" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>


<html>
    <head>
        <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${contextPath}/css/main.css" />
        <title>Futurama</title>
    </head>
    <body>
        <div class="Headline">
            <h3>Flüge Buchen</h3>
        </div>
        
        <% if (request.getAttribute(FluegeBuchen.ERROR_MSG_PARAM) != null) { %>
            <p style="color: red"><%=request.getAttribute(FluegeBuchen.ERROR_MSG_PARAM)%></p>
        <% } %>
        <% if (request.getAttribute(FluegeBuchen.SUCCESS_MSG_PARAM) != null) { %>
            <p style="color: blue"><%=request.getAttribute(FluegeBuchen.SUCCESS_MSG_PARAM)%></p>
        <% } %>

        <div class="Main">                
       
            <!-- Set Amount -->    
            <c:set var="Amount" value="${param.Amount}" scope = "page"/>
            <c:if test="${empty Amount}">
                <c:set var="Amount" value="1" scope = "page" />
            </c:if>

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
            <sql:query var="auftraggeber" sql="SELECT Vorname, Nachname From person WHERE SVNr = ?"> 
                <sql:param value="${svnr}" />
            </sql:query>    
            
            <c:forEach var="Person" items="${auftraggeber.rows}">
                <c:set var = "Vorname"  value = "${Person.Vorname}" scope = "page"/>
                <c:set var = "Nachname"  value = "${Person.Nachname}" scope = "page"/>
            </c:forEach>
        
            <form method="POST" action="${contextPath}/FluegeBuchen">
                <p>Anzahl der Tickets: ${Amount} &emsp;
                    <button class="btn btn-primary" formmethod="post" name="Amount" value="${Amount+1}" formnovalidate> + </button>
                    <c:if test="${Amount > 1}">
                        <button class="btn btn-primary" formmethod="post" name="Amount" value="${Amount-1}" formnovalidate> - </button>
                    </c:if>  
                </p>
                
                <input type="hidden" name="Userid" value="${svnr}"/>
                <input type="hidden" name="flugnr" value="${param.flugnr}"/>
                
                <c:forEach var="i" begin="0" end="${Amount-1}" >
                    <div class="BuchenForm">
                        <c:if test="${i == 0}">
                            <p>Vorname:  &emsp;&emsp;                       <input name="Vorname" type="text" value="${Vorname}" placeholder="Vornname" style="width:200px"  required/></p>
                            <p>Nachname: &emsp;&nbsp;                       <input name="Nachname" type="text" value="${Nachname}" placeholder="Nachname" style="width:200px"  required/></p>
                            <p>SVNR:     &emsp;&emsp;&emsp;&nbsp;&nbsp;     <input name="SVNr" type="number" value="${svnr}" placeholder="SVNR" min="1000000000" max="9999999999" style="width:200px"  required/></p>
                        </c:if>
                        <c:if test="${i > 0}">
                            <p>Vorname:  &emsp;&emsp;                       <input name="Vorname" type="text"  placeholder="Vornname" style="width:200px"  required/></p>
                            <p>Nachname: &emsp;&nbsp;                       <input name="Nachname" type="text"  placeholder="Nachname" style="width:200px"  required/></p>
                            <p>SVNR:     &emsp;&emsp;&emsp;&nbsp;&nbsp;     <input name="SVNr" type="number" placeholder="SVNR" min="1000000000" max="9999999999" style="width:200px"  required/></p>    
                        </c:if>    
                        <p>Klasse:     &emsp;&emsp;&emsp;&nbsp;&nbsp;     
                            <select name="Klasse">
                                <option value="4">Economy Class</option>
                                <option value="3">Economy Plus</option>
                                <option value="2">Business Class</option>
                                <option value="1">First Class</option>
                            </select>                         
                        </p>
                    </div>
                </c:forEach>
                <button class="btn btn-primary" formmethod="post" name="Submit" value="1">Buchen</button>  
                <input type="hidden" name="Amount" value="${Amount}">
            </form>
        </div>
    </body>
</html>