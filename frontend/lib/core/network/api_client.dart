import 'package:dio/dio.dart';

/// Lop goi API chung toi backend.
class ApiClient {
  ApiClient()
      : _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000/api/v1'));

  final Dio _dio;

  Dio get dio => _dio;
  // TODO: them token vao header khi da dang nhap
}
