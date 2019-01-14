DynamicSitemaps::Sitemap.draw do
  
  # default page size is 50.000 which is the specified maximum at http://sitemaps.org.
   per_page 50000

   #url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
      
   url lawyers_url, :last_mod => Lawyer.order(:updated_at=>:desc).limit(1).first.updated_at, :change_freq => 'monthly', :priority => 0.8
   
   ['Legal-Advice','Legal-Services'].each do |type|
     
     url lawyers_url + "#!/lawyers/#{type}/All-States", :last_mod => Lawyer.order(:updated_at=>:desc).limit(1).first.updated_at, :change_freq => 'monthly', :priority => 0.8
     
     State.with_approved_lawyers.each do |state|
       url lawyers_url + "#!/lawyers/#{type}/#{state.name}-lawyers", :last_mod => Lawyer.order(:updated_at=>:desc).limit(1).first.updated_at, :change_freq => 'monthly', :priority => 0.8
       
       PracticeArea.parent_practice_areas.with_approved_lawyers.each do |area|
         url lawyers_url + "#!/lawyers/#{type}/#{state.name}-lawyers/#{CGI::escape(area.name)}", :last_mod => Lawyer.order(:updated_at=>:desc).limit(1).first.updated_at, :change_freq => 'monthly', :priority => 0.8
                
         area.children.with_approved_lawyers.each do |child_area|
           url lawyers_url + "#!/lawyers/#{type}/#{state.name}-lawyers/#{CGI::escape(child_area.name)}", :last_mod => Lawyer.order(:updated_at=>:desc).limit(1).first.updated_at, :change_freq => 'monthly', :priority => 0.8
         end
        # url lawyers_url + "#!/lawyers/#{}", :last_mod => area.updated_at, :change_freq => 'monthly', :priority => 0.8
       end
      # url lawyers_url, :last_mod => state.updated_at, :change_freq => 'monthly', :priority => 0.8
     end
   end
   
   Lawyer.approved_lawyers.find_in_batches do |lawyers|
       lawyers.each do |lawyer|
        url attorney_url(lawyer, slug: lawyer.slug), :last_mod => lawyer.updated_at, :change_freq => 'monthly', :priority => 0.8
      end
   end
   
   Offering.find_in_batches do |offerings| 
     offerings.each do |offering|
       url offering_url(offering), :last_mod => offering.updated_at, :change_freq => 'monthly', :priority => 0.8
     end
   end

   # autogenerate   :offerings, :pages

end