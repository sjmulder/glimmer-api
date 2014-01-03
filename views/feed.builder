xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title @app.title
    xml.link  @app.feed_url(@base_url)
    
    @releases.each do |release|
      xml.item do
        xml.title   release.full_title
        xml.link    release.package_url
        xml.pubDate Time.parse(release.created_at.to_s).rfc822()
        xml.guid    release.url(@base_url)

        xml.glimmer :manifestLink, release.manifest_url(@base_url)

        if release.release_notes_html
          xml.sparkle :releaseNotesLink, release.release_notes_url(@base_url)
        end
      end
    end
  end
end
