module Helpers
  def mock_adapter
    @adapter = spy('ActiveCash::Adapter')
    ActiveCash::TestAdapter.stub(:spy_object).and_return(@adapter)
    ActiveCash::Cache.stub(:adapter).and_return(ActiveCash::TestAdapter)
  end
  alias_method :remock_adapter, :mock_adapter
end
