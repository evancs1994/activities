import 'dart:convert';
import 'dart:io';

import 'package:activities/helper/client_api.dart';
import 'package:activities/model/activities_model.dart';
import 'package:dio/dio.dart';

class ActivitiesService {
  final ioc = HttpClient();
  Dio api = ClientApi().dio;

  Future<List<ActivityModel>> getActivities() async {
    try {
      final responseApi = await api.get('/activities');
      final result = json.decode(responseApi.data);
      List l = result;
      return l.map((x) => ActivityModel.fromJson(x)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<ActivityModel> saveActivity(ActivityModel data) async {
    try {
      final responseApi =
          await api.post('/activities', data: json.encode(data));
      final result = json.decode(responseApi.data);

      final ActivityModel activity = ActivityModel.fromJson(result);
      return activity;
    } catch (e) {
      return null;
    }
  }

  Future<ActivityModel> editActivity(ActivityModel data) async {
    try {
      final responseApi =
          await api.put('/activities/${data.id}', data: json.encode(data));
      final result = json.decode(responseApi.data);

      final ActivityModel activity = ActivityModel.fromJson(result);
      return activity;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteActivity(ActivityModel data) async {
    try {
      await api.delete('/activities/${data.id}');
      return true;
    } catch (e) {
      return false;
    }
  }
}
