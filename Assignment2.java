import java.sql.*;

// Remember that part of your mark is for doing as much in SQL (not Java)
// as you can. At most you can justify using an array, or the more flexible
// ArrayList. Don't go crazy with it, though. You need it rarely if at all.
import java.util.ArrayList;

public class Assignment2 {

    // A connection to the database
    Connection connection;

    Assignment2() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Connects to the database and sets the search path.
     *
     * Establishes a connection to be used for this session, assigning it to the
     * instance variable 'connection'. In addition, sets the search path to
     * markus.
     *
     * @param url
     *            the url for the database
     * @param username
     *            the username to be used to connect to the database
     * @param password
     *            the password to be used to connect to the database
     * @return true if connecting is successful, false otherwise
     */
    public boolean connectDB(String URL, String username, String password) {
		try {

			connection = DriverManager.getConnection(URL, username, password);
			String q = "SET search_path to markus;";
			PreparedStatement pS = connection.prepareStatement(q);
			pS.executeUpdate();
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
        // Replace this return statement with an implementation of this method!
        return true;
    }

    /**
     * Closes the database connection.
     *
     * @return true if the closing was successful, false otherwise
     */
    public boolean disconnectDB() {
		try {
			connection.close();
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
        // Replace this return statement with an implementation of this method!
        return true;
    }

    /**
     * Assigns a grader for a group for an assignment.
     *
     * Returns false if the groupID does not exist in the AssignmentGroup table,
     * if some grader has already been assigned to the group, or if grader is
     * not either a TA or instructor.
     *
     * @param groupID
     *            id of the group
     * @param grader
     *            username of the grader
     * @return true if the operation was successful, false otherwise
     */
    public boolean assignGrader(int groupID, String grader) {
        // Replace this return statement with an implementation of this method!
        String q;
        ResultSet rs;
        PreparedStatement pS;
		try {
			
			q = "select group_id from AssignmentGroup";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			boolean valid = false;
			while(rs.next()){
			  if(rs.getInt("group_id")==groupID){
				valid = true;
				break;
			  }
			}
			if(!valid){
			  return false;
			}
			valid = false;
			q = "select username from MarkusUser where type = 'instructor' or type = 'TA'";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getString("username").equals(grader)){
				valid = true;
				break;
			  }
			}
			if(!valid){
			  return false;
			}
			
			//already in grader
			q = "select * from Grader";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getInt("group_id")==groupID && rs.getString("username").equals(grader)){
				return false;
			  }
			}
			//INSERT

