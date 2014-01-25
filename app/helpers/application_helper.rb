module ApplicationHelper
  def currency(amount)
    "#{'%.2f' % amount}&nbsp;<i class='fa fa-lightbulb-o'></i>".html_safe
  end
end
