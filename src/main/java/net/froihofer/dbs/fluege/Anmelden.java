package net.froihofer.dbs.fluege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.List;
import javax.naming.InitialContext;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import net.froihofer.dbs.weine.entities.Erzeuger;
import net.froihofer.dbs.fluege.entities.Person;
import net.froihofer.dbs.weine.entities.Wein;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Lorenz Froihofer
 * @version $Id: NeuerWein.java 1:3d18a343f773 2012/12/02 01:44:16 Lorenz Froihofer $
 */
public class Anmelden extends HttpServlet {

  private static final Logger log = LoggerFactory.getLogger(Anmelden.class);

  private EntityManagerFactory emf;
  
  @Override
  public void init() throws ServletException {
    super.init();
    emf = Persistence.createEntityManagerFactory("dbs-fluege");
  }
  
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
      
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
                /*
                Class.forName("com.mysql-jdbc.Driver").newInstance();
                Connection conn= DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/dbname", "username", "pw");
                */
                String Query= "select * from person where vorname=? and nachname=?";
                PreparedStatement psm=con.prepareStatement(Query);
                psm.setString(1, mBenutzername);
                psm.setString(2, mPasswort);
                ResultSet rs=psm.executeQuery();

                if(rs.next()){
                
                
                
                
                Statement statement = con.createStatement();
                ResultSet res = statement.executeQuery("select SVNR from person where Nachname = '"+mPasswort+"'");
                if(res.next())
                {
                    /*SESSION
                    HttpSession session= request.getSession();
                    session.setAttribute("SVNR", res.getString(1)+"");
                    */
                    
                    Cookie cookie=new Cookie("SVNR", res.getString(1)+""); //weil wir String brauchn aber svnr is int
                    response.addCookie(cookie);

                }
       
                
                response.sendRedirect("meineFluege.jsp"); //meineFluege

                }
                else{
                        pw.println("Konto exisitert nicht!");
                    }
                }
                request.getRequestDispatcher("/Anmelden.jsp").forward(request, response);
            }
        
        catch (Exception ex){
            pw.println("Exception :"+ex.getMessage());  
        }
    }
}
        
       
