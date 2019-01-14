class SolrSearchController < ApplicationController
 # with :first_name,       params[:name]
 # with :last_name,        params[:name]
 # with :practice_areas,   params[:practise_area]
 # with :personal_tagline, params[:personal_tagline]
 # with :law_school,       params[:law_school]
 # with :states,           params[:state]
 # with :reviews,          params[:review]
 # with :school,           params[:school]
 # with :bar_memberships,  params[:bar_membership]
 def search_query_c
    q = Lawyer.search do
      
      #all_search
        with :first_name,       params[:generic_search]
        with :last_name,        params[:generic_search]
        with :practice_areas,   params[:generic_search]
        with :personal_tagline, params[:generic_search]
        with :law_school,       params[:generic_search]
        with :states,           params[:generic_search]
        with :reviews,          params[:generic_search]
        with :school,           params[:generic_search]
        with :bar_memberships,  params[:generic_search]
      
    end
  return q.results
 end 
 
 
  #q = Lawyer.search {with :practice_areas, "Wills and Estates"}

end
