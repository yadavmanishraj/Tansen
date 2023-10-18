// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      explicitContent: json['explicit_content'] as String,
      headerDesc: json['header_desc'] as String,
      language: json['language'] as String,
      listCount: json['list_count'] as String,
      listType: json['list_type'] as String,
      playCount: json['play_count'] as String,
      year: json['year'] as String,
      permaUrl: json['perma_url'] as String,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
      playlistExtraDetails: json['more_info'] == null
          ? null
          : PlaylistExtraDetails.fromJson(
              json['more_info'] as Map<String, dynamic>),
      songs: (json['list'] as List<dynamic>?)
          ?.map((e) => SongDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'explicit_content': instance.explicitContent,
      'header_desc': instance.headerDesc,
      'language': instance.language,
      'list_count': instance.listCount,
      'list_type': instance.listType,
      'play_count': instance.playCount,
      'year': instance.year,
      'list': instance.songs,
      'more_info': instance.playlistExtraDetails,
    };

PlaylistExtraDetails _$PlaylistExtraDetailsFromJson(
        Map<String, dynamic> json) =>
    PlaylistExtraDetails(
      fanCount: json['fan_count'] as String?,
      firstName: json['firstname'] as String?,
      followerCount: json['follower_count'] as String?,
      isFYP: json['isFY'] as bool? ?? false,
      isDolbyContent: json['is_dolby_content'] as bool? ?? false,
      isFollowed: json['is_followed'] as String?,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      lastname: json['lastname'] as String?,
      playlistType: json['playlist_type'] as String?,
      share: json['share'] as String?,
      subtitleDesc: (json['subtitle_desc'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uid: json['uid'] as String?,
      username: json['username'] as String?,
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      videoCount: json['video_count'] as String?,
    );

Map<String, dynamic> _$PlaylistExtraDetailsToJson(
        PlaylistExtraDetails instance) =>
    <String, dynamic>{
      'fan_count': instance.fanCount,
      'firstname': instance.firstName,
      'follower_count': instance.followerCount,
      'isFY': instance.isFYP,
      'is_dolby_content': instance.isDolbyContent,
      'is_followed': instance.isFollowed,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'lastname': instance.lastname,
      'playlist_type': instance.playlistType,
      'share': instance.share,
      'subtitle_desc': instance.subtitleDesc,
      'uid': instance.uid,
      'username': instance.username,
      'video_count': instance.videoCount,
      'artists': instance.artists,
    };
