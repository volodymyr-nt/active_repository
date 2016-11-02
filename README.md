# Active Repository
Proof of concept implementation of repository pattern on top of ActiveRecord.
Partially compabile with ActiveRecord scopes.




### Define repository:
``` ruby
class EventRepository
  include ActiveRepository::Base

  adapter Event
   
  scope :actual, -> { where('events.event_close > ?', Time.current) }
  
  scope :published, -> { where(status: 'published') }
  
  scope :actual_and_published, -> { actual.published }
  
  scope :by_name, -> (name) {
    where('name LIKE ?', "%#{name}%") if name.present?
  }
  
  scope :by_city_id, -> (city_id) {
    where(city_id: city_id) if city_id.present?
  }
  
  scope :by_venue_id, -> (venue_id) {
    where(venue_id: venue_id) if venue_id.present?
  }
end
```

### Usage:
``` ruby
# create a repository instance
event_repository = EventRepository.new

# make query
actual_events = event_repository.actual

# queries can be chained together 
actual_events_in_lviv = event_repository.actual.by_city_id(lviv_city.id)
```
