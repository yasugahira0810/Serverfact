RSpec::Support.require_rspec_core "formatters/base_text_formatter"
RSpec::Support.require_rspec_core "formatters/console_codes"

class ServerfactFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :message, :dump_summary, :dump_failures, :dump_pending, :seed

  def dump_failures(notification)
  end

end
