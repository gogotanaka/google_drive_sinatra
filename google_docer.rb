$venue_table = {
  "VenueId"                   => 1,
  "VenueName"                 => 2,
  "Notes"                     => 3,
  "LastUpdated"               => 4,
  "ProdVenueId"               => 5,
  "VenueDescription"          => 6,
  "VenueType"                 => 7,
  "Ambience"                  => 8,
  "PriceLevel"                => 9,
  "ContactName"               => 10,
  "Email"                     => 11,
  "Phone"                     => 12,
  "ContactTitle"              => 13,
  "Url"                       => 14,
  "Address"                   => 15,
  "City"                      => 16,
  "State"                     => 17,
  "PostalCode"                => 18,
  "CuisineType"               => 19,
  "Breakfast"                 => 20,
  "Lunch"                     => 21,
  "Dinner"                    => 22,
  "Break"                     => 23,
  "Appetizers"                => 24,
  "CoffeeTea"                 => 25,
  "JuiceSoftdrinks"           => 26,
  "BeerWine"                  => 27,
  "FullBar"                   => 28,
  "FoodProviderVenue"         => 29,
  "FoodProviderCaterer"       => 30,
  "FoodProviderBYO"           => 31,
  "BeverageProviderVenue"     => 32,
  "BeverageProviderCaterer"   => 33,
  "BeverageProviderBYO"       => 34,
  "WirelessInternet"          => 35,
  "ProjectorScreen"           => 36,
  "MicSpeaker"                => 37,
  "Tables"                    => 38,
  "Chairs"                    => 39,
  "Stage"                     => 40,
  "DanceFloor"                => 41,
  "SoundSystem"               => 42,
  "Lighting"                  => 43,
  "Parking"                   => 44,
  "FullKitchen"               => 45,
  "Decor"                     => 46,
  "Entertainment"             => 47,
  "SleepingRooms"             => 48,
}

$space_table = {
  "VenueId"          => 1,     
  "VenueName"        => 2,      
  "SpaceId"          => 3,             
  "SpaceName"        => 4,               
  "SpaceDescription" => 5,                      
  "Reception"        => 6,               
  "Banquet"          => 7,             
  "Theater"          => 8,             
  "Classroom"        => 9,               
  "Boardroom"        => 10,               
  "Size"             => 11,          
  "Height"           => 12,            
  "Privacy"          => 13,
}

class SheetBase
  attr_accessor :sheet

  def initialize(sheet)
    @sheet = sheet
  end

  def [](i,j)
    @sheet[i,j]
  end

  def []=(i,j,v)
    @sheet[i,j] = v
  end

  def save
    @sheet.save
  end

  def find(column_num, val)
    @sheet.rows.find { |e| e[column_num-1] == val.to_s }
  end

  def select(column_num, val)
    @sheet.rows.select { |e| e[column_num-1] == val.to_s }
  end
end

class VenueSheet < SheetBase
  def find(rabel, val)
    super($venue_table[rabel], val)
  end
end

class VenueSpaceSheet < SheetBase
end

class Venue
  attr_accessor :ary

  def initialize(ary)
    @ary = ary
  end

  def [](attr)
    @ary[$venue_table[attr]-1]
  end
end
