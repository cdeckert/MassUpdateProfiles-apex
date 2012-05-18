public class UserSearchHandler implements Observer{
	public void updatex(Eventx response)
	{
		if( response.getName() == 'searchEvent' )
		{
			ChangeUserProfileController.SearchEvent event = (ChangeUserProfileController.SearchEvent) response;
			
			List<UserRecord> userRecords = new List<UserRecord>();
			String searchTerm = event.searchTerm;
			if(!searchTerm.endsWith('*')) searchTerm+='*';
			
			if( searchTerm.length() > 3)
			{
				for(List<sObject> result : [FIND :searchTerm IN ALL FIELDS RETURNING User (Id, name, ProfileId, Profile.name WHERE Profile.UserLicenseId = :event.userLicense AND IsActive = true) ])
				{
					for(sObject s : result)
					{
						userRecords.add(new UserRecord((User) s ));
					}
				}
			}
			else
			{
				for( User u : [SELECT id, Name, ProfileId, Profile.name FROM User WHERE Profile.UserLicenseId = :event.userLicense AND IsActive = true ORDER BY Name])
				{
					userRecords.add(new UserRecord( u ));
				}
			}
			event.changeObject.userRecords = userRecords;
		}
	}

}