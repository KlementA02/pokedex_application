import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    required int usaIDpk,
    required int empIDpk,
    required int dptIDpk,
    required int sxnIDpk,
    required int untIDpk,
    required String usaUsername,
    required bool usaSuperuser,
    required bool usaAllowSendingOfSMS,
    required bool empIsOrgAdmin,
    required bool
        empIsDeptAdmin, //remember to change it at the UserDTO class => empIsDeptadmin
    required bool empIsSectionAdmin,
    required bool empIsUnitAdmin,
    required bool usaSeeSalaries,
    required bool usaEditIntercom,
    required bool usaSeeAllForms,
    required bool empShowBirthdayInNewsFlash,
    required bool empShowWorkAnniversaryInNewsFlash,
    required bool usaSeeAuditTrail,
    required bool usaChangePassword,
    required bool empIsDirector,
    required bool empIsManager,
    required bool empIsSupervisor,
    required bool empIsCeo,
    required String empFirstName,
    required String empLastName,
    required String dptShtName,
    required String sxnShtName,
    required String untShtName,
    required String dptName,
    required String sxnName,
    required String untName,
    required String empName,
    required String empStaffno,
  }) = _User;

  String get usaUserName => usaUsername;
  String get empFirstName => empFirstName;
}
