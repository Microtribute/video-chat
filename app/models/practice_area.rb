class PracticeArea < ActiveRecord::Base
  default_scope order("name ASC")
  
  has_many :specialities, 
    :class_name => "PracticeArea", 
    :foreign_key => "parent_id", 
    :dependent => :destroy
  
  belongs_to :main_area, 
    :class_name => "PracticeArea", 
    :foreign_key => "parent_id",
    :touch => true

  has_many :expert_areas
  has_many :lawyers, :through => :expert_areas
  has_many :offerings

  has_many :children, 
    :class_name => "PracticeArea",
    :foreign_key => :parent_id

  scope :with_approved_lawyers,
    joins(:lawyers)
    .where(["#{Lawyer.table_name}.is_approved = ?", true])
    .group("#{table_name}.id")

  scope :parent_practice_areas, lambda { where(:parent_id => nil) }
  scope :child_practice_areas, lambda { where("parent_id is not null") }
  scope :parent_practice_areas_having_lawyers, joins(:expert_areas, :lawyers).where(:parent_id => nil).select("distinct(practice_areas.id)")
  
  scope :child_practice_areas_having_lawyers, joins(:expert_areas, :lawyers).where("parent_id is not null").select("distinct(practice_areas.id)")

  scope :name_like, lambda{|name|
    name_parts = name.gsub(/-/,' ').split(/[^\w]+/)
    quoted_name_parts = name_parts.collect{|n| 
      self.connection.quote_string(n)
    }
    regex = quoted_name_parts.join("[ \-\/]+").downcase
    where("LOWER(name) REGEXP '^#{regex}$'")
  }

  # name of its parent practice area
  def parent_name 
    self.main_area.present? ? self.main_area.name : nil
  end

  def is_national?
    if self.is_national == nil
      false
    else
      self.is_national
    end
  end

  def name_for_url
    return '' unless self.name
    self.name.squish.gsub(/\s/,'-')
  end  

  def selected? area_id = nil
    return false unless area_id
    return true if self.id == area_id
    self.children_include? area_id, true
  end

  def children_include? area_id = nil, approved = false
    return false unless area_id
    chldrn = approved ? self.children.with_approved_lawyers : self.children
    return false unless chldrn.present?
    chldrn.exists?(area_id)
  end

end

