# frozen_string_literal: true

namespace :batch do
  desc "Starts Scanning for Avalon batch ingest"
  task :hyrax_batch_ingest => :environment do
    require 'avalon/batch/ingest'

    WithLocking.run(name: 'batch_ingest') do
      logger.info "<< Scanning for new batch packages in existing collections >>"
      Admin::Collection.all.each do |collection|
        Avalon::Batch::Ingest.new(collection).scan_for_packages
      end
    end
  end
end
