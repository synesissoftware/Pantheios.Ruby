# ######################################################################## #
# File:         libclimate/version.rb
#
# Purpose:      Version for libclimate.Ruby library
#
# Created:      13th July 2015
# Updated:      5th July 2016
#
# Home:         http://github.com/synesissoftware/libCLImate.Ruby
#
# Copyright (c) 2015-2016, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #


module LibCLImate

	# Current version of the libCLImate.Ruby library
	VERSION					=	'0.6.2'

	private
	VERSION_PARTS_			=	VERSION.split(/[.]/).collect { |n| n.to_i } # :nodoc:
	public
	# Major version of the libCLImate.Ruby library
	VERSION_MAJOR			=	VERSION_PARTS_[0] # :nodoc:
	# # Minor version of the libCLImate.Ruby library
	VERSION_MINOR			=	VERSION_PARTS_[1] # :nodoc:
	# # Revision version of the libCLImate.Ruby library
	VERSION_REVISION		=	VERSION_PARTS_[2] # :nodoc:

end # module LibCLImate

# ############################## end of file ############################# #


