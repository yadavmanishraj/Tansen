// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistDetails _$ArtistDetailsFromJson(Map<String, dynamic> json) =>
    ArtistDetails(
      id: json['artistId'] as String,
      availableLanguages: (json['availableLanguages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      dedicatedArtistPlaylist:
          (json['dedicated_artist_playlist'] as List<dynamic>?)
              ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      dob: json['dob'] as String?,
      dominantLanguage: json['dominantLanguage'] as String?,
      dominantType: json['dominantType'] as String?,
      fanCount: json['fan_count'] as String?,
      fb: json['fb'] as String?,
      twitter: json['twitter'] as String?,
      featuredPlaylists: (json['featured_artist_playlist'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      followerCount: json['follower_count'] as String?,
      image: json['image'] as String?,
      isRadioPresent: json['isRadioPresent'] as bool?,
      isVerified: json['isVerified'] as bool?,
      isFollowed: json['is_followed'] as bool?,
      latestRelease: (json['latest_release'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      singles: (json['singles'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle: json['subtitle'] as String?,
      topAlbums: (json['topAlbums'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topEpisodes: (json['topEpisodes'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topSongs: (json['topSongs'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ArtistDetailsToJson(ArtistDetails instance) =>
    <String, dynamic>{
      'artistId': instance.id,
      'availableLanguages': instance.availableLanguages,
      'bio': instance.bio,
      'dedicated_artist_playlist': instance.dedicatedArtistPlaylist,
      'dob': instance.dob,
      'dominantLanguage': instance.dominantLanguage,
      'dominantType': instance.dominantType,
      'fan_count': instance.fanCount,
      'fb': instance.fb,
      'twitter': instance.twitter,
      'featured_artist_playlist': instance.featuredPlaylists,
      'follower_count': instance.followerCount,
      'image': instance.image,
      'isRadioPresent': instance.isRadioPresent,
      'isVerified': instance.isVerified,
      'is_followed': instance.isFollowed,
      'latest_release': instance.latestRelease,
      'name': instance.name,
      'singles': instance.singles,
      'subtitle': instance.subtitle,
      'topAlbums': instance.topAlbums,
      'topEpisodes': instance.topEpisodes,
      'topSongs': instance.topSongs,
      'type': instance.type,
    };
