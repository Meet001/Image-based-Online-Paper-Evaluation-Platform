

import java.io.IOException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CourseGrades
 */
@WebServlet("/CourseGrades")
public class CourseGrades extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CourseGrades() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   Calendar c = Calendar.getInstance();
		   int year=c.get(Calendar.YEAR);
		   String semester=Config.getSemester();

		
		   
		   HttpSession session = request.getSession();
			if(session.getAttribute("id") == null) { //not logged in
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				return;
			}
			
			//String instr_id = (String) session.getAttribute("id");
			String course_id = request.getParameter("course_id");
			

			String query = "with exam_marks(marks,id,tm,wight,ex_id) as\r\n" + 
					"(select sum(marks),student_id,ex.total_marks,ex.weightage,ex.exam_id from evaluation as e,question as q,exam as ex,section as s\r\n" + 
					"where ex.exam_id = q.exam_id and e.question_id = q.question_id and ex.course_id = s.course_id and s.course_id = ? and s.semester = ? and s.year = ? group by student_id,ex.exam_id,ex.total_marks,ex.weightage)\r\n" + 
					"select s.id,s.name,round(sum(e.marks*wight/tm),2) as marks from exam_marks as e,student as s where e.id = s.id group by s.id,s.name;";
			
			String json = DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.INT}, 
					new Object[] {course_id,semester,year});
			
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
