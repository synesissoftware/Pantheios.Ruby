
module Pantheios
module ApplicationLayer

# Type-distinct +::Array+ for use with tracing, as in
#
#    def my_func arg1, arg2, **options
#
#        trace ParamNames [ :arg1, :arg2, :options ], arg1, arg2, options
#
#    end
#
class ParamNameList < Array
end

# Another name for +ParamNameList+
ParamNames = ParamNameList

end # module ApplicationLayer
end # module Pantheios


