// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:innox/auth/domain/user.dart';
part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const UserDTO._();
  const factory UserDTO({
    required int usaIDpk,
    required int empIDpk,
    required int dptIDpk,
    required int sxnIDpk,
    required int untIDpk,
    required String usaUsername,
    required bool usaSuperuser,
    required bool usaAllowSendingOfSMS,
    required bool empIsOrgAdmin,
    @JsonKey(name: "empIsDeptadmin") required bool empIsDeptAdmin,
    required bool empIsSectionAdmin,
    required bool empIsUnitAdmin,
    required bool usaSeeSalaries,
    required bool usaEditIntercom,
    required bool usaSeeAllForms,
    required String empFirstName,
    required String empLastName,
    required bool empShowBirthdayInNewsFlash,
    required bool empShowWorkAnniversaryInNewsFlash,
    required bool usaSeeAuditTrail,
    required bool usaChangePassword,
    required bool empIsDirector,
    required bool empIsManager,
    required bool empIsSupervisor,
    required bool empIsCeo,
    required String dptShtName,
    required String sxnShtName,
    required String untShtName,
    required String dptName,
    required String sxnName,
    required String untName,
    required String empName,
    required String empStaffno,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  factory UserDTO.fromDomain(User _) {
    return UserDTO(
      usaIDpk: _.usaIDpk,
      empIDpk: _.empIDpk,
      dptIDpk: _.dptIDpk,
      sxnIDpk: _.sxnIDpk,
      untIDpk: _.untIDpk,
      usaUsername: _.usaUsername,
      usaSuperuser: _.usaSuperuser,
      usaAllowSendingOfSMS: _.usaAllowSendingOfSMS,
      empIsOrgAdmin: _.empIsOrgAdmin,
      empIsDeptAdmin: _.empIsDeptAdmin,
      empIsSectionAdmin: _.empIsSectionAdmin,
      empIsUnitAdmin: _.empIsUnitAdmin,
      usaSeeSalaries: _.usaSeeSalaries,
      usaEditIntercom: _.usaEditIntercom,
      usaSeeAllForms: _.usaSeeAllForms,
      empShowBirthdayInNewsFlash: _.empShowBirthdayInNewsFlash,
      empShowWorkAnniversaryInNewsFlash: _.empShowWorkAnniversaryInNewsFlash,
      usaSeeAuditTrail: _.usaSeeAuditTrail,
      usaChangePassword: _.usaChangePassword,
      empIsDirector: _.empIsDirector,
      empIsManager: _.empIsManager,
      empIsSupervisor: _.empIsSupervisor,
      empIsCeo: _.empIsCeo,
      dptShtName: _.dptShtName,
      sxnShtName: _.sxnShtName,
      untShtName: _.untShtName,
      dptName: _.dptName,
      sxnName: _.sxnName,
      untName: _.untName,
      empName: _.empName,
      empStaffno: _.empStaffno,
      empFirstName: _.empFirstName,
      empLastName: _.empLastName,
    );
  }

  User toDomain() {
    return User(
      usaIDpk: usaIDpk,
      empIDpk: empIDpk,
      dptIDpk: dptIDpk,
      sxnIDpk: sxnIDpk,
      untIDpk: untIDpk,
      usaUsername: usaUsername,
      usaSuperuser: usaSuperuser,
      usaAllowSendingOfSMS: usaAllowSendingOfSMS,
      empIsOrgAdmin: empIsOrgAdmin,
      empIsDeptAdmin: empIsDeptAdmin,
      empIsSectionAdmin: empIsSectionAdmin,
      empIsUnitAdmin: empIsUnitAdmin,
      usaSeeSalaries: usaSeeSalaries,
      usaEditIntercom: usaEditIntercom,
      usaSeeAllForms: usaSeeAllForms,
      empShowBirthdayInNewsFlash: empShowBirthdayInNewsFlash,
      empShowWorkAnniversaryInNewsFlash: empShowWorkAnniversaryInNewsFlash,
      usaSeeAuditTrail: usaSeeAuditTrail,
      usaChangePassword: usaChangePassword,
      empIsDirector: empIsDirector,
      empIsManager: empIsManager,
      empIsSupervisor: empIsSupervisor,
      empIsCeo: empIsCeo,
      dptShtName: dptShtName,
      sxnShtName: sxnShtName,
      untShtName: untShtName,
      dptName: dptName,
      sxnName: sxnName,
      untName: untName,
      empName: empName,
      empStaffno: empStaffno,
      empFirstName: empFirstName,
      empLastName: empLastName,
    );
  }
}
