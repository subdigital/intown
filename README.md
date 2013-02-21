# Tourbus

A gem to consume the Bandsintown 2.0 API.  Supports finding artists by name, MusicBrainz ID, & Facebook Page Id.  Supports returning events by artist & optional date range.

## Installation

Add this line to your application's Gemfile:

    gem 'tourbus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tourbus

## Usage

Set your "app_id" configuration before making any calls.  In a Rails app, this would go in `config/initializers/tourbus.rb`.

    Tourbus.configure do |config|
		  config.app_id = <YOUR APP ID HERE>
		end		

### Fetching an artist

    Tourbus::Artist.fetch(params)

Params should be one of the following:

    {:name => "Radiohead"}
		{:mbid => "<band's MusicBrainz ID>"}
		{:fbid => "<band's Facebook page ID>"}

Returns an object that responds to the API attributes in the [Bandsintown API documentation](http://www.bandsintown.com/api/responses#artist-json)

Returns nil if the band cannot be found.

### Fetching events for an artist

    Tourbus::Event.list(params)

Params should identify the artist to search for (see above).  Params may also include one of the following date options:

	 {:upcoming => true}        # default: only returns future events
	 {:all => true}             # returns all events for this artist
	 {:date => 3.days.from_now} # returns all events on the specified date
	 {:from => 3.days.ago, :to => 5.days.from_now } # returns all events in the date range (inclusive)

Returns an object that responds to the API attributes in the [Bandsintown API documentation](http://www.bandsintown.com/api/responses#event-json)

Returns nil if the band does not exist.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This code is provided under the MIT license.  See LICENSE.txt for more details.