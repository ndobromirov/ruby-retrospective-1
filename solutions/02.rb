class Song
  def Song.parse(row, info={})
    name, artist, genres, tags_str = row.split('.').map(&:strip)
    genre, subgenre = genres.split(',').map(&:strip)
    tags = info.fetch(artist, [])
    tags += [genre, subgenre].compact.map(&:downcase)
    tags += tags_str.split(',').map(&:strip) unless tags_str.nil?
    
    Song.new name, artist, genre, subgenre, tags
  end

  attr_accessor :name, :artist, :genre, :subgenre, :tags

  def initialize(name, artist, genre, subgenre=nil, tags=[])
    @name, @genre, @tags = name, genre, tags
    @artist, @subgenre = artist, subgenre
  end
end

class Criteria
  def initialize(criteria)
    @criteria = criteria
  end
  
  def valid?(song)
    return true if @criteria.empty?
    @song = song
    @criteria.all? {|key, value| send "valid_by_#{key}?", value }
  end
  
  private
  
  def valid_by_filter?(filter)
    filter.( @song )
  end
  
  def valid_by_name?(name)
    name == @song.name
  end
  
  def valid_by_artist?(artist)
    artist == @song.artist
  end
  
  def valid_by_tags?(tags)
    Array(tags).all? {|tag| valid_by_tag? tag }
  end
  
  def valid_by_tag?(tag)
    tag.end_with?('!') ^ @song.tags.include?(tag.chomp '!')
  end
end

class Collection
  def initialize(db, information)
    @songs = db.lines.map {|row| Song.parse row, information}
  end
  
  def find( search_criteria = {} )
    criteria = Criteria.new search_criteria
    @songs.select {|song| criteria.valid? song}
  end
end
