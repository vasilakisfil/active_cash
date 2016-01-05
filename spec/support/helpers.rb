module Helpers
  def mock_adapter
    @adapter = spy('ActiveCash::Adapter')
    allow(ActiveCash::TestAdapter).to(receive(:spy_object).and_return(@adapter))
    allow(ActiveCash::Cache).to(receive(:adapter).and_return(ActiveCash::TestAdapter))
  end
  alias_method :remock_adapter, :mock_adapter
end
