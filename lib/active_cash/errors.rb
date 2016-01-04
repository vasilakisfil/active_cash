class ActiveCashError < StandardError
end

class RedefinedCacheError < ActiveCashError
end

class UnknownCacheTypeError < ActiveCashError
end

class FindByOptionsMismatchError < ActiveCashError
end
