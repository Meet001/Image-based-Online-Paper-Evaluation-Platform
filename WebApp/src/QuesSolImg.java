

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class QuesSolImg
 */
@WebServlet("/QuesSolImg")
public class QuesSolImg extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QuesSolImg() {
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
				
				System.out.println(question_id);

				String query = "select * from question where question_id = ?";
			
				
				String res = DbHelper.executeQueryJson(query, 
						new DbHelper.ParamType[] {
								DbHelper.ParamType.INT
								}, 
						new Object[] {Integer.valueOf(question_id)});
				
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
