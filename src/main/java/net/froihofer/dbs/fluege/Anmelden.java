package net.froihofer.dbs.fluege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.InitialContext;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class Anmelden extends HttpServlet {
  public static final String ERROR_MSG_PARAM = "ANMELDUNG_FEHLERMELDUNG";
  private static final Logger log = LoggerFactory.getLogger(Anmelden.class);

  private EntityManagerFactory emf;
  
  @Override
  public void init() throws ServletException {
    super.init();
    emf = Persistence.createEntityManagerFactory("dbs-fluege");
  }
  
  @Override
  protected void doPost (HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
      
        Connection con = null;
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();
       
        String mBenutzername= request.getParameter("benutzername");
        String mPasswort=request.getParameter("passwort");
        
        try {
            if(mBenutzername!=null){
                
                InitialContext ctx = new InitialContext();
                DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
                con = ds.getConnection();
                String Query= "select * from person where svnr=? and passwort=?";
                PreparedStatement psm=con.prepareStatement(Query);
                psm.setString(1, mBenutzername);
                psm.setString(2, mPasswort);
                ResultSet rs=psm.executeQuery();
                
                if(rs.next()){
                    Cookie cookie = new Cookie("SVNR", mBenutzername);
                    response.addCookie(cookie);
                    response.sendRedirect("meineFluege.jsp");
                }
                else{
                        log.error("Konto existiert nicht");
                        request.setAttribute(ERROR_MSG_PARAM,"SVNr oder Passwort falsch");

                    }
                }
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        
        catch (Exception ex){
            pw.println("Exception :"+ex.getMessage());  
        }
    }
}
        
       
