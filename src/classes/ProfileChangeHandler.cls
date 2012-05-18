public class ProfileChangeHandler implements Observer {
	public void updatex(Eventx response)
	{
		if( response.getName() == 'profileChangeEvent')
		{
			ChangeUserProfileController.ProfileChangeEvent eventx = (ChangeUserProfileController.ProfileChangeEvent) response;
			
			List<User> users = new List<User>();
			for( UserRecord u : eventx.changeObject.userRecords)
			{
				if( u.isSelected() )
				{
					u.sfRecord.ProfileId = eventx.newProfileId;
					users.add(u.sfRecord);
				}
			}
			if( users.size()>0) update users;
		}
	}
}