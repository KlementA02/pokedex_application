// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDTOImpl _$$UserDTOImplFromJson(Map<String, dynamic> json) =>
    _$UserDTOImpl(
      usaIDpk: (json['usaIDpk'] as num).toInt(),
      empIDpk: (json['empIDpk'] as num).toInt(),
      dptIDpk: (json['dptIDpk'] as num).toInt(),
      sxnIDpk: (json['sxnIDpk'] as num).toInt(),
      untIDpk: (json['untIDpk'] as num).toInt(),
      usaUsername: json['usaUsername'] as String,
      usaSuperuser: json['usaSuperuser'] as bool,
      usaAllowSendingOfSMS: json['usaAllowSendingOfSMS'] as bool,
      empIsOrgAdmin: json['empIsOrgAdmin'] as bool,
      empIsDeptAdmin: json['empIsDeptadmin'] as bool,
      empIsSectionAdmin: json['empIsSectionAdmin'] as bool,
      empIsUnitAdmin: json['empIsUnitAdmin'] as bool,
      usaSeeSalaries: json['usaSeeSalaries'] as bool,
      usaEditIntercom: json['usaEditIntercom'] as bool,
      usaSeeAllForms: json['usaSeeAllForms'] as bool,
      empFirstName: json['empFirstName'] as String,
      empLastName: json['empLastName'] as String,
      empShowBirthdayInNewsFlash: json['empShowBirthdayInNewsFlash'] as bool,
      empShowWorkAnniversaryInNewsFlash:
          json['empShowWorkAnniversaryInNewsFlash'] as bool,
      usaSeeAuditTrail: json['usaSeeAuditTrail'] as bool,
      usaChangePassword: json['usaChangePassword'] as bool,
      empIsDirector: json['empIsDirector'] as bool,
      empIsManager: json['empIsManager'] as bool,
      empIsSupervisor: json['empIsSupervisor'] as bool,
      empIsCeo: json['empIsCeo'] as bool,
      dptShtName: json['dptShtName'] as String,
      sxnShtName: json['sxnShtName'] as String,
      untShtName: json['untShtName'] as String,
      dptName: json['dptName'] as String,
      sxnName: json['sxnName'] as String,
      untName: json['untName'] as String,
      empName: json['empName'] as String,
      empStaffno: json['empStaffno'] as String,
    );

Map<String, dynamic> _$$UserDTOImplToJson(_$UserDTOImpl instance) =>
    <String, dynamic>{
      'usaIDpk': instance.usaIDpk,
      'empIDpk': instance.empIDpk,
      'dptIDpk': instance.dptIDpk,
      'sxnIDpk': instance.sxnIDpk,
      'untIDpk': instance.untIDpk,
      'usaUsername': instance.usaUsername,
      'usaSuperuser': instance.usaSuperuser,
      'usaAllowSendingOfSMS': instance.usaAllowSendingOfSMS,
      'empIsOrgAdmin': instance.empIsOrgAdmin,
      'empIsDeptadmin': instance.empIsDeptAdmin,
      'empIsSectionAdmin': instance.empIsSectionAdmin,
      'empIsUnitAdmin': instance.empIsUnitAdmin,
      'usaSeeSalaries': instance.usaSeeSalaries,
      'usaEditIntercom': instance.usaEditIntercom,
      'usaSeeAllForms': instance.usaSeeAllForms,
      'empFirstName': instance.empFirstName,
      'empLastName': instance.empLastName,
      'empShowBirthdayInNewsFlash': instance.empShowBirthdayInNewsFlash,
      'empShowWorkAnniversaryInNewsFlash':
          instance.empShowWorkAnniversaryInNewsFlash,
      'usaSeeAuditTrail': instance.usaSeeAuditTrail,
      'usaChangePassword': instance.usaChangePassword,
      'empIsDirector': instance.empIsDirector,
      'empIsManager': instance.empIsManager,
      'empIsSupervisor': instance.empIsSupervisor,
      'empIsCeo': instance.empIsCeo,
      'dptShtName': instance.dptShtName,
      'sxnShtName': instance.sxnShtName,
      'untShtName': instance.untShtName,
      'dptName': instance.dptName,
      'sxnName': instance.sxnName,
      'untName': instance.untName,
      'empName': instance.empName,
      'empStaffno': instance.empStaffno,
    };
