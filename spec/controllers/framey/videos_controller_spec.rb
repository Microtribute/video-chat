require "spec_helper"

describe Framey::VideosController do
  before :each do
    @video_params = { video: {
      name: "ecf7c330-549c-012e-9d34-7c6d628c53d4",
      filesize: 123456,
      duration: 15.62,
      state: "uploaded",
      views: 0,
      data: {
        my_user_id: 1,
        video_title: "Contest Submission"
      },
      flv_url: "http://framey.com/videos/source/ecf7c330-549c-012e-9d34-7c6d628c53d4.flv",
      mp4_url: "http://framey.com/videos/source/ecf7c330-549c-012e-9d34-7c6d628c53d4.mp4",
      large_thumbnail_url: "http://framey.com/thumbnails/large/ecf7c330-549c-012e-9d34-7c6d628c53d4.jpg",
      medium_thumbnail_url: "http://framey.com/thumbnails/medium/ecf7c330-549c-012e-9d34-7c6d628c53d4.jpg",
      small_thumbnail_url: "http://framey.com/thumbnails/small/ecf7c330-549c-012e-9d34-7c6d628c53d4.jpg"
    } }
  end

  it "should post to #callback" do
    post :callback, @video_params
    response.response_code.should == 200
  end

  it "should correctly process framey callback" do
    expect {
      post :callback, @video_params
    }.to change(Framey::Video, :count).by(1)
  end
end
