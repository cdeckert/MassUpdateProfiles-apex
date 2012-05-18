public class UserRecord {
	public boolean isChecked {get; set;}
	public User sfRecord {get; set;}
	
	public UserRecord()
	{
		this.isChecked = false;
	}
	public UserRecord(User aUser)
	{
		this();
		this.sfRecord = aUser;
	}
	
	public boolean isSelected()
	{
		return isChecked;
	}
}