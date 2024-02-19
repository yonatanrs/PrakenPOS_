class UrlAPI {
  String domain = " ";

  //login
  String login = "";
  String loginDev = "";
  //employee

  //medical
  String medical = " ";
  String selectAllMedicalApprove = " ";
  String insertMedical = " ";
  String medicalApprove = " ";

  //skd
  String skd = " ";
  String selectAllSKDApprove = " ";
  String insertSKD = " ";
  String skdApprove = " ";

  //leave
  String leave = " ";
  String selectLeaveManager = " ";
  String selectLeaveHR = " ";
  String adjustmentLeave = "";

  String insertLeave = " ";
  String leaveApproveManager = " ";
  String leaveApproveHR = " ";
  String inserAdjustmentLeave = "";

  //businessTrip
  String bussTrip = " ";
  String selectBussTripManager = "";
  String insertBussTrip = " ";
  String bussTripApprove = " ";

  //duty

  //overtime

  //internal req

//parameter
  String photo = "";
  String tolerance = "";
  String period = "";
  //api/LeaveType/
  String leaveType = "";
  String leaveCategory = "";
  String periodDays = "";
  String leaveBalanceThis = "";
  String leaveBalancePrev = "";

  String typeBusinessTrip = "";
  String purposeBusinessTrip = "";
  String city = "";
  String costBusinessTrip = "";
  String kursDollar = "";

  urlAPI() {
    //link dev
    int type = 0;
    String url = "http://119.18.157.236:8877/";
    //link live
    // int type = 0;

    if (type == 0) {
      //link live
      domain = "http://api-scs.prb.co.id/";
      // domain = "http://hrms.prb.co.id:8877/";
    } else if (type == 1) {
      //link dev
      domain = "http://api-scs.prb.co.id/";
      // domain = "http://hrms.prb.co.id:8877/";
    } else {
      domain = url;
    }
  }
}
