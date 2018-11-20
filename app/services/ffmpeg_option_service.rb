class FfmpegOptionService
  # Returns default audio/video output options for ActiveEncode.
  # @param fileset the data to be persisted
  # @return an array of hashes of output options for audio/video
  def self.call(file_set)
    # Defaults adapted from hydra-derivatives
    audio_encoder = self.audio_encoder

    if file_set.audio?
      [{ outputs: [{ label: 'high', extension: 'mp4', ffmpeg_opt: "-ac 2 -ab 192k -ar 44100 -acodec #{audio_encoder.audio_encoder}" },
                   { label: 'medium', extension: 'mp4', ffmpeg_opt: "-ac 2 -ab 128k -ar 44100 -acodec #{audio_encoder.audio_encoder}" }] }]
    elsif file_set.video?
      [{ outputs: [{ label: 'high', extension: 'mp4', ffmpeg_opt: "-s 1920x1080 -g 30 -b:v 800k -ac 2 -ab 192k -ar 44100 -vcodec libx264 -acodec #{audio_encoder.audio_encoder}" },
                   { label: 'medium', extension: 'mp4', ffmpeg_opt: "-s 1280x720 -g 30 -b:v 500k -ac 2 -ab 128k -ar 44100 -vcodec libx264 -acodec #{audio_encoder.audio_encoder}" },
                   { label: 'low', extension: 'mp4', ffmpeg_opt: "-s 720x360 -g 30 -b:v 300k -ac 2 -ab 96k -ar 44100 -vcodec libx264 -acodec #{audio_encoder.audio_encoder}" }] }]
    else
      []
    end
  end

  def self.audio_encoder
    @audio_encoder ||= Hydra::Derivatives::AudioEncoder.new
  end
end
