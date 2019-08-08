

import java.io.IOException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UpdateQuiz
 */
@WebServlet("/UpdateQuiz")
public class UpdateQuiz extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateQuiz() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("null")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub	   
		   HttpSession session = request.getSession();
			if(session.getAttribute("id") == null) { //not logged in
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				return;
			}
			
			String instr_id = (String) session.getAttribute("id");
			ArrayList<DbHelper.ParamType> myParams = new ArrayList<DbHelper.ParamType>();
			ArrayList<Object> myObj = new ArrayList<Object>();
			String query = "Update exam set ";
			
			String quiz_id = request.getParameter("quiz_id");
			
			try {
				String exam_name = request.getParameter("exam_name");
				if(exam_name != null || !exam_name.isEmpty()) {
					myParams.add(DbHelper.ParamType.STRING);
					myObj.add(exam_name);
					query += " exam_name = ? ";
				}
			}catch(Exception e) {
			}
			try {
			String weightage = request.getParameter("weightage");
			if(weightage != null || !weightage.isEmpty()) {
				myParams.add(DbHelper.ParamType.INT);
				myObj.add(Integer.valueOf(weightage));
				query += " weightage = ? ";

			}
			}catch(Exception e) {
			}
			try {
		
			String total_marks = request.getParameter("total_marks");
			if(total_marks != null || !total_marks.isEmpty()) {
				myParams.add(DbHelper.ParamType.INT);
				myObj.add(Integer.valueOf(total_marks));
				query += " total_marks = ? ";

			}}
			catch(Exception e) {
			}
			try {
			String date = request.getParameter("date");
			if(date != null || !date.isEmpty()) {
				
				SimpleDateFormat sm = new SimpleDateFormat("dd/MM/yyyy");
				SimpleDateFormat old = new SimpleDateFormat("yyyy-MM-dd");
				ParsePosition pos = new ParsePosition(0);
				
				String strDate = "";
				java.util.Date original = old.parse(date,pos);
				strDate = sm.format(original);

				myParams.add(DbHelper.ParamType.STRING);
				myObj.add(strDate);
				query += " date = to_date(?, 'DD-MM-YYYY') ";

			}}catch(Exception e) {
			}
			try {
			
			String start_time = request.getParameter("start_time");
			if(start_time != null || !start_time.isEmpty()) {
				start_time = start_time + ":00";
				myParams.add(DbHelper.ParamType.STRING);
				myObj.add(start_time);
				query += " start_time = to_timestamp(?,'HH24:MI:SS') ";
			}}
			catch(Exception e) {
			}
			try {
			String end_time = request.getParameter("end_time");
			if(end_time != null || !end_time.isEmpty()) {
				end_time = end_time + ":00";
				myParams.add(DbHelper.ParamType.STRING);
				myObj.add(end_time);
				query += " end_time = to_timestamp(?,'HH24:MI:SS') ";

			}}
			catch(Exception e) {
			}
			try {
			String upload_end_time = request.getParameter("upload_end_time");
			if(upload_end_time != null || !upload_end_time.isEmpty()) {
				upload_end_time = upload_end_time + ":00";
				myParams.add(DbHelper.ParamType.STRING);
				myObj.add(upload_end_time);
				query += " upload_end_time = to_timestamp(?,'HH24:MI:SS') ";
			}
			}catch(Exception e) {
			}			
			myParams.add(DbHelper.ParamType.INT);
			myObj.add(Integer.valueOf(quiz_id));
			query += " where exam_id = ?;" ;
			DbHelper.ParamType[] params = new DbHelper.ParamType[] {};
			myParams.toArray(params);
			
			System.out.println(myParams);
			System.out.println(myObj);

			Object[] obj = new Object[]{};
			myObj.toArray(obj);
			
			System.out.println(query);
			String json = DbHelper.executeUpdateJson(query, params,obj);
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
