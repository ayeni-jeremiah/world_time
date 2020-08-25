import 'package:data_connection_checker/data_connection_checker.dart';

//verify if internet exist
class Internet {
  String errorMessage = "No Internet Connection!";

  Future<bool> isConnected() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      return true;
    } else {
      return null;

      // print(DataConnectionChecker().lastTryResults);

//      var listener = DataConnectionChecker().onStatusChange.listen((status) {
//        switch (status) {
//          case DataConnectionStatus.connected:
//            print('Data connection is available.');
//            return true;
//            break;
//          case DataConnectionStatus.disconnected:
//            print('You are disconnected from the internet.');
//            return false;
//            break;
//        }
//      });
//      // close listener after 30 seconds, so the program doesn't run forever
//      await Future.delayed(Duration(seconds: 30));
//      await listener.cancel();
    }
  }
}
