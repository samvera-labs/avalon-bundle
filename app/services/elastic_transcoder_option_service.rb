# Copyright 2011-2019, The Trustees of Indiana University and Northwestern
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
require 'aws-sdk'

class ElasticTranscoderOptionService
  # Returns default audio/video output options for ActiveEncode.
  # @param fileset the data to be persisted
  # @return an array of hashes of output options for audio/video
  def self.call(file_set)
    file_name = file_set.label
    options = { pipeline_id: Settings.aws.pipeline_id, masterfile_bucket: Settings.aws.masterfile_bucket }

    if file_set.audio?
      options[:outputs] = [{ key: "quality-medium/hls/#{file_name}",
                             preset_id: find_or_create_preset('ts', :audio, :medium).id,
                             segment_duration: '2' },
                           { key: "quality-high/hls/#{file_name}",
                             preset_id: find_or_create_preset('ts', :audio, :high).id,
                             segment_duration: '2' }]
    elsif file_set.video?
      options[:outputs] = [{ key: "quality-low/hls/#{file_name}",
                             preset_id: find_or_create_preset('ts', :video, :low).id,
                             segment_duration: '2' },
                           { key: "quality-medium/hls/#{file_name}",
                             preset_id: find_or_create_preset('ts', :video, :medium).id,
                             segment_duration: '2' },
                           { key: "quality-high/hls/#{file_name}",
                             preset_id: find_or_create_preset('ts', :video, :high).id,
                             segment_duration: '2' }]
    end

    [options]
  end

  def self.client
    @client ||= Aws::ElasticTranscoder::Client.new
  end

  def self.find_preset(container, format, quality)
    container_description = container == 'ts' ? 'hls' : container
    result = nil
    next_token = nil
    loop do
      resp = client.list_presets page_token: next_token
      result = resp.presets.find { |p| p.name == "avalon-#{format}-#{quality}-#{container_description}" }
      next_token = resp.next_page_token
      break if result.present? || next_token.nil?
    end
    result
  end

  def self.create_preset(container, format, quality)
    client.create_preset(preset_settings(container, format, quality)).preset
  end

  def self.find_or_create_preset(container, format, quality)
    find_preset(container, format, quality) || create_preset(container, format, quality)
  end

  def self.preset_settings(container, format, quality)
    templates = YAML.safe_load(File.read(Rails.root.join('config', 'encoding_presets.yml')), [Symbol])
    template = templates[:templates][format.to_sym].deep_dup.deep_merge(templates[:settings][format.to_sym][quality.to_sym])
    container_description = container == 'ts' ? 'hls' : container
    template.merge!(name: "avalon-#{format}-#{quality}-#{container_description}",
                    description: "Avalon Media System: #{format}/#{quality}/#{container_description}",
                    container: container)
  end
end
