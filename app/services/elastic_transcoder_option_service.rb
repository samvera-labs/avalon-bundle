require 'aws-sdk'

class ElasticTranscoderOptionService
  # Returns default audio/video output options for ActiveEncode.
  # @param fileset the data to be persisted
  # @return an array of hashes of output options for audio/video
  def self.call(file_set)
    # Defaults adapted from hydra-derivatives
    audio_encoder = self.audio_encoder

    if file_set.audio?
      [{ outputs = [{ key: "quality-medium/hls/#{file_name}", preset_id: self.find_or_create_preset('ts',:audio,:medium).id, segment_duration: '2' },
                    { key: "quality-high/hls/#{file_name}", preset_id: self.find_or_create_preset('ts',:audio,:high).id, segment_duration: '2' } }]
    elsif file_set.video?
      [{ outputs = [{ key: "quality-low/hls/#{file_name}", preset_id: self.find_or_create_preset('ts',:video,:low).id, segment_duration: '2' },
                    { key: "quality-medium/hls/#{file_name}", preset_id: self.find_or_create_preset('ts',:video,:medium).id, segment_duration: '2' },
                    { key: "quality-high/hls/#{file_name}", preset_id: self.find_or_create_preset('ts',:video,:high).id, segment_duration: '2' }] }]
    else
      []
    end
  end

  def self.client
    @client ||= Aws::ElasticTranscoder::Client.new
  end

  def find_preset(container, format, quality)
    container_description = container == 'ts' ? 'hls' : container
    result = nil
    next_token = nil
    loop do
      resp = self.client.list_presets page_token: next_token
      result = resp.presets.find { |p| p.name == "avalon-#{format}-#{quality}-#{container_description}" }
      next_token = resp.next_page_token
      break if result.present? || next_token.nil?
    end
    result
  end

  def read_preset(id)
    self.client.read_preset(id: id).preset
  end

  def create_preset(container, format, quality)
    self.client.create_preset(self.preset_settings(container, format, quality)).preset
  end

  def find_or_create_preset(container, format, quality)
    self.find_preset(container, format, quality) || self.create_preset(container, format, quality)
  end

  def self.preset_settings(container, format, quality)
    templates = YAML.load(File.read(File.join(Rails.root,'config','encoding_presets.yml')))
    template = templates[:templates][format.to_sym].deep_dup.deep_merge(templates[:settings][format.to_sym][quality.to_sym])
    container_description = container == 'ts' ? 'hls' : container
    template.merge!({
      name: "avalon-#{format}-#{quality}-#{container_description}",
      description: "Avalon Media System: #{format}/#{quality}/#{container_description}",
      container: container
    })
  end

  def self.audio_encoder
    @audio_encoder ||= Hydra::Derivatives::AudioEncoder.new
  end
end
