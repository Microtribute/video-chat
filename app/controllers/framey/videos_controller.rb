module Framey
  class VideosController < ApplicationController
    before_filter :authenticate, only: [:index, :destroy]

    def index
      @lawyer = Lawyer.find(current_user.id)
      @video = Framey::Video.find_by_creator_id(@lawyer) if @lawyer.has_video?
    end

    def destroy
      @video = Framey::Video.find(params[:id])

      if @video.destroy
        redirect_to framey_videos_path
      end
    end

    def callback
      Video.create!({
        name: params[:video][:name],
        filesize: params[:video][:filesize],
        duration: params[:video][:duration],
        state: params[:video][:state],
        views: params[:video][:views],
        flv_url: params[:video][:flv_url],
        mp4_url: params[:video][:mp4_url],
        small_thumbnail_url: params[:video][:small_thumbnail_url],
        large_thumbnail_url: params[:video][:large_thumbnail_url],
        creator_id: params[:video][:data][:creator_id]
      })

      render text: "" and return
    end
  end
end
