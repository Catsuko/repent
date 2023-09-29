require 'formatters/split'
require 'formatters/plain'
require 'formatters/coloured'
require 'formatters/justified'
require 'formatters/with_names'

module Repent
  module Formatters
    def self.messenger(name)
      Split.new(
        'system',
        on_match: Coloured.new(:silver),
        fallback: Split.new(
          name,
          on_match: Justified.new(Coloured.new(:blue), left: false),
          fallback: Justified.new(
            WithNames.new(Plain.new, name_formatter: Coloured.new(:dimgray)), left: true
          )
        )
      )
    end
  end
end
