

import java.io.IOException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AssignTA
 */
@WebServlet("/AssignTA")
public class AssignTA extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AssignTA() {
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
			
			String instr_id = (String) session.getAttribute("id");
			String ta_id = request.getParameter("id");
			String question_id = request.getParameter("question_id");
			
			String query = "insert into assignment (checker_id,question_id) values (?,?)";
			
			String json = DbHelper.executeUpdateJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.INT}, 
					new Object[] {ta_id,Integer.valueOf(question_id)});
			
			
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
