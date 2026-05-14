import '../models/kutcom_model.dart';
import '../models/kut_model.dart';

abstract class KutComService {
  Future<List<KutComModel>> getKutComs();
  Future<List<KutModel>> getKutsForKutCom(String kutComId);
  Future<List<KutComGroup>> getKutComGroups();
  Future<bool> checkTudNumberAvailability(String tudNumber);
}

class MockKutComService implements KutComService {
  @override
  Future<List<KutComModel>> getKutComs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      KutComModel(
        id: '1', name: 'Sarangi', code: 'SRG560064',
        activeInterest: 5, passiveInterest: 3, unreadMessages: 13,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      KutComModel(
        id: '2', name: 'Mekhala', code: 'MKL560032',
        activeInterest: 2, passiveInterest: 7, unreadMessages: 5,
        groupName: 'Yelahanka', groupType: KutComGroupType.kutcomGroup,
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      KutComModel(
        id: '3', name: 'Vihaan', code: 'VHN560041',
        activeInterest: 0, passiveInterest: 1, unreadMessages: 0,
        groupName: 'Yelahanka', groupType: KutComGroupType.kutcomGroup,
        lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      KutComModel(
        id: '4', name: 'Priya Homes', code: 'PRY560055',
        activeInterest: 3, passiveInterest: 2, unreadMessages: 8,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      KutComModel(
        id: '5', name: 'Lakshmi Nagar', code: 'LKN560078',
        activeInterest: 1, passiveInterest: 4, unreadMessages: 2,
        groupName: 'Whitefield', groupType: KutComGroupType.locationDeliveryGroup,
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      KutComModel(
        id: '6', name: 'Sri Residency', code: 'SRI560090',
        activeInterest: 4, passiveInterest: 0, unreadMessages: 0,
        groupName: 'Whitefield', groupType: KutComGroupType.locationDeliveryGroup,
        lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  @override
  Future<List<KutModel>> getKutsForKutCom(String kutComId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final allKuts = {
      '1': [
        KutModel(id: 'k1', name: 'Eshwar', kutComId: '1', isHTud: true, hasActiveInterest: true, unreadMessages: 3, lastActivity: DateTime.now().subtract(const Duration(minutes: 10))),
        KutModel(id: 'k2', name: 'Ravi Kumar', kutComId: '1', isHTud: false, hasActiveInterest: false, unreadMessages: 0, lastActivity: DateTime.now().subtract(const Duration(hours: 2))),
        KutModel(id: 'k3', name: 'Meena', kutComId: '1', isHTud: true, hasActiveInterest: true, unreadMessages: 7, lastActivity: DateTime.now().subtract(const Duration(minutes: 20))),
        KutModel(id: 'k4', name: 'Arun', kutComId: '1', isHTud: false, hasActiveInterest: false, unreadMessages: 1, lastActivity: DateTime.now().subtract(const Duration(hours: 1))),
        KutModel(id: 'k5', name: 'Deepa', kutComId: '1', isHTud: true, hasActiveInterest: false, unreadMessages: 2, lastActivity: DateTime.now().subtract(const Duration(hours: 3))),
      ],
      '2': [
        KutModel(id: 'k6', name: 'Suresh', kutComId: '2', isHTud: false, hasActiveInterest: true, unreadMessages: 1, lastActivity: DateTime.now().subtract(const Duration(minutes: 45))),
        KutModel(id: 'k7', name: 'Lakshmi', kutComId: '2', isHTud: true, hasActiveInterest: false, unreadMessages: 0, lastActivity: DateTime.now().subtract(const Duration(hours: 4))),
        KutModel(id: 'k8', name: 'Pradeep', kutComId: '2', isHTud: true, hasActiveInterest: true, unreadMessages: 4, lastActivity: DateTime.now().subtract(const Duration(minutes: 15))),
      ],
      '4': [
        KutModel(id: 'k9', name: 'Anand', kutComId: '4', isHTud: true, hasActiveInterest: false, unreadMessages: 5, lastActivity: DateTime.now().subtract(const Duration(minutes: 30))),
        KutModel(id: 'k10', name: 'Kavitha', kutComId: '4', isHTud: false, hasActiveInterest: true, unreadMessages: 3, lastActivity: DateTime.now().subtract(const Duration(hours: 1))),
      ],
    };
    return allKuts[kutComId] ?? [];
  }

  @override
  Future<List<KutComGroup>> getKutComGroups() async {
    final kutcoms = await getKutComs();
    final groups = <String, List<KutComModel>>{};
    final individuals = <KutComModel>[];

    for (final k in kutcoms) {
      if (k.groupName != null) {
        groups.putIfAbsent(k.groupName!, () => []).add(k);
      } else {
        individuals.add(k);
      }
    }

    final result = <KutComGroup>[];
    for (final k in individuals) {
      result.add(KutComGroup(
        name: k.name,
        type: KutComGroupType.individual,
        kutcoms: [k],
      ));
    }
    for (final entry in groups.entries) {
      result.add(KutComGroup(
        name: entry.key,
        type: entry.value.first.groupType,
        kutcoms: entry.value,
      ));
    }

    return result;
  }

  @override
  Future<bool> checkTudNumberAvailability(String tudNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return tudNumber != '98765432101';
  }
}
