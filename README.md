# Active Repository
Proof of concept implementation of repository pattern on top of ActiveRecord.
Partially compabile with ActiveRecord scopes.


## Usage

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
  
  scope :by_venue, -> (venue_id) {
    where(venue_id: venue_id) if venue_id.present?
  }
end
```

