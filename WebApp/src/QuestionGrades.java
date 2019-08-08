

import java.io.IOException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuestionGrades
 */
@WebServlet("/QuestionGrades")
public class QuestionGrades extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QuestionGrades() {
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
			
			String question_id = request.getParameter("question_id");
			

			String query = "select s.id, s.name, e.marks from evaluation as "
					+ "e,student as s where question_id = ? and s.id = e.student_id;";
			String json = DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.INT}, 
					new Object[] {Integer.valueOf(question_id)});
			System.out.println(json);
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
