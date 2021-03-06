class Artist < ActiveRecord::Base
  belongs_to :user
  has_many :songs
  has_many :concerts

  def self.assign_artists(user)
    user.top_artists["items"].each do |a|
      artist = self.find_or_create_by(name: a["name"] || [], popularity: a["popularity"], artist_id: a["id"])
      artist.top_tracks
      artist.upcoming_concerts
      user.artists << artist
    end
  end

  def top_tracks
    artist_tracks["tracks"].each do |track|
      songs.new(name: track["name"], album: track["album"]["name"], song_url: track["external_urls"]["spotify"])
    end
  end

  def artist_tracks
    response = Faraday.get("https://api.spotify.com/v1/artists/#{self.artist_id}/top-tracks?country=se&format=json").body
    JSON.parse(response)
  end

  def upcoming_concerts
    events.each do |event|
      if event["artists"].first["name"].downcase == self.name.downcase && new_event(event)
        self.concerts.create(title: event["title"], date: event["formatted_datetime"], ticket_url: event["ticket_url"], status: event["ticket_status"], name: event["venue"]["name"], city: event["venue"]["city"], state: event["venue"]["region"])
      end
    end
  end

  def new_event(event)
    Concert.find_by(title: event["title"]).nil?
  end

  def events
    escaped_uri = URI.escape("https://api.bandsintown.com/artists/#{name}/events/recommended?location=use_geoip&radius=50&app_id=discover-shows&api_version=2.0&format=json")
    uri = Faraday.get(escaped_uri).body
    JSON.parse(uri)
  end
end
