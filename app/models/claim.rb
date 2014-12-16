class Claim < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :subject

  def self.create_uid
    @unique_identifier = rand(5..99999999)
    if Claim.where("subject_uid = ?", @unique_identifier) != []
      self.create_uid
    end
    return @unique_identifier
  end


  def self.get_verbs
    @verbs = Claim.where("verb = ? AND object = ?", "is", "verb")
    @unique_verbs = []

    @verbs.each do |unique|
      if @unique_verbs.index(unique.subject) == nil
        @unique_verbs << {subject: unique.subject, count: 1}
      end
    end
    return @unique_verbs
  end


  def self.get_subjects
    @claims = Claim.all
    @unique_subjects = Claim.where("verb = ?", "exists")
    @subjects = []

    @unique_subjects.each do | unique |

      @count = 0
      @authors = []
      @types = []

      @claims.each do | claim |
          if unique.subject_uid == claim.subject_uid
            @count = @count + 1
            if @authors.index(claim[:author]) == nil
              @authors << claim.author
            end
            if claim.verb == "is" && @types.index(claim[:object]) == nil
              @types << claim.verb
            end
          end
        end

    @subjects << {
      :subject_uid => unique.subject_uid,
      :subject => unique.subject,
      :count => @count,
      :authors => @authors,
      :types => @types
      }
    end
    return @subjects
  end


end
