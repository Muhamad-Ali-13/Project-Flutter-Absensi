// api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:absensi/models/dashboard.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

// ==================== UTILS ====================

// Header JSON + optional Authorization
Map<String, String> _headers([String? token]) {
  final headers = {'Content-Type': 'application/json'};
  if (token != null) headers['Authorization'] = 'Bearer $token';
  return headers;
}

// Generic GET list
Future<List<Map<String, dynamic>>> fetchData(String endpoint) async {
  final url = Uri.parse('$baseUrl/$endpoint');
  final resp = await http
      .get(url, headers: _headers())
      .timeout(const Duration(seconds: 10));
  if (resp.statusCode == 200) {
    return (jsonDecode(resp.body) as List).cast<Map<String, dynamic>>();
  }
  throw Exception('GET $endpoint failed: ${resp.statusCode}');
}

// Generic GET single item
Future<Map<String, dynamic>> fetchOne(String endpoint) async {
  final url = Uri.parse('$baseUrl/$endpoint');
  final resp = await http
      .get(url, headers: _headers())
      .timeout(const Duration(seconds: 10));
  if (resp.statusCode == 200) {
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
  throw Exception('GET $endpoint failed: ${resp.statusCode}');
}

// Generic POST / PUT / DELETE
Future<void> sendData(
  String method,
  String endpoint, {
  Map<String, dynamic>? body,
}) async {
  final url = Uri.parse('$baseUrl/$endpoint');
  final encoded = body == null ? null : jsonEncode(body);
  late http.Response resp;

  switch (method) {
    case 'POST':
      resp = await http
          .post(url, headers: _headers(), body: encoded)
          .timeout(const Duration(seconds: 10));
      break;
    case 'PUT':
      resp = await http
          .put(url, headers: _headers(), body: encoded)
          .timeout(const Duration(seconds: 10));
      break;
    case 'DELETE':
      resp = await http
          .delete(url, headers: _headers())
          .timeout(const Duration(seconds: 10));
      break;
    default:
      throw Exception('Unsupported HTTP method: $method');
  }

  if (resp.statusCode >= 400) {
    final msg =
        resp.body.isNotEmpty
            ? (jsonDecode(resp.body) as Map<String, dynamic>)['error'] ??
                resp.statusCode
            : resp.statusCode;
    throw Exception('$method $endpoint failed: $msg');
  }
}

// Upload File
Future<void> uploadFile(String endpoint, File file) async {
  final url = Uri.parse('$baseUrl/$endpoint');
  final request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', file.path));
  final resp = await request.send().timeout(const Duration(seconds: 10));
  if (resp.statusCode != 200) {
    throw Exception('Upload failed: ${resp.statusCode}');
  }
}

// ==================== AUTH ====================
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/login');
  final resp = await http
      .post(
        url,
        headers: _headers(),
        body: jsonEncode({'email': email, 'password': password}),
      )
      .timeout(const Duration(seconds: 10));

  if (resp.statusCode == 200) {
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    return {
      'token': body['token'],
      'user': body['user'],
    };
  } else {
    final body = jsonDecode(resp.body);
    throw Exception(body['error'] ?? 'Login gagal');
  }
}

Future<void> logout() async {
  final url = Uri.parse('$baseUrl/logout');
  final resp = await http
      .post(url, headers: _headers())
      .timeout(const Duration(seconds: 10));
  if (resp.statusCode != 200) {
    throw Exception('Logout failed: ${resp.statusCode}');
  }
}

// ==================== API SERVICE ====================

class ApiService {
  // USER
  static Future<List<Map<String, dynamic>>> fetchUsers() async =>
      fetchData('users');

  static Future<Map<String, dynamic>> fetchUserById(int id_users) async =>
      fetchOne('users/$id_users');

  static Future<void> createUser(Map<String, dynamic> data) async =>
      sendData('POST', 'users', body: data);

  static Future<void> updateUser(int id_users, Map<String, dynamic> data) async =>
      sendData('PUT', 'users/$id_users', body: data);

  static Future<void> deleteUser(int id_users) async =>
      sendData('DELETE', 'users/$id_users');

