module PagesHelper
  include ActsAsTaggableOn::TagsHelper

  def rank_button(page,prop)
    page = Page.find(page)
    case prop
    when "Risk"
      page_prop = page.risk
    when "Priority"
      page_prop = page.priority
    end
    
    case page_prop
        when 1
          word = "Low"
          btn_class = "success"
        when 2
          word = "Medium"
          btn_class = "warning"
        when 3
          word = "High"
          btn_class = "danger"
        else
          word = ""
          btn_class = "primary"
    end

    if page_prop == nil && current_user.try(:admin?)
      word = "Set"
      disabled_state = nil
      btn_class = "default"
    elsif page_prop == nil && !current_user.try(:admin?)
      word = "Unset"
      disabled_state = "disabled"
      btn_class = "default"
    elsif !current_user.try(:admin?)
      disabled_state = "disabled"
    end

    
    capture_haml do
      haml_tag :button,
               :class => "btn btn-#{btn_class} dropdown-toggle btn-xs",
               "data-toggle" => "dropdown",
               :type => "button",
               :disabled => disabled_state do
                 haml_concat "#{word} #{prop}"
                 if current_user.try(:admin?)
                   haml_tag :span, :class => "caret"
                 end
      end
   end
  end
    


  def page_voters(page)
    if page.get_upvotes.count > 0
      voters = []
      page.get_upvotes.each do |v|
        if v.voter == current_user
          voters << "You"
        else
          voters << v.voter.handle
        end
      end
      return voters.to_sentence
    else
      return false
    end
  end

  
  def jira_url(page, params = {})
    params[:pid] = 10121
    params[:priority] = 6
    jira_desc_text = <<JIRA_DESC
File: {{#{page.filename}}}
Project/Version: #{page.project.display_name} #{page.version.version_number}
---

Replace this text with your issue description, and please also edit the "Summary" field at the top of the page.

JIRA_DESC

    params[:description] = jira_desc_text

    if current_user && current_user.jira_name != nil
      params[:reporter] = current_user.jira_name
    else
      params[:reporter] = nil
    end
    
    if page.has_owner && User.exists?(page.user_id) && page.user.has_jira_name
      params[:assignee] = page.user.jira_name
    else
      params[:assignee] = ""
    end
    
    if params[:issuetype] == 1
      params[:summary] = "Please describe the bug on this page."
    else
      params[:summary] = "Please describe your suggested improvement for this page."
    end

    uri = URI("http://tickets.puppetlabs.com/secure/CreateIssueDetails!init.jspa")
    uri.query = params.to_query
    uri.to_s
  end

  def tag_link(tag)
    if tag.match(/JIRA-\w{3,}-\d{1,}/)
      jira_tag = tag.sub(/^JIRA\-/,"")
      link_to tag.upcase, "http://tickets.puppetlabs.com/browse/#{jira_tag}", :class => "btn btn-default btn-xs"
    else
      link_to tag.downcase, "/tags/#{tag}", :class => "btn btn-default btn-xs"
    end
  end
  
end


