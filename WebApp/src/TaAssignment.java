

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class TaAssignment
 */
@WebServlet("/TaAssignment")
public class TaAssignment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TaAssignment() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		   HttpSession session = request.getSession();
					if(session.getAttribute("id") == null) { //not logged in
						response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
						return;
					}
					
					//String instr_id = (String) session.getAttribute("id");
					String checker_id = request.getParameter("checker_id");
					String question_id = request.getParameter("question_id");
					

					String query = "insert into assignment (question_id,checker_id) values (?,?)";
					
					String json = DbHelper.executeUpdateJson(query, 
							new DbHelper.ParamType[] {
									DbHelper.ParamType.STRING, 
									DbHelper.ParamType.STRING
									}, 
							new String[] {checker_id,question_id});
					
					response.getWriter().print(json);
						
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