			q = "insert into Grader VALUES (?, ?)";
			pS = connection.prepareStatement(q);
			pS.setInt(1,groupID);
			pS.setString(2,grader);
			pS.executeUpdate();
		} catch (SQLException ex) {
			ex.printStackTrace();
			return false;
		}
        return true;
    }

    /**
     * Adds a member to a group for an assignment.
     *
     * Records the fact that a new member is part of a group for an assignment.
     * Does nothing (but returns true) if the member is already declared to be
     * in the group.
     *
     * Does nothing and returns false if any of these conditions hold: - the
     * group is already at capacity, - newMember is not a valid username or is
     * not a student, - there is no assignment with this assignment ID, or - the
     * group ID has not been declared for the assignment.
     *
     * @param assignmentID
     *            id of the assignment
     * @param groupID
     *            id of the group to receive a new member
     * @param newMember
     *            username of the new member to be added to the group
     * @return true if the operation was successful, false otherwise
     */
    public boolean recordMember(int assignmentID, int groupID, String newMember) {
        // Replace this return statement with an implementation of this method!
        boolean valid = false;
        String q;
        ResultSet rs;
        PreparedStatement pS;
		
		try {
			//check member already in
			q = "select * from Membership";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getString("username").equals(newMember) && rs.getInt("group_id")==groupID){
				  
				return true;
			  }
			}
			//check memebr
			q = "select username from MarkusUser where type = 'student'";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getString("username").equals(newMember)){
				valid = true;
				break;
			  }
			}
			if(!valid){
			  return false;
			}
			valid = false;

			//check assignment and group
			q = "select assignment_id, group_id from"+
			" (Assignment natural join AssignmentGroup) natural full join Membership"+
			" group by group_id, assignment_id having count(username) < group_max;";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getInt("group_id")==groupID && rs.getInt("assignment_id")==assignmentID){
				valid = true;
				break;
			  }
			}
			if(!valid){
			  return false;
			}
			


			//INSERT
			q = "insert into Membership VALUES (?, ?)";
			pS = connection.prepareStatement(q);
			pS.setString(1,newMember);
			pS.setInt(2,groupID);
			pS.executeUpdate();
		} catch (SQLException ex) {
			ex.printStackTrace();
			return false;
		}

        return true;
    }

    /**
     * Creates student groups for an assignment.
     *
     * Finds all students who are defined in the Users table and puts each of
     * them into a group for the assignment. Suppose there are n. Each group
     * will be of the maximum size allowed for the assignment (call that k),
     * except for possibly one group of smaller size if n is not divisible by k.
     * Note that k may be as low as 1.
     *
     * The choice of which students to put together is based on their grades on
     * another assignment, as recorded in table Results. Starting from the
     * highest grade on that other assignment, the top k students go into one
     * group, then the next k students go into the next, and so on. The last n %
     * k students form a smaller group.
     *
     * In the extreme case that there are no students, does nothing and returns
     * true.
     *
     * Students with no grade recorded for the other assignment come at the
     * bottom of the list, after students who received zero. When there is a tie
     * for grade (or non-grade) on the other assignment, takes students in order
     * by username, using alphabetical order from A to Z.
     *
     * When a group is created, its group ID is generated automatically because
     * the group_id attribute of table AssignmentGroup is of type SERIAL. The
     * value of attribute repo is repoPrefix + "/group_" + group_id
     *
     * Does nothing and returns false if there is no assignment with ID
     * assignmentToGroup or no assignment with ID otherAssignment, or if any
     * group has already been defined for this assignment.
     *
     * @param assignmentToGroup
     *            the assignment ID of the assignment for which groups are to be
     *            created
     * @param otherAssignment
     *            the assignment ID of the other assignment on which the
     *            grouping is to be based
     * @param repoPrefix
     *            the prefix of the URL for the group's repository
     * @return true if successful and false otherwise
     */
    public boolean createGroups(int assignmentToGroup, int otherAssignment,
            String repoPrefix) {
        // Replace this return statement with an implementation of this method!
		if(assignmentToGroup == otherAssignment)
			return false;

		String q;
        ResultSet rs;
        PreparedStatement pS;
		
		
		//no assignment
		boolean as, oth_as;
		as = false;
		oth_as = false;

		try{
			
			q = "select assignment_id from Assignment";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getInt("assignment_id")==assignmentToGroup){
				as = true;
			  }
			  if(rs.getInt("assignment_id")==otherAssignment){
				oth_as = true;
			  }
			}
			if(!(as&&oth_as)){
			  return false;
			}
			
			//assignment has group
			q = "select assignment_id from AssignmentGroup";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();

			while(rs.next()){
			  if(rs.getInt("assignment_id")==assignmentToGroup){
				return false;
			  }
			}
			
			//insert
			
			//determine k
			q = "select group_max from Assignment where assignment_id = ?";
			pS = connection.prepareStatement(q);
			pS.setInt(1,assignmentToGroup);
			rs = pS.executeQuery();
			rs.next();
			int k = rs.getInt("group_max");
			
			//determine the start of group_id
			q = "select max(group_id) from AssignmentGroup";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();
			rs.next();
			int groupID = rs.getInt("max");
			
			
			q = "DROP VIEW IF EXISTS students CASCADE";
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "DROP VIEW IF EXISTS oth_group CASCADE";
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "DROP VIEW IF EXISTS student_mark CASCADE";
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "create view students as select username from MarkusUser where type = 'student'";
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "create view oth_group as select group_id from AssignmentGroup where assignment_id = " + otherAssignment;
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "create view student_mark as select students.username, mark from ";
			q = q + "(oth_group natural join Membership natural join Result) FULL JOIN students on Membership.username = students.username;";
			pS = connection.prepareStatement(q);
			pS.executeUpdate();
			q = "select username from student_mark order by mark DESC NULLS LAST, username ASC";
			pS = connection.prepareStatement(q);
			rs = pS.executeQuery();
			
			int i = 0;
			while(rs.next()){
				if(i==0){
					//insert into AssignmentGroup
					groupID++;
					q = "insert into AssignmentGroup VALUES (? ,? ,?)";
					pS = connection.prepareStatement(q);
					pS.setInt(1,groupID);
					pS.setInt(2,assignmentToGroup);
					pS.setString(3,repoPrefix + "/group_" + groupID);
					pS.executeUpdate();
				}
				
				//insert into Membership
				q = "insert into Membership VALUES (? ,?)";
				pS = connection.prepareStatement(q);
				pS.setString(1,rs.getString("username"));
				pS.setInt(2,groupID); 
				pS.executeUpdate();
				
				i++;
				if(i>=k){
					i=0;
				}
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			return false;
		}
		
        return true;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
		try{
			Assignment2 xx = new Assignment2();
			String url = "jdbc:postgresql://localhost:5432/csc343h-liruibin";
			xx.connectDB(url,"liruibin","");
			
			boolean asgd = xx.assignGrader(5,"t1");
			boolean recm = xx.recordMember(2,2,"E");
			boolean cg = xx.createGroups(6,1,"pre");
			System.out.println("res:" + asgd + recm + cg);
		}
		catch (SQLException ex){
			ex.printStackTrace();
		}
		
    }
}
