require 'formatters/split'
require 'formatters/plain'
require 'formatters/coloured'
require 'formatters/justified'
require 'formatters/with_names'
require 'formatters/wrapped'

module Repent
  module Formatters
    def self.messenger(name)
      plain = Wrapped.new(Plain.new)
      Split.new(
        'system',
        on_match: Coloured.new(plain, color: :silver),
        fallback: Split.new(
          name,
          on_match: Justified.new(
            Coloured.new(plain, color: :blue), left: false
          ),
          fallback: Justified.new(
            WithNames.new(plain, name_formatter: Coloured.new(plain, color: :dimgray)), left: true
          )
        )
      )
    end
  end
end
