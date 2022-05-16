import 'package:activities/model/activities_model.dart';
import 'package:activities/services/activities_service.dart';
import 'package:rxdart/rxdart.dart';

class ActivitiesController {
  List<ActivityModel> lsActivities = [];

  final lsActivitiesFetcher = BehaviorSubject<List<ActivityModel>>();

  Stream<List<ActivityModel>> get lsActivitiesStream =>
      lsActivitiesFetcher.stream;

  Future getActivities() async {
    try {
      lsActivities = await ActivitiesService().getActivities();
      lsActivitiesFetcher.sink.add(lsActivities);
    } catch (e) {
      return;
    }
  }

  Future<bool> saveActivity(ActivityModel data) async {
    try {
      data.status = false;
      ActivityModel res = await ActivitiesService().saveActivity(data);
      if (res != null) {
        lsActivities.add(res);
        lsActivitiesFetcher.sink.add(lsActivities);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editActivity(ActivityModel data) async {
    try {
      ActivityModel res = await ActivitiesService().editActivity(data);
      if (res != null) {
        int idx = lsActivities.indexWhere((e) => e.id == data.id);
        lsActivities[idx] = res;
        lsActivitiesFetcher.sink.add(lsActivities);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteActivity(ActivityModel data) async {
    try {
      bool res = await ActivitiesService().deleteActivity(data);
      if (res != null) {
        lsActivities.removeWhere((e) => e.id == data.id);
        lsActivitiesFetcher.sink.add(lsActivities);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  dispose() {
    if (lsActivitiesFetcher.isClosed != false) lsActivitiesFetcher.close();
  }
}
