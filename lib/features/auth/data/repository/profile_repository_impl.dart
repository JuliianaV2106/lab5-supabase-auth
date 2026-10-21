import 'package:moviles_auth/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<void> createProfile(Profile profile) =>
      _dataSource.createProfile(profile);

  @override
  Future<Profile> getProfile(String id) => _dataSource.getProfile(id);
}
