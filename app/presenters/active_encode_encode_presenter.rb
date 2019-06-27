# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

# Generated via
#  `rails generate hyrax:work AudiovisualWork`

class ActiveEncodeEncodePresenter
  include ActionView::Helpers::NumberHelper

  def initialize(encode_record)
    @encode_record = encode_record
  end

  def status
    @encode_record.state.capitalize
  end

  def id
    @encode_record.global_id.split('/').last
  end

  def progress
    JSON.parse(@encode_record.raw_object)["percent_complete"]
  end

  def title
    @encode_record.title.split('/').last
  end

  def started
    DateTime.parse(JSON.parse(@encode_record.raw_object)["created_at"]).strftime('%D %r')
  end

  def ended
    DateTime.parse(JSON.parse(@encode_record.raw_object)["updated_at"]).strftime('%D %r')
  end

  def adapter
    @encode_record.adapter
  end

  def raw_object
    @encode_record.raw_object
  end

  def errors
    JSON.parse(@encode_record.raw_object)["errors"]
  end

end
