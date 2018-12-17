public with sharing class TimeEntry {
    public cls_time_totals time_totals;
	public String STATUS;	//OK
	public class cls_time_totals {
		public String total_mins_sum;	//315
		public String non_billed_mins_sum;	//315
		public String non_billable_hours_sum;	//0.00
		public String total_hours_sum;	//5.25
		public String billed_mins_sum;	//0
		public String billed_hours_sum;	//0.00
		public String billable_hours_sum;	//5.25
		public String non_billable_mins_sum;	//0
		public String non_billed_hours_sum;	//5.25
		public String billable_mins_sum;	//315
	}
	public static TimeEntry parse(String json){
		return (TimeEntry) System.JSON.deserialize(json, TimeEntry.class);
	}
}