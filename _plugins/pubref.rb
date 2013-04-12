# References to publications mae by pubindex generator
# Use these on the homepage to call out recent papers/talks

module Jekyll
    class PubRefTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            # @text = text
            @fname = text.strip
            puts "initialize PubRefTag"
            puts tag_name
            puts @fname
        end

        def render(context)
            site = context.registers[:site]
            # Get type of publication from filename
            pubType = @fname.split('/').first
            # Make full path to yml in _publications/ dir
            fullPath = File.join(site.config['source'], "_publications/" + @fname)
            # Load publication YAML
            pubData = YAML.load(File.read(fullPath))
            key = File.basename(fullPath, '.yml')
            if pubType == 'published'
                output = render_published(pubData, key)
            elsif pubType == 'theses'
                output = render_thesis(pubData, key)
            elsif pubType == 'talks'
                output = render_talk(pubData, key)
            elsif pubType == 'conference'
                output = render_conference(pubData, key)
            elsif pubType == 'unpublished'
                output = render_unpublished(pubData, key)
            else
                puts "no type known"
            end
            return output
        end

        def render_published(pubData, key)
            puts "render_published"
            n = pubData['authors'].size
            puts n
            if n > 3
                authorStr = pubData['authors'].slice(0, 3).join(", ") + " et al."
            else
                authorStr = pubData['authors'].join(", ")
            end
            puts authorStr
            "<p>" + render_title(pubData, key) + " (#{pubData['year']}). #{authorStr}.</p>"
        end

        def render_thesis(pubData, key)
             "<p>" + render_title(pubData, key) + " (#{pubData['year']}/#{pubData['month']}). #{pubData['level']} thesis.</p>"
        end

        def render_talk(pubData, key)
             "<p>" + render_title(pubData, key) + " (#{pubData['year']}/#{pubData['month']}/#{pubData['day']}). #{pubData['note']}.</p>"
        end

        def render_unpublished(pubData, key)
             "<p>" + render_title(pubData, key) + " (#{pubData['year']}). #{pubData['note']}.</p>"
        end

        def render_conference(pubData, key)
             "<p>" + render_title(pubData, key) + " (#{pubData['year']}/#{pubData['month']}). #{pubData['conf']}.</p>"
        end

        def render_title(pubData, key)
            "<a class='pubref-title' href='/publications.html##{key}'>#{pubData['title']}</a>"
        end
    end
end

Liquid::Template.register_tag('pubref', Jekyll::PubRefTag)
