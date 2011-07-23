module ApplicationHelper
  def page?
    return false unless signed_request
    page ? true : false
  end
  def page
    @page ||= signed_request.page
  end
  def canvas?
    return false unless signed_request
    !page?
  end
  def signed_request
    @signed_request
  end
end
