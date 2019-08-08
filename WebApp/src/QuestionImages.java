

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuestionImages
 */
@WebServlet("/QuestionImages")
public class QuestionImages extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QuestionImages() {
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
				
				String stu_id = (String) request.getParameter("stu_id");
				String question_id = request.getParameter("question_id");
				System.out.println(stu_id);
				System.out.println(question_id);

				String query = "select image_num,image from submission where student_id = ? and question_id = ? order by image_num";
				
				String res = DbHelper.executeQueryJson(query, 
						new DbHelper.ParamType[] {
								DbHelper.ParamType.STRING, 
								DbHelper.ParamType.INT
								}, 
						new Object[] {stu_id , Integer.valueOf(question_id)});
				System.out.println(res);
				response.getWriter().print(res);	
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
