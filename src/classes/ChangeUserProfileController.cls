public class ChangeUserProfileController implements Observable {
	public String searchTerm {get; set;}
	private List<Observer> observers;
	
	public List<UserRecord> userRecords {get{
		if( userRecords == null) userRecords = new List<UserRecord>(); return userRecords;
	} set;}
	
	public String selectedUserLicense {get; set{
		selectedUserLicense = value;
		profiles = new List<SelectOption>();
		for( Profile p : [SELECT ID, name FROM Profile WHERE UserLicenseId = :selectedUserLicense ORDER BY Name])
		{
			profiles.add(new SelectOption(p.Id, p.Name));
		}
	}}
	
	public boolean getIsResult()
	{
		if( userRecords.size()>0) return true; else return false;
	}
	
	public List<SelectOption> userLicenses{get{
		if(userLicenses == null)
		{
			userLicenses = new List<SelectOption>();
			for(UserLicense ul : [Select u.Name, u.Id From UserLicense u ORDER BY u.Name ])
			{
				userLicenses.add(new SelectOption(ul.Id, ul.Name));
			}
		}
		return userLicenses;
	} set;}
	
	public String selectedProfile{get; set;}
	public List<SelectOption> profiles{get; set;}
	
	
	public ChangeUserProfileController()
	{
		
		//Add Observers
		this.addObservers( new List<Observer>{ new UserSearchHandler() } );
		this.addObservers( new List<Observer>{ new ProfileChangeHandler() } );
	}
	//StartSearch BTN
	public PageReference actionStartSearchForUsers()
	{
		notifyObserver(new SearchEvent(searchTerm, selectedUserLicense, this));
		return null;
	}
	
	//Change Profile
	public PageReference actionChangeProfile()
	{
		notifyObserver(new ProfileChangeEvent(selectedProfile, this));
		actionStartSearchForUsers();
		return null;
	}
	
	
	
	//Observable implementation
	public void notifyObserver(Eventx event)
	{
		for(Observer o : observers) o.updatex(event);
	} 
	public void addObservers(List<Observer> observers)
	{
		if( this.observers == null ) this.observers = new List<Observer>();
		this.observers.addAll(observers);
	}
	
	//Event Classes
	public class SearchEvent implements Eventx
	{
		public String getName(){ return 'searchEvent'; }
		public String searchTerm;
		public String userLicense;
		public ChangeUserProfileController changeObject;
		public SearchEvent(String searchTerm)
		{
			this.searchTerm = searchTerm;
		}
		
		public SearchEvent(String searchTerm, String userLicense, ChangeUserProfileController controller)
		{
			this(searchTerm);
			this.userLicense = userLicense;
			changeObject = controller;
			
		}
	}
	
	//public 
	public class ProfileChangeEvent implements Eventx
	{
		public String getName() { return 'profileChangeEvent'; }
		public String newProfileId {get; set;}
		public ChangeUserProfileController changeObject;
		
		public ProfileChangeEvent(String newProfileId, ChangeUserProfileController changeObject)
		{
			this.changeObject = changeObject;
			this.newProfileId = newProfileId;
		}
	}
}