class Util

  def self.status_updater
    while
      lawyers = User.where("user_type='LAWYER' and is_approved=true and last_online is not null")
      i = 0
      lawyers.each {|lawyer|
        status = (Time.now - lawyer.last_online.to_time)/60 < 2 ? true : false
        update_status = lawyer.update_attribute(:is_online, status)
        puts "id: #{lawyer.id} status: #{status} update_status: #{update_status}"
        if !status && lawyer.is_busy?
          lawyer.update_attribute(:is_busy, false)
        end
        i+=1
      }
      sleep(120)
    end
  end

end

