

import java.io.IOException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CreateQuestion
 */
@WebServlet("/CreateQuestion")
public class CreateQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateQuestion() {
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
			String exam_id = request.getParameter("exam_id");
			String total_marks = request.getParameter("total_marks");
			String ques_name = request.getParameter("ques_name");
			String quesImg = request.getParameter("QuesImg");
			String solImg = request.getParameter("SolImg");
			System.out.println(quesImg);
			System.out.println(solImg);

			byte[] QuesBytes = quesImg.getBytes();
			byte[] SolBytes = solImg.getBytes();

			ques_name = "Q" +  ques_name ;
			
			String query = "insert into question (question_name,exam_id,total_marks,question_img,solution_img) "
					+       "values (?,?,?,?,?)";
			
			String json = DbHelper.executeUpdateJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING, 
							DbHelper.ParamType.INT, 
							DbHelper.ParamType.INT,
							DbHelper.ParamType.BYTEA,
							DbHelper.ParamType.BYTEA}, 
					new Object[] {ques_name , Integer.valueOf(exam_id), Integer.valueOf(total_marks),QuesBytes,SolBytes});
			
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
