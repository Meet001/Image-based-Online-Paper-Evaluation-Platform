

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Date;
import java.text.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CourseQuizes
 */
@WebServlet("/StudentAvailableQuiz")
public class StudentAvailableQuiz extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentAvailableQuiz() {
        super();
        // TODO Auto-generated constructor stub
    } 

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		   Calendar c = Calendar.getInstance();
		   int year=c.get(Calendar.YEAR);
		   SimpleDateFormat ftD = new SimpleDateFormat("yyyy-MM-dd");
		   SimpleDateFormat ftT = new SimpleDateFormat("HH:mm:ss");
		   Date curr_date= new Date();
		   String semester=Config.getSemester();
		   
		   String myTime = ftT.format(curr_date);
		   String myDate = ftD.format(curr_date);
		   
		   System.out.println(myDate);
		   System.out.println(myTime);

		   
		   HttpSession session = request.getSession();
			if(session.getAttribute("stu_id") == null) { //not logged in
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				return;
			}
			
			//String instr_id = (String) session.getAttribute("id");
			String course_id = request.getParameter("course_id");
			

			String query = "select * " 
					+ "from exam where course_id = ? and semester = ? and year = ? "
					+ "and exam_date = TO_DATE(?,'yyyy-MM-dd') and start_time < \'"+ myTime 
					+ "\' and upload_end_time > \'"+ myTime + "\';";
			
			System.out.println(query);
			String json = DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.INT,
							DbHelper.ParamType.STRING
							}, 
					new Object[] {course_id,semester,year,myDate});
			
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
