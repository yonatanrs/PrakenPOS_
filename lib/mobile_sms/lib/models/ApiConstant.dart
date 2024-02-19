class ApiConstant {
  String urlApi = '';
  ApiConstant(int code) {
    if (code == 0) {
      //domain utama
      urlApi = 'http://hrms.prb.co.id:8869/';
    } else if (code == 1) {
      //jlm
      urlApi = 'http://119.18.157.236:8869/';
    } else{
      //quantum
      urlApi = 'http://119.18.157.236:8869/';
    }
  }
}
