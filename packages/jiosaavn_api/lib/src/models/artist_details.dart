// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:jiosaavn_api/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'artist_details.g.dart';

@JsonSerializable()
class ArtistDetails {
  @JsonKey(name: "artistId")
  final String id;
  final List<String>? availableLanguages;
  final String? bio;
  @JsonKey(name: "dedicated_artist_playlist")
  final List<BaseModel>? dedicatedArtistPlaylist;
  final String? dob;
  final String? dominantLanguage;
  final String? dominantType;
  @JsonKey(name: "fan_count")
  final String? fanCount;
  final String? fb;
  final String? twitter;
  @JsonKey(name: "featured_artist_playlist")
  final List<BaseModel>? featuredPlaylists;
  @JsonKey(name: "follower_count")
  final String? followerCount;
  final String? image;
  final bool? isRadioPresent;
  final bool? isVerified;
  @JsonKey(name: "is_followed")
  final bool? isFollowed;
  @JsonKey(name: "latest_release")
  final List<BaseModel>? latestRelease;
  final String? name;
  final List<BaseModel>? singles;
  final String? subtitle;
  final List<BaseModel>? topAlbums;
  final List<BaseModel>? topEpisodes;
  final List<BaseModel>? topSongs;
  final String? type;

  ArtistDetails({
    required this.id,
    this.availableLanguages,
    this.bio,
    this.dedicatedArtistPlaylist,
    this.dob,
    this.dominantLanguage,
    this.dominantType,
    this.fanCount,
    this.fb,
    this.twitter,
    this.featuredPlaylists,
    this.followerCount,
    this.image,
    this.isRadioPresent,
    this.isVerified,
    this.isFollowed,
    this.latestRelease,
    this.name,
    this.singles,
    this.subtitle,
    this.topAlbums,
    this.topEpisodes,
    this.topSongs,
    this.type,
  });

  factory ArtistDetails.fromJson(Map<String, dynamic> json) =>
      _$ArtistDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistDetailsToJson(this);
}
