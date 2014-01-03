xml.instruct! :xml, :version => '1.0'
xml.declare! :DOCTYPE, :plist, :PUBLIC,
             '-//Apple//DTD PLIST 1.0//EN',
             'http://www.apple.com/DTDs/PropertyList-1.0.dtd'
xml.plist do
  xml.dict do
    xml.key 'items'
    xml.array do
      xml.dict do
        xml.key 'assets'
        xml.array do
          xml.dict do
            xml.key    'kind'
            xml.string 'software-package'
            xml.key    'url'
            xml.string @release.package_url
          end
          unless @release.icon_url.nil?
            xml.dict do
              xml.key    'kind'
              xml.string 'display-image'
              xml.key    'needs_shine'
              xml.tag!   @release.icon_needs_shine ? 'true' : 'false'
              xml.key    'url'
              xml.string @release.icon_url
            end
          end
          unless @release.artwork_url.nil?
            xml.dict do
              xml.key    'kind'
              xml.string 'full-size-image'
              xml.key    'needs_shine'
              xml.tag!   @release.artwork_needs_shine ? 'true' : 'false'
              xml.key    'url'
              xml.string @release.artwork_url
            end
          end
        end
        xml.key 'metadata'
        xml.dict do
          xml.key    'bundle-identifier'
          xml.string @release.bundle_identifier
          xml.key    'bundle-version'
          xml.string @release.version
          xml.key    'kind'
          xml.string 'software'
          xml.key    'title'
          xml.string @app.title
        end
      end
    end
  end
end
