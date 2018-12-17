public with sharing class GetConcretians {
    public cls_people[] people;
	public class cls_people {
		public boolean administrator;
		public String address_city;	//
		public String pid;	//
		public boolean site_owner;
		public String twitter;	//
		public String phone_number_home;	//
		public String last_name;	//User'
		public String email_address;	//d2@demo1company.com
		public String userUUID;	//7d1bedcb_687d_102d_985d_8cebf3022cd9
		public String user_name;	//demo2
		public String company_name;	//Demo 1 Company
		public String id;	//999
		public String last_changed_on;	//2014_03_25T17:15:53Z
		public String phone_number_office;	//
		public boolean deleted;
		public String address_state;	//
		public String address_country;	//
		public String notes;	//
		public String phone_number_mobile;	//
		public String first_name;	//'Demo 2
		public String user_type;	//account
		public cls_permissions permissions;
		public String im_service;	//
		public String im_handle;	//
		public String address_line_2;	//
		public String address_line_1;	//
		public String created_at;	//2008_04_29T15:02:21Z
		public String phone_number_office_ext;	//
		public String company_id;	//999
		public boolean has_access_to_new_projects;
		public String address_zip;	//
		public String phone_number_fax;	//
		public String avatar_url;	//http://demo1company.teamwork.com/images/avatar.jpg
		public boolean in_owner_company;
		public String last_login;	//2014_03_25T17:15:42Z
		public String email_alt_1;	//
		public String email_alt_2;	//
		public String companyId;	//999
		public String email_alt_3;	//
		public String title;	//
	}
	public class cls_permissions {
		public boolean can_manage_people;
		public boolean can_add_projects;
	}
	public static GetConcretians parse(String json){
		return (GetConcretians) System.JSON.deserialize(json, GetConcretians.class);
	}
}