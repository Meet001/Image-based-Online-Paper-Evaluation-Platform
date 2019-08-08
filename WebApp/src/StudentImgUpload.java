import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;


/**
 * Servlet implementation class CreateQuestion
 */
@WebServlet("/StudentImgUpload")
public class StudentImgUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentImgUpload() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		System.out.println("34");

		   HttpSession session = request.getSession();
		   
		   System.out.println("38");

			//System.out.println(student_id);			

			if(session.getAttribute("stu_id") == null) { //not logged in
				
				System.out.println("42");
				response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
				//return;
			}
			
		
			String student_id = (String) session.getAttribute("stu_id");
			System.out.println(student_id);			
			//String exam_id = request.getParameter("exam_id");
			//String total_marks = request.getParameter("total_marks");
			String ques_id = (String) request.getParameter("ques_id");
			System.out.println(ques_id);			
			//String quesImg = request.getParameter("QuesImg");
			String solImg = (String) request.getParameter("SubmissionImg");
			
//			System.out.println(quesImg);
//			System.out.println(solImg);
			
			byte[] SolBytes = solImg.getBytes();
			
//			String body = request.getReader().lines().collect(Collectors.joining());
//			
//			
//			Part filePart = request.getPart("file");
//			
//			
//			
//			InputStream filecontent = filePart.getInputStream();
//			 byte[] SolBytes = new byte[(int)filePart.getSize()];
//			 
//			 String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//			 
//			 filecontent.read(SolBytes);
//			 
//			 System.out.println(fileName);			 
//			 String base64 = new String(SolBytes);
//			 System.out.println(base64);
			 
			//ques_name = "Q" +  ques_name ;
			
			String query = "insert into submission (student_id,question_id,image) "
					+       "values (?,?,?)";
			
			String json = DbHelper.executeUpdateJson(query, 
					new DbHelper.ParamType[] {
							DbHelper.ParamType.STRING,  
							DbHelper.ParamType.INT,
							DbHelper.ParamType.BYTEA}, 
					new Object[] {student_id, Integer.valueOf(ques_id),SolBytes});
			
			response.getWriter().print(json);	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}