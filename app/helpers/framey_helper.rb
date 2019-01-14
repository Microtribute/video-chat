module FrameyHelper
  # This method renders the Framey video player from within an ActionView in your Rails app.
  #
  # Example Usage (assuming ERB):
  #    <%= javascript_include_tag "swfobject" %>
  #    <%= render_player({
  #      :video_url => "[video url]",          # the video url received in the callback (required)
  #      :thumbnail_url => "[thumbnail url]",  # the thumbnail url received in the callback (required)
  #      :progress_bar_color => "0x123456",    # the desired color for the progress bar (optional, defaults to black)
  #      :volume_bar_color => "0x123456",      # the desired color for the volume bar (optional, defaults to black)
  #      :id => "[some id]"                    # the id of the flash embed object (optional, random by default)
  #    }) %>
  def render_player(opts={})
    video_url = opts[:video_url] || "#{Framey::API_HOST}/videos/#{opts[:video_name]}/source.flv"
    thumbnail_url = opts[:thumbnail_url] || "#{Framey::API_HOST}/videos/#{opts[:video_name]}/thumbnail.jpg"
    
    divid = "frameyPlayerContainer_#{(rand*999999999).to_i}"
    objid = opts[:id] || "the#{divid}"
    
    progress_bar_color = "#{opts[:progress_bar_color]}"
    volume_bar_color = "#{opts[:volume_bar_color]}"
    
raw <<END_PLAYER
    <div id="#{divid}"></div>
    <script type="text/javascript">
    var flashvars = {
      'video_url': "#{video_url}",
      'thumbnail_url': "#{thumbnail_url}",
      "progress_bar_color": "#{progress_bar_color}",
      "volume_bar_color": "#{volume_bar_color}"
    };

    var params = {
      'allowfullscreen': 'true',
      'allowscriptaccess': 'always',
      "wmode": "transparent"
    };

    var attributes = {
      'id': "#{objid}",
      'name': "#{objid}"
    };

    swfobject.embedSWF("/player.swf", "#{divid}", '340', '290', '9', 'false', flashvars, params, attributes);
    </script>
END_PLAYER
  end
end
