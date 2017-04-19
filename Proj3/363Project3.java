import java.io.File;
import java.io.PrintWriter;
import java.sql.*;

public class P3
{
	public static void main(String[] args) throws Exception {
		// Load and register a JDBC driver
		try {
			// Load the driver (registers itself)
			Class.forName("com.mysql.jdbc.Driver");
		} catch (Exception E) {
			System.err.println("Unable to load driver.");
			E.printStackTrace();
		}
		try {
			// Connect to the database
			Connection conn1;
			String dbUrl = "jdbc:mysql://csdb.cs.iastate.edu:3306/db363matthewv";
			String user = "dbu363matthewv";
			String password = "pobBrccJ";
			conn1 = DriverManager.getConnection(dbUrl, user, password);
			System.out.println("*** Connected to the database ***");

			// Create Statement and ResultSet variables to use throughout the project
			Statement statement = conn1.createStatement();
			Statement updateStatement = conn1.createStatement();
			ResultSet rs;

			// Part A
			rs = statement.executeQuery("SELECT s.StudentID, GPA, CreditHours, CourseCode, Grade FROM Student s INNER JOIN Enrollment e ON s.StudentID = e.StudentID ORDER BY s.StudentID;");

			int StudentID;
			int CreditHours;
			String CourseCode;
			String Grade;
			double gpa;
			
			rs.next();
			do{
				int currStudentID = rs.getInt("s.StudentID");
				int newStudentID;
				int newCreditHours = 0;
				double totalGPAscore = 0;
				do{
					StudentID = rs.getInt("s.StudentID");	
					gpa = rs.getDouble("GPA");
					CreditHours = rs.getInt("CreditHours");
					CourseCode = rs.getString("CourseCode");
					Grade = rs.getString("Grade").trim();
					newCreditHours += 3;
					switch(Grade){
					case "A":
						totalGPAscore += 4.00;
						break;
					case "A-":
						totalGPAscore += 3.66;
						break;
					case "B+":
						totalGPAscore += 3.33;
						break;
					case "B":
						totalGPAscore += 3.00;
						break;
					case "B-":
						totalGPAscore += 2.66;
						break;
					case "C+":
						totalGPAscore += 2.33;
						break;
					case "C":
						totalGPAscore += 2.00;
						break;
					case "C-":
						totalGPAscore += 1.66;
						break;
					case "D+":
						totalGPAscore += 1.33;
						break;
					case "D":
						totalGPAscore += 1.00;
						break;
					default:
						System.out.println("Invalid Grade");
					}
					//debugging print statement
					//System.out.println(StudentID + " " + gpa + " " + CreditHours + " " + CourseCode + " " + Grade);
					if(rs.isLast() == false){
						rs.next();
						newStudentID = rs.getInt("s.StudentID");
					}
					else{
						break;
					}
				}while(newStudentID == currStudentID);
				//debugging print statement
				//System.out.println(rs.getRow() + " " + newCreditHours + " " + totalGPAscore);
			
				String newClassification;
				if(CreditHours + newCreditHours >= 90){
					newClassification = "Senior";
				}else if(CreditHours + newCreditHours >= 60){
					newClassification = "Junior";
				}else if(CreditHours + newCreditHours >= 30){
					newClassification = "Sophomore";
				}else{
					newClassification = "Freshman";
				}
				double newGPA = (gpa*CreditHours + 3*totalGPAscore)/(CreditHours + newCreditHours);
				newGPA = Math.round(newGPA*100)/100.0;
				String query = "UPDATE Student SET GPA = " + newGPA + ",";
				int updatedCreditHours = CreditHours + newCreditHours;
				query += "CreditHours = " + updatedCreditHours + ",";
				query += "Classification = '" + newClassification + "'";
				query += "WHERE StudentID=" + currStudentID +";";
				//debugging print statement
				//System.out.println(query);	
				updateStatement.executeUpdate(query);
				
			}while(rs.isLast() == false);
			
			//Part B
			String query = "SELECT Name, MentorName, GPA ";
			query += "FROM Student S INNER JOIN Person pp ON pp.ID = S.StudentID ";
			query += "INNER JOIN (SELECT P.Name AS MentorName, I.InstructorID FROM ";
			query += "Person P INNER JOIN Instructor I ON P.ID = I.InstructorID ";
			query += "WHERE I.InstructorID IN (SELECT MentorID FROM Student ";
			query += "WHERE classification = 'Senior')) AS Mentors ";
			query += "ON S.MentorID = InstructorID ";
			query += "WHERE Classification = 'Senior' ";
			query += "ORDER BY GPA desc;";
			//debugging print statement
			//System.out.println(query);
			
			File file = new File("/Users/derf/P3Output.txt");
			PrintWriter ps = new PrintWriter(file);
			rs = statement.executeQuery(query);
			double cutoffGPA = 4.0;
			if(rs.isBeforeFirst()){
				for(int i=0; i<5; i++){
					rs.next();
					String name = rs.getString("Name");
					String mentorName = rs.getString("MentorName");
					double seniorGPA = rs.getDouble("GPA");
					cutoffGPA = seniorGPA;
					ps.println(name + ", " + mentorName + ", " + seniorGPA);
					//debugging statement
					//System.out.println(name + ", " + mentorName + ", " + seniorGPA);
				}
				//debugging print statement
				//System.out.println(cutoffGPA);
				rs.next();
				double nextGPA = rs.getDouble("GPA");
				while(nextGPA == cutoffGPA){
					String name = rs.getString("Name");
					String mentorName = rs.getString("MentorName");
					double seniorGPA = rs.getDouble("GPA");
					ps.println(name + ", " + mentorName + ", " + seniorGPA);
					//debugging print statement
					//System.out.println(name + ", " + mentorName + ", " + seniorGPA);
					rs.next();
					nextGPA = rs.getDouble("GPA");
				}
			}
			
			// Close all statements and connections
			ps.close();
			conn1.close();

		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
			System.out.println("SQLState: " + e.getSQLState());
			System.out.println("VendorError: " + e.getErrorCode());
		}
	}

}