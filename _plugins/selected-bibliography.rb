require 'jekyll/scholar'
require 'liquid'

module Jekyll
  module Tags
    class SelectedBibliographyTag < Liquid::Tag
      DEFAULT_ARGS = '--cited_in_order --group_by none'.freeze

      def render(context)
        page = context['page'] || {}
        keys = Array(page['selected_papers_keys']).flatten.compact.map(&:to_s).reject(&:empty?)
        return '' if keys.empty?

        original_page_cited = page['cited']
        original_context_cited = context['cited']
        page['cited'] = keys

        Jekyll::Scholar::BibliographyTag
          .new('bibliography', DEFAULT_ARGS, Liquid::ParseContext.new)
          .render(context)
      ensure
        page['cited'] = original_page_cited if page
        context['cited'] = original_context_cited
      end
    end
  end
end

Liquid::Template.register_tag('selected_bibliography', Jekyll::Tags::SelectedBibliographyTag)
