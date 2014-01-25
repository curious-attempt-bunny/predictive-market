module ApplicationHelper
  def currency(amount)
    "#{number_with_delimiter(amount.to_i)}&nbsp;<i class='fa fa-lightbulb-o'></i>".html_safe
  end
end
