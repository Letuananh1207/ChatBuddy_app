import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_post.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CommunityRepository(apiService);
});

final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  return repository.fetchPosts();
});

final communityPostProvider =
    FutureProvider.family<CommunityPost, String>((ref, postId) async {
  final repository = ref.watch(communityRepositoryProvider);
  return repository.fetchPostById(postId);
});

class CommunityRepository {
  final ApiService _apiService;

  CommunityRepository(this._apiService);

  Future<List<CommunityPost>> fetchPosts({int limit = 20, int page = 0}) async {
    final response = await _apiService.get(
      ApiConstants.posts,
      queryParameters: {
        'limit': limit,
        'page': page,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(CommunityPost.fromJson)
          .toList();
    }

    throw Exception('Không thể tải bài viết cộng đồng');
  }

  Future<CommunityPost> createPost({
    required String text,
    List<PlatformFile>? images,
    List<PlatformFile>? audios,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('text', text));

    if (images != null) {
      for (final image in images) {
        if (image.path != null) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                image.path!,
                filename: image.name,
              ),
            ),
          );
        } else if (image.bytes != null) {
          formData.files.add(
            MapEntry(
              'images',
              MultipartFile.fromBytes(
                image.bytes!,
                filename: image.name,
              ),
            ),
          );
        }
      }
    }

    if (audios != null) {
      for (final audio in audios) {
        if (audio.path != null) {
          formData.files.add(
            MapEntry(
              'audio',
              await MultipartFile.fromFile(
                audio.path!,
                filename: audio.name,
              ),
            ),
          );
        } else if (audio.bytes != null) {
          formData.files.add(
            MapEntry(
              'audio',
              MultipartFile.fromBytes(
                audio.bytes!,
                filename: audio.name,
              ),
            ),
          );
        }
      }
    }

    final response = await _apiService.post(
      ApiConstants.posts,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if ((response.statusCode == 201 || response.statusCode == 200) &&
        response.data is Map<String, dynamic>) {
      return CommunityPost.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Không thể tạo bài viết mới');
  }

  Future<CommunityPost> fetchPostById(String id) async {
    final response = await _apiService.get('${ApiConstants.posts}/$id');

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      return CommunityPost.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Không thể tải chi tiết bài viết');
  }

  Future<CommunityPost> toggleLike(String postId) async {
    final response =
        await _apiService.post('${ApiConstants.posts}/$postId/like');

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data is Map<String, dynamic>) {
      return CommunityPost.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Không thể thay đổi trạng thái thích bài viết');
  }

  Future<CommunityPost> addComment({
    required String postId,
    required String content,
  }) async {
    final response = await _apiService.post(
      '${ApiConstants.posts}/$postId/comment',
      data: {'content': content},
    );

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data is Map<String, dynamic>) {
      return CommunityPost.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Không thể thêm bình luận');
  }
}