  // SISWA
  static Future<List<Map<String, dynamic>>> fetchSiswas() async =>
      fetchData('siswa');
  static Future<Map<String, dynamic>> fetchSiswaById(int id) async =>
      fetchOne('siswa/$id');
  static Future<void> createSiswa(Map<String, dynamic> data) async =>
      sendData('POST', 'siswa', body: data);
  static Future<void> updateSiswa(int id, Map<String, dynamic> data) async =>
      sendData('PUT', 'siswa/$id', body: data);
  static Future<void> deleteSiswa(int id) async =>
      sendData('DELETE', 'siswa/$id');

  // GURU
  static Future<List<Map<String, dynamic>>> fetchGurus() async =>
      fetchData('guru');
  static Future<Map<String, dynamic>> fetchGuruById(int id) async =>
      fetchOne('guru/$id');
  static Future<void> createGuru(Map<String, dynamic> data) async =>
      sendData('POST', 'guru', body: data);
  static Future<void> updateGuru(int id, Map<String, dynamic> data) async =>
      sendData('PUT', 'guru/$id', body: data);
  static Future<void> deleteGuru(int id) async =>
      sendData('DELETE', 'guru/$id');

  // KELAS
  static Future<List<Map<String, dynamic>>> fetchKelas() async =>
      fetchData('kelas');
  static Future<Map<String, dynamic>> fetchKelasById(int id) async =>
      fetchOne('kelas/$id');
  static Future<void> createKelas(Map<String, dynamic> data) async =>
      sendData('POST', 'kelas', body: data);
  static Future<void> updateKelas(int id, Map<String, dynamic> data) async =>
      sendData('PUT', 'kelas/$id', body: data);
  static Future<void> deleteKelas(int id) async =>
      sendData('DELETE', 'kelas/$id');

  // MATA PELAJARAN
  static Future<List<Map<String, dynamic>>> fetchMataPelajarans() async =>
      fetchData('mata_pelajaran');
  static Future<Map<String, dynamic>> fetchMataPelajaranById(int id) async =>
      fetchOne('mata_pelajaran/$id');
  static Future<void> createMataPelajaran(Map<String, dynamic> data) async =>
      sendData('POST', 'mata_pelajaran', body: data);
  static Future<void> updateMataPelajaran(
    int id,
    Map<String, dynamic> data,
  ) async => sendData('PUT', 'mata_pelajaran/$id', body: data);
  static Future<void> deleteMataPelajaran(int id) async =>
      sendData('DELETE', 'mata_pelajaran/$id');

  // JADWAL PEMBELAJARAN
  static Future<List<Map<String, dynamic>>> fetchJadwalPembelajarans() async =>
      fetchData('jadwalpembelajaran');
  static Future<Map<String, dynamic>> fetchJadwalPembelajaranById(
    int id,
  ) async => fetchOne('jadwalpembelajaran/$id');
  static Future<void> createJadwalPembelajaran(
    Map<String, dynamic> data,
  ) async => sendData('POST', 'jadwalpembelajaran', body: data);
  static Future<void> updateJadwalPembelajaran(
    int id,
    Map<String, dynamic> data,
  ) async => sendData('PUT', 'jadwalpembelajaran/$id', body: data);
  static Future<void> deleteJadwalPembelajaran(int id) async =>
      sendData('DELETE', 'jadwalpembelajaran/$id');

  // ABSENSI
  static Future<List<Map<String, dynamic>>> fetchAbsensi() async =>
      fetchData('absensi');
  static Future<Map<String, dynamic>> fetchAbsensiById(int id) async =>
      fetchOne('absensi/$id');
  static Future<void> createAbsensi(Map<String, dynamic> data) async =>
      sendData('POST', 'absensi', body: data);
  static Future<void> updateAbsensi(int id, Map<String, dynamic> data) async =>
      sendData('PUT', 'absensi/$id', body: data);
  static Future<void> deleteAbsensi(int id) async =>
      sendData('DELETE', 'absensi/$id');

  // ==================== DASHBOARD ====================
  static Future<Dashboard> fetchDashboardData() async {
    final data = await fetchOne('dashboard');
    return Dashboard.fromJson(data);
  }
}
