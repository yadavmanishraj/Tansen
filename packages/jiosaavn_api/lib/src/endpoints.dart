/// All of the below endpoints require some params to function properly.
///
/// Most of requires some base params and they are with default value
/// 1. includeMetaTags: 0
/// 2. ctx: web6dot0
/// 3. api_version: 4
/// 4. _format: json
/// 5. _marker: 0
/// 5. __call: Below are the values to this params
class Endpoints {
  /// Gets data from home page the launch screen
  static const homeData = "webapi.getLaunchData";

  /// Most versatile endpoint, this endpoint can be used to get various data types.
  /// E.G. Playlist, Albums, Artist, Song etc with some variation in params value
  ///
  /// Params for all types are: {song, album,playlist}
  /// 1. type: {type_value}, e.g. playlist,album,song
  /// 2. token: {token}  some kind of token to identify this data, usualy last part of data permaUrl
  ///
  /// Params Unique to Playlist are:
  /// 1. p: 1  used for pagination, page count
  /// 2. n: 50 used for number of songs to get per page
  ///
  /// Params for artist
  /// 1. p: 1
  /// 2. n_song: {no of songs}
  /// 3. n_album: {no of albums}
  /// 4. sub_type: {albums|playlist|song}
  /// 5. category: {category of content} e.g. date{latest}, alphabetical,
  /// 6. sort_order: {asc,desc} sorting order
  /// 7. more: {true|false}
  static const webGet = "webapi.get";

  /// Get TopSerch for request geo location
  /// No Unique Params required
  static const topSearches = "content.getTopSearches";
  static const playlistRecommendation = "reco.getPlaylistReco";
  static const trending = "content.getTrending";
  static const albumDetails = "content.getAlbumDetails";
  static const userLibrary = "library.getAll";
  static const createRadio = "webradio.createEntityStation";
  static const radioDetails = "webradio.getSong";
  static const songDownloadToken = "song.generateAuthToken";
  static const albumRecommendation = "reco.getAlbumReco";

  /// Endpoint to top albums from particular year
  ///
  /// Params are
  /// 1. album_year: {year}
  /// 2. album_lang: {language} e.g. hindi, english, punjabi, all supported language on jiosaavn platform
  static const topAlbumsOfTheYear = "search.topAlbumsoftheYear";

  /// Gets tops songs from perticular list of actor ids
  /// Params
  /// 1. actor_ids: 34,23     // actor ids here
  /// 2. song_id: HHLHpNmt    // hint as from song recommendation to fetch
  /// 3. language: hindi      // all supported languge on platform
  static const actorOtherTopSongs = "search.actorOtherTopSongs";

  /// Gets tops songs from perticular list of artists ids
  /// Params
  /// 1. actor_ids: 34,23     // artist ids here
  /// 2. song_id: HHLHpNmt    // hint as from song recommendation to fetch
  /// 3. language: hindi      // all supported languge on platform
  static const artistOtherTopSongs = "search.artistOtherTopSongs";

  /// Gets Playlist Recommendations
  /// Params
  /// 1. pid: {playlistid}
  /// 2. language: {language}
  static const recommendation = "reco.getreco";

  static const featuredPlaylists = "content.getFeaturedPlaylists";
  static const topPodcasts = "content.getTopShows";
  static const topArtists = "social.getTopArtists";
  static const search = "autocomplete.get";
}
