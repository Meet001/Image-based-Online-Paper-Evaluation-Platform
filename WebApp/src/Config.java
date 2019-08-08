import java.util.Calendar;

/**
 * Edit to provide your database credentials
 */
public class Config {
	public static final String url = "jdbc:postgresql://localhost:5010/postgres";
	public static final String user = "postgres";
	public static final String password = "rutul@2005";
	
	public static String getSemester() {
	    	Calendar c = Calendar.getInstance();
			int month=c.get(Calendar.MONTH);
			String fall = "Fall";
			String spring = "Spring";
			String winter = "Winter";
			String summer = "Summer";
			if(month >=0 && month <= 3) {
				return spring;
			}
			else if(month >=4 && month <= 5) {
				return summer;
			}
			else if(month >=6 && month <= 10) {
				return fall;
			}
			else{
				return winter;
			}
	    }

}
