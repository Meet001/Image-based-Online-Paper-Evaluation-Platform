

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuizGrades
 */
@WebServlet("/QuizGrades")
public class QuizGrades extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QuizGrades() {
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
			
			String exam_id = request.getParameter("exam_id");
			

			String query = "select s.id,s.name,sum(e.marks) as marks from evaluation as e, exam as ex, student as s,question as q where e.student_id = s.id and \r\n" + 
					"ex.exam_id = q.exam_id and q.question_id = e.question_id and ex.exam_id = ? group by s.id,s.name; ";
			String json = DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.INT}, 
					new Object[] {Integer.valueOf(exam_id)});
			System.out.println(json);
			response.getWriter().print(json);		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
