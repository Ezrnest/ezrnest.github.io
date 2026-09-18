require 'open3'

module Jekyll
  module HomepageLastUpdated
    TRACKED_PATHS = [
      '_pages/about.md',
      '_pages/about_en.md',
      '_bibliography/papers.bib',
      '_layouts/about.liquid',
      '_includes/selected_papers.liquid',
      '_plugins/homepage_last_updated.rb'
    ].freeze

    DATE_PATTERN = /\A\d{4}-\d{2}-\d{2}\z/

    def self.git_date(source)
      output, status = Open3.capture2(
        'git',
        '-C',
        source,
        'log',
        '-1',
        '--format=%cs',
        '--',
        *TRACKED_PATHS
      )
      date = output.strip
      date if status.success? && DATE_PATTERN.match?(date)
    rescue Errno::ENOENT
      nil
    end
  end

  Hooks.register :site, :post_read do |site|
    date = HomepageLastUpdated.git_date(site.source)
    site.data['homepage_last_updated'] = date if date
  end
end
