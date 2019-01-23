# frozen_string_literal: true

namespace :batch do
  desc "Starts Scanning for Avalon batch ingest"
  task :hyrax_batch_ingest => :environment do
    require 'avalon/batch/ingest'

    WithLocking.run(name: 'batch_ingest') do
      logger.info "<< Scanning for unprocessed batch manifests for existing admin sets >>"
      AdminSet.all.each do |admin_set|
        Hyrax::BatchIngest::AvalonBatchScanner.new(admin_set).scan
      end
    end
  end
end
