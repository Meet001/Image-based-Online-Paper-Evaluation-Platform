

import java.io.IOException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuesDetails
 */
@WebServlet("/StudentAvailableQues")
public class StudentAvailableQues extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentAvailableQues() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		   Calendar c = Calendar.getInstance();
		   int year=c.get(Calendar.YEAR);
		   String semester=Config.getSemester();

		   System.out.println(year);
		   System.out.println(semester);
		   
		   HttpSession session = request.getSession();
			if(session.getAttribute("stu_id") == null) { //not logged in
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				return;
			}
			
			String stu_id = (String) session.getAttribute("stu_id");
			
			System.out.println(stu_id);
			String exam_id = request.getParameter("exam_id");
			//String question_id = request.getParameter("question_id");
			

			String query = "select q.question_id,q.question_name,q.total_marks" + 
					" from question as q " + 
					"where q.exam_id = ?;";
			
			String json = DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.INT, 
							}, 
					new Object[] {Integer.valueOf(exam_id)});
			
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
