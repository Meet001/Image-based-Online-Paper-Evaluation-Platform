

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class InsertMarks
 */
@WebServlet("/InsertMarks")
public class InsertMarks extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertMarks() {
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
			String stu_id = request.getParameter("id");
			String marks = request.getParameter("marks");
			String question_id = request.getParameter("question_id");
			String comment = request.getParameter("comment");
		
			String query = "insert into evaluation (checker_id,question_id,student_id,marks,comment) "
					+       "values (?,?,?,?,?)";
			
			String json = DbHelper.executeUpdateJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.INT, 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.DOUBLE,
							DbHelper.ParamType.STRING}, 
					new Object[] {instr_id , Integer.valueOf(question_id), stu_id , Double.valueOf(marks) ,comment});
			
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
