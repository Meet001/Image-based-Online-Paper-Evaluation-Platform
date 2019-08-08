

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
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
 * Servlet implementation class CreateQuiz
 */
@WebServlet("/CreateQuiz")
public class CreateQuiz extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateQuiz() {
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
		   String semester=Config.getSemester();

		   System.out.println(year);
		   System.out.println(semester);
		   
		   HttpSession session = request.getSession();
			if(session.getAttribute("id") == null) { //not logged in
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				return;
			}
			
			String instr_id = (String) session.getAttribute("id");
			String course_id = request.getParameter("course_id");
			String exam_name = request.getParameter("exam_name");
			String weightage = request.getParameter("weightage");
			String total_marks = request.getParameter("total_marks");
			String date = request.getParameter("date");
			String start_time = request.getParameter("start_time");
			String end_time = request.getParameter("end_time");
			String upload_end_time = request.getParameter("upload_end_time");
			SimpleDateFormat sm = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat old = new SimpleDateFormat("yyyy-MM-dd");
			ParsePosition pos = new ParsePosition(0);
			
			String strDate = "";
				java.util.Date original = old.parse(date,pos);
				strDate = sm.format(original);
				System.out.println("in lala land");
				System.out.println(strDate);
			
			start_time = start_time + ":00";
			end_time = end_time + ":00";
			upload_end_time = upload_end_time + ":00";
			
			System.out.println(end_time);
			System.out.println(upload_end_time);

			
			String getSection = "select sec_id from teaches where id = ? and course_id = ? and semester = ? and year = ?";
			
			List<List<Object>> res = DbHelper.executeQueryList(getSection, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.INT}, 
					new Object[] {instr_id,course_id,semester,year});
			
			String sec_id = "";
			if(!res.isEmpty()) {
				sec_id = (String)res.get(0).get(0);
			}
			
			String query = "insert into exam (course_id,sec_id,semester, year, exam_name, weightage, total_marks,exam_date, start_time, end_time, upload_end_time) "
					+       "values (?,?,?,?,?,?,?,to_date(?, 'DD-MM-YYYY'),to_timestamp(?,'HH24:MI:SS'),to_timestamp(?,'HH24:MI:SS'),to_timestamp(?,'HH24:MI:SS'))";
			
			String json = DbHelper.executeUpdateJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.INT,
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.INT,
							DbHelper.ParamType.INT,
							DbHelper.ParamType.STRING,							
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.STRING,
							DbHelper.ParamType.STRING}, 
					new Object[] {course_id,sec_id,semester,year,exam_name, Integer.valueOf(weightage), Integer.valueOf(total_marks),strDate, start_time, end_time, upload_end_time});
			
			
			response.getWriter().print(json);	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
