class ClaimsController < ApplicationController
  before_action :current_user
  before_action :confirm_logged_in



#load the main index / search page
def index
end

#get json for a verbs typeahead
def return_verbs
  @verbs = Claim.get_verbs
  render :json => @verbs
end

def return_subjects
  @subject = Claim.get_subjects
  render :json => @subject
end

def return_objects
  @objects = Claim.get_objects
  render :json => @objects
end




#bruteforce claim creation, admin only
def new
  @claim = Claim.new
end


def create
  @claim_verb = params[:claim][:verb]
  @claim_object = params[:claim][:object]
  @claim_subject = params[:claim][:subject]
  @claim_subject_uid = params[:claim][:subject_uid]

    if @claim_verb != "exists"

      #verb subject addition
      if Claim.where("subject = ?", @claim_verb) == []
        @verb_rand = Claim.create_uid
        @claim = Claim.create(:author => @current_user, :subject_uid => @verb_rand, :subject => @claim_verb, :verb => "exists", :object => "none")
        if Claim.where("verb = ?", @claim_verb) == []
          @claim = Claim.create(:author => @current_user, :subject_uid => @verb_rand, :subject => @claim_verb, :verb => "is", :object => "verb")
        end
      end

      #object subject addition
      if Claim.where("subject = ?", @claim_object) == []
        @object_rand = Claim.create_uid
        @claim = Claim.create(:author => @current_user, :subject_uid => @object_rand, :subject => @claim_object, :verb => "exists", :object => "none")
        if Claim.where("object = ?", @claim_object) == []
          @claim = Claim.create(:author => @current_user, :subject_uid => @object_rand, :subject => @claim_object, :verb => "is", :object => "object")
        end
      end

      #create the declaired claim and subject if missing
      if params[:claim][:subject_uid] == nil
        @subject_rand = Claim.create_uid
        @claim = Claim.create(:author => @current_user, :subject_uid => @subject_rand, :subject => @claim_subject, :verb => "exists", :object => "none")
        @claim = Claim.create(:author => @current_user, :subject_uid => @subject_rand, :subject => @claim_subject, :verb => "is", :object => "subject")
        @claim = Claim.create(claim_params.merge(:author => @current_user, :subject_uid => @subject_rand))
      else
        @claim = Claim.create(claim_params.merge(:author => @current_user))
      end

      respond_to do |format|
        format.json { render :json => @claim_subject_uid }
        format.html { redirect_to(claims_path) }
      end

    else

      @subject_rand = Claim.create_uid
      @claim = Claim.create(:author => @current_user, :subject_uid => @subject_rand, :subject => @claim_subject, :verb => "exists", :object => "none")
      @claim = Claim.create(:author => @current_user, :subject_uid => @subject_rand, :subject => @claim_subject, :verb => "is", :object => "subject")

      respond_to do |format|
        format.json { render :json => @subject_rand }
      end

    end
end


def show
  @claims = Claim.where("subject_uid = ?", params[:id])
end



private
  def claim_params
    params.require(:claim).permit(:subject_uid, :subject, :verb, :object, :author)
  end

end
