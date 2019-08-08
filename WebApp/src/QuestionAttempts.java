

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuestionAttempts
 */
@WebServlet("/QuestionAttempts")
public class QuestionAttempts extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QuestionAttempts() {
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
		String question_id = request.getParameter("question_id");
		
			
		String query = "select e.course_id from question as q,exam as e where "
				+ "q.exam_id = e.exam_id and q.question_id = ?";
		
		List<List<Object>> res = DbHelper.executeQueryList(query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.INT}, 
				new Object[] {Integer.valueOf(question_id)});
		
		System.out.println("res is" + res.toString());
		String course_id = res.isEmpty()? null : (String)res.get(0).get(0);
		
		String query2 = "select s.id,s.name "
				
				+ "from student as s,takes as t where t.id = s.id and t.course_id = ?";
		
		String json = DbHelper.executeQueryJson(query2, 
				new DbHelper.ParamType[] {
						DbHelper.ParamType.STRING}, 
				new Object[] {course_id});
		
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
