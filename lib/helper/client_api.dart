import 'package:dio/dio.dart';
import 'app_setting.dart' as app;

class ClientApi {
  Dio dio;

  ClientApi() {
    BaseOptions options = BaseOptions(
      baseUrl: app.baseUrl,
      connectTimeout: 60000,
      receiveTimeout: 90000,
      responseType: ResponseType.plain,
    );
    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        return handler.next(e); //continue
      },
      onRequest: (options, handler) async {
        return handler.next(options); //continue
      },
    ));
  }
}
